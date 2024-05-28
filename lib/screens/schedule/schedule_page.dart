import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

class SchedulePage extends StatefulWidget {
  static const String routeName = '/appointment';

  RemoteMessage? message;

  SchedulePage({super.key, required this.message});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with TickerProviderStateMixin {
  final RemoteMessage message = const RemoteMessage();

  final kToday = DateTime.now();
  final kFirstDay = DateTime(2017, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  bool _isLoadingPendingEvents = true;
  bool _isLoadingTSIS = true;

  @override
  void initState(){
    super.initState();
    _pendingEvents = [];
    _tsis = [];
    _selectedDay = _focusedDay;

    //calling session data
    CheckSessionData().getUserSessionStatus().then((userSession) {
      if (userSession == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getTsis();
          _getPendingEvents();
        });
        userSessionFuture = userSession;
      } else {
        userSessionFuture = userSession;
      }
    });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
  }

  late List<EventsData> _pendingEvents;
  _getPendingEvents(){
    if(userInfo?.status == "Employee") {
      ScheduleDataServices.getPendingEvents().then((pendingEvent){
        setState(() {
          _pendingEvents = pendingEvent.where((e) => _isUserAssigned(e.engineer, userInfo!.username) || _isUserAssigned(e.technician, userInfo!.username)).toList();
        });
        _isLoadingPendingEvents = false;
      });
    } else {
      ScheduleDataServices.getPendingEvents().then((pendingEvent){
        setState(() {
          _pendingEvents = pendingEvent;
        });
        _isLoadingPendingEvents = false;
      });
    }
  }

  late List<TSISData> _tsis;
  _getTsis(){
    if(userInfo?.status == "Employee") {
      ScheduleDataServices.getTSIS().then((tsis){
        setState(() {
          _tsis = tsis.where((e) => _isUserAssigned(e.personCharge, userInfo!.username) || _isUserAssigned(e.technician, userInfo!.username)).toList();
        });
        _isLoadingTSIS = false;
      });
    } else {
      ScheduleDataServices.getTSIS().then((tsis){
        setState(() {
          _tsis = tsis;
        });
        _isLoadingTSIS = false;
      });
    }
  }

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }
    return false;
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Technical Schedule', imagePath: 'assets/logo/enyecontrols.png',),
      resizeToAvoidBottomInset: true,
      body: _isLoadingPendingEvents || _isLoadingTSIS
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  _getPendingEvents();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //_addTaskBar(),
                  _addDateBar(),

                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _pendingEvents.length,
                        itemBuilder: (_, index){

                          EventsData event = _pendingEvents[index];
                          List<TSISData> tsisList = _tsis.where((tsis) => tsis.tsisId == event.tsisId).toList();
                          if (tsisList.isNotEmpty) {
                            TSISData tsis = tsisList[0];

                            if (DateFormat.yMd().format(DateTime.parse(event.start)) == DateFormat.yMd().format(_selectedDay!)
                                || DateFormat.yMd().format(DateTime.parse(event.end)) == DateFormat.yMd().format(_selectedDay!)
                                || (_selectedDay!.isAfter(DateTime.parse(event.start)) && _selectedDay!.isBefore(DateTime.parse(event.end)))){
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                  child: FadeInAnimation(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            print('selected Date: ${_selectedDay.toString()}');
                                            _showBottomSheet(context, tsis, _selectedDay.toString(), event);
                                          },
                                          child: ScheduleTaskTile(tsis: tsis, event: event,),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }

                          } else {
                            return Container();
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _showBottomSheet (BuildContext context, TSISData tsis, String selectedDay, EventsData event) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: (_isUserAssigned(tsis.personCharge, userInfo!.username) || _isUserAssigned(tsis.technician, userInfo!.username) ||
                _isUserAssigned(event.engineer, userInfo!.username) || _isUserAssigned(event.technician, userInfo!.username))
                ? MediaQuery.of(context).size.height * 0.34
                : MediaQuery.of(context).size.height * 0.24,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                  ),
                ),

                const Spacer(),
                Container(),

                (_isUserAssigned(tsis.personCharge, userInfo!.username) || _isUserAssigned(tsis.technician, userInfo!.username) ||
                    _isUserAssigned(event.engineer, userInfo!.username) || _isUserAssigned(event.technician, userInfo!.username))
                ? _bottomSheetButton(
                  label: "Service Order",
                  onTap: (){
                    setState(() {
                      // Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SOPage(tsis: tsis, selectedDay: selectedDay, event: event)),
                      );
                    });
                  },
                  clr: Colors.blueAccent,
                  context:context,
                ): Container(),

                // (services.status == "On Process" && userInfo?.status != "Employee") ?
                // _bottomSheetButton(
                //   label: "Task Completed",
                //   onTap: (){
                //     setState(() {
                //       Navigator.pop(context);
                //       // _showAnotherBottomSheet(context, services, "Task Completed", appointment);
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => TaskCompletedPage(services: services, appointment: appointment, selectedDay: selectedDay)),
                //       ).then((value) {
                //         // Refresh the services once the StatusPage is popped
                //         _getServices();
                //         _getOnProcessAppointment();
                //         _getAccounts();
                //         _getPositions();
                //         _getServiceOrder();
                //         setState(() {});
                //       });
                //     });
                //   },
                //   clr: Colors.green,
                //   context:context,
                // ): Container(),

                const SizedBox(height: 10,),
                _bottomSheetButton(
                  label: "View",
                  onTap: (){
                    setState(() {
                      Navigator.pop(context);
                      // _showAnotherBottomSheet(context, services, "View", appointment);
                    });
                  },
                  clr: Colors.orangeAccent,
                  context:context,
                ),

                const SizedBox(height: 20,),
                _bottomSheetButton(
                  label: "Close",
                  onTap: (){
                    Navigator.pop(context);
                  },
                  clr: Colors.orangeAccent,
                  context:context,
                  isClose: true,
                ),

                const SizedBox(height: 10,),
              ],
            ),
          );
        }
    );
  }

  _bottomSheetButton ({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: isClose == true ? Colors.grey.shade300 : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? const TextStyle(color: Colors.black, fontWeight: FontWeight.bold) : const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _addDateBar () {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: TableCalendar (
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        /*eventLoader: (day) => _services.where((services) => isSameDay(DateTime.parse(services.dateSched),day)).toList(),*/
        eventLoader: (day) {
          return _pendingEvents.where((pendingEvent) {

              // Check if the service date is within the specified range
              DateTime startDate = DateTime.parse(pendingEvent.start.toString()); // Remove "00:00:00"
              DateTime endDate = DateTime.parse(pendingEvent.end.toString());   // Remove "00:00:00"

              if(startDate == endDate){
                return isSameDay(startDate,day);
              } else if (isSameDay(day, startDate)
                  || (day.isAfter(startDate) && day.isBefore(endDate))) {
                return true;
              } else if (isSameDay(day, endDate)
                  || (day.isAfter(startDate) && day.isBefore(endDate))) {
                return true;
              } else {
                return false;
              }

          }).toList();
        },
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          weekendTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              )
          ),
          weekNumberTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              )
          ),
          defaultTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 12,
              )
          ),
          selectedDecoration: const BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Colors.deepOrange.shade100, shape: BoxShape.circle),
          todayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              )
          ),
          markersAlignment: Alignment.bottomCenter,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) => events.isNotEmpty
              ? Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade400,
            ),
            child: Text(
              '${events.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          )
              : null,
        ),
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onDaySelected: _onDaySelected,
        //onRangeSelected: _onRangeSelected,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}

