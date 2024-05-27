import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

// ignore: must_be_immutable
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

  @override
  void initState(){
    super.initState();
    //calling session data
    CheckSessionData().getUserSessionStatus().then((userSession) {
      if (userSession == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
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

  //below this are for technical datas get to server
  List<EventsData> _pendingEvents = [];
  _getPendingEvents(){
    ScheduleDataServices.getPendingEvents().then((pendingEvent){
      setState(() {
        _pendingEvents = pendingEvent;
      });
      _isLoadingPendingEvents = false;
    });
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
      body: _isLoadingPendingEvents
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
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: _opAppointment.length,
            //       itemBuilder: (_, index){
            //         AppointmentData appointment = _opAppointment[index];
            //
            //         TechnicalData services = _services.where((service) => service.id == appointment.svcId).elementAt(0);
            //
            //         if(services.status == "Completed"){
            //           return Container();
            //         } else {
            //           if (DateFormat.yMd().format(DateTime.parse(appointment.startDatetime)) == DateFormat.yMd().format(_selectedDay!)
            //               || DateFormat.yMd().format(DateTime.parse(appointment.endDatetime)) == DateFormat.yMd().format(_selectedDay!)
            //               || (_selectedDay!.isAfter(DateTime.parse(appointment.startDatetime)) && _selectedDay!.isBefore(DateTime.parse(appointment.endDatetime)))){
            //             return AnimationConfiguration.staggeredList(
            //               position: index,
            //               child: SlideAnimation(
            //                 child: FadeInAnimation(
            //                   child: Row(
            //                     children: [
            //                       GestureDetector(
            //                         onTap: (){
            //                           print('selected Date: ${_selectedDay.toString()}');
            //                           _showBottomSheet(context, services, _selectedDay.toString(), appointment);
            //                         },
            //                         child: TaskTile(services: services, appointment: appointment),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //           } else {
            //             return Container();
            //           }
            //         }
            //       }
            //   ),
            // ),
          ],
        ),
      ),
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

