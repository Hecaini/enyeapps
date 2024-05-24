import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

// ignore: must_be_immutable
class TechSchedPage extends StatefulWidget {
  static const String routeName = '/appointment';

  RemoteMessage? message;

  TechSchedPage({super.key, required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => TechSchedPage(message: message,)
    );
  }

  @override
  State<TechSchedPage> createState() => _TechSchedPageState();
}

class _TechSchedPageState extends State<TechSchedPage> with TickerProviderStateMixin {
  final RemoteMessage message = const RemoteMessage();

  TextEditingController? searchTransaction;
  final TextEditingController note = TextEditingController();

  final kToday = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  bool _isLoadingApp = true;
  bool _isLoadingService = true;

  @override
  void initState(){
    super.initState();
    _services = [];
    _users = [];
    _filteredUsers = [];
    _department = [];
    _position = [];
    _filteredPosition = [];
    _getAccounts();
    _getDepartments();
    _getPositions();
    _getServiceOrder();

    //calling session data
    CheckSessionData().getUserSessionStatus().then((userSession) {
      if (userSession == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getOnProcessAppointment();
          _getServices();
        });
        userSessionFuture = userSession;
      } else {
        userSessionFuture = userSession;
      }
    });

    if(userInfo?.status == "Employee") {
      if (widget.message!.data["goToPage"] == "Set-sched Handler") {
        if (widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else if (widget.message!.data["goToPage"] == "Accepted") {
        if (widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else if (widget.message!.data["goToPage"] == "Re-sched Handler") {
        if (widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else {
        _selectedDay = _focusedDay;
      }
    } else {
      if(widget.message!.data["goToPage"] == "Booking"){
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => UnreadPage(message: widget.message!)),
          );
        });
      } else if (widget.message!.data["goToPage"] == "Set-sched Handler"){
        if(widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else if (widget.message!.data["goToPage"] == "Accepted") {
        if (widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else if (widget.message!.data["goToPage"] == "Re-sched Handler") {
        if (widget.message!.data["datesched"] != null) {
          _selectedDay = DateTime.parse(widget.message?.data["datesched"]);
        } else {
          _selectedDay = _focusedDay;
        }
      } else if(widget.message!.data["goToPage"] == "Re-sched"){
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => UnreadPage(message: widget.message!)),
          );
        });
      } else {
        _selectedDay = _focusedDay;
      }
    }
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
  late List<TechnicalData> _services;
  _getServices(){
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData;
      });
      _isLoadingService = false;
    });
  }

  List<ServiceOrder> _serviceOrder = [];
  _getServiceOrder(){
    SODataServices.getAllServiceOrder().then((serviceOrder){
      setState(() {
        _serviceOrder = serviceOrder;
      });
    });
  }

  List<AppointmentData> _opAppointment = [];
  _getOnProcessAppointment(){
    print(userInfo?.status);
    if(userInfo?.status == "Employee") {
      AppointmentServices.getAllAppointment().then((Appointment){
        setState(() {
          _opAppointment = Appointment.where((element) => (element.status == "On Process" || element.status == "Set-sched") &&
              (_isUserAssigned(element.engineer, userInfo!.userId) || _isUserAssigned(element.technician, userInfo!.userId)
              || _isUserAssigned(element.inCharge, userInfo!.userId))).toList();
        });
        _isLoadingApp = false;
      });
    } else {
      AppointmentServices.getAllAppointment().then((Appointment){
        setState(() {
          _opAppointment = Appointment.where((element) => element.status == "On Process" || element.status == "Set-sched").toList();
        });
        _isLoadingApp = false;
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

  late List<Department> _department;
  _getDepartments(){
    DepartmentServices.getDepartments().then((department){
      setState(() {
        _department = department;
      });
    });
  }

  late List<Position> _position;
  late List<Position> _filteredPosition;
  _getPositions(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });
  }

  //below this are for account infos get to server
  late List<UsersInfo> _users;
  late List<UsersInfo> _filteredUsers;
  _getAccounts(){
    UsersInfoServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users = accountInfo;
      });
    });
  }
  Future<void> sendPushNotifications(String status, String svcId) async {
    //final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
    final response = await http.post(
      Uri.parse(API.pushNotif),
      body: {
        'action' : status,
        'svc_id' : svcId,
      },
    );
    if (response.statusCode == 200) {
      if(response.body == "success"){
        print('send push notifications.');
      }
    } else {
      print('Failed to send push notifications.');
    }
  }

  File? filePath;
  String? fileName;
  String? fileData;
  String? showData;
  bool disabling = false;
  ImagePicker imagePicker = ImagePicker();

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = File(result.files.single.path!);
        fileName = result.files.single.name;
        fileData = base64Encode(filePath!.readAsBytesSync());
        print(filePath);
      });
    }
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Technical Schedule', imagePath: 'assets/logo/enyecontrols.png',),
      resizeToAvoidBottomInset: true,
      body: _isLoadingApp || _isLoadingService
        ? Center(child: SpinningContainer(controller: _controller),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getServices();
              _getOnProcessAppointment();
              _getAccounts();
              _getPositions();
              _getServiceOrder();
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
                itemCount: _opAppointment.length,
                itemBuilder: (_, index){
                  AppointmentData appointment = _opAppointment[index];

                  TechnicalData services = _services.where((service) => service.id == appointment.svcId).elementAt(0);

                  if(services.status == "Completed"){
                    return Container();
                  } else {
                    if (DateFormat.yMd().format(DateTime.parse(appointment.startDatetime)) == DateFormat.yMd().format(_selectedDay!)
                        || DateFormat.yMd().format(DateTime.parse(appointment.endDatetime)) == DateFormat.yMd().format(_selectedDay!)
                        || (_selectedDay!.isAfter(DateTime.parse(appointment.startDatetime)) && _selectedDay!.isBefore(DateTime.parse(appointment.endDatetime)))){
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    print('selected Date: ${_selectedDay.toString()}');
                                    _showBottomSheet(context, services, _selectedDay.toString(), appointment);
                                  },
                                  child: TaskTile(services: services, appointment: appointment),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                }
              ),
            ),
          ],
      ),
        ),
    );
  }

  _showBottomSheet (BuildContext context, TechnicalData services, String selectedDay, AppointmentData appointment) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: (services.status == "On Process" && userInfo?.status != "Employee" &&
              (_isUserAssigned(appointment.engineer, userInfo!.userId) || _isUserAssigned(appointment.technician, userInfo!.userId) || _isUserAssigned(appointment.inCharge, userInfo!.userId)))
            ? MediaQuery.of(context).size.height * 0.44
            : MediaQuery.of(context).size.height * 0.34,
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

              (services.statusCategory == 'service') && (services.status == "On Process" && userInfo?.status == "Employee")
                || (services.status == "On Process" && userInfo?.status != "Employee" &&
                  (_isUserAssigned(appointment.engineer, userInfo!.userId) || _isUserAssigned(appointment.technician, userInfo!.userId) || _isUserAssigned(appointment.inCharge, userInfo!.userId)))
              ? _bottomSheetButton(
                label: "Service Order",
                onTap: (){
                  setState(() {
                    // Navigator.pop(context);
                    // _showAnotherBottomSheet(context, services, "Task Completed");
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ServiceOrderPage(services: services, selectedDay: selectedDay, appointment: appointment)),
                    );
                  });
                },
                clr: Colors.blueAccent,
                context:context,
              ): Container(),

              (services.status == "On Process" && userInfo?.status != "Employee") ?
              _bottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    // _showAnotherBottomSheet(context, services, "Task Completed", appointment);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TaskCompletedPage(services: services, appointment: appointment, selectedDay: selectedDay)),
                    ).then((value) {
                      // Refresh the services once the StatusPage is popped
                      _getServices();
                      _getOnProcessAppointment();
                      _getAccounts();
                      _getPositions();
                      _getServiceOrder();
                      setState(() {});
                    });
                  });
                },
                clr: Colors.green,
                context:context,
              ): Container(),

              const SizedBox(height: 10,),
              _bottomSheetButton(
                label: "View",
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    _showAnotherBottomSheet(context, services, "View", appointment);
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

  String? valueChooseAccount;
  String? valueChooseDepartment;
  String? valueChoosePosition;
  _showAnotherBottomSheet (BuildContext context, TechnicalData services, String whatToDo, AppointmentData appointment) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ListView(
              shrinkWrap: true,
              children: <Widget> [
                Container(
                  height: 6,
                  margin: EdgeInsets.only(left: screenWidth * 0.4, right: screenWidth* 0.4, top: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                  ),
                ),

                SizedBox(height: screenHeight * 0.03,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        softWrap: true,
                        text:TextSpan(
                          children: <TextSpan> [
                            TextSpan(text: "Title :  ",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: fontXSmallSize,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Colors.grey
                                ),
                              ),
                            ),

                            TextSpan(text: services.svcTitle,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: fontNormalSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: Colors.black54
                                ),
                              ),
                            ),
                          ]
                        )
                      ),

                      SizedBox(height: screenHeight * 0.005,),
                      RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              TextSpan(text: "Description :  ",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontXSmallSize,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Colors.grey
                                  ),
                                ),
                              ),

                              TextSpan(text: services.svcDesc,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontSmallSize,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ]
                        )
                      ),

                      SizedBox(height: screenHeight * 0.005,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(
                                  text: 'Requestor : ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),

                                TextSpan(
                                  text: '${services.reqName} | ${services.reqPosition}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 18,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.yMMMMd().format(DateTime.parse(appointment.startDatetime))} TO ${DateFormat.yMMMMd().format(DateTime.parse(appointment.endDatetime))}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontSmallSize,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.005,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time_filled_rounded,
                            size: 18,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.jm().format(DateTime.parse(appointment.startDatetime))} - ${DateFormat.jm().format(DateTime.parse(appointment.endDatetime))}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: fontSmallSize,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.012,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Client Name : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientName}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Contact : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientContact}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Email : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: services.clientEmail,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                                //Text(services.svcDesc, maxLines: 5, softWrap: false,),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: screenWidth * 0.38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Project Name : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientProjName}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Company : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientCompany}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Location : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientLocation}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02,),
                appointment.engineer.isNotEmpty || appointment.engineer != ""
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade300,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.white70, width: 1.5),
                        ),
                        child: Text(
                          'Engineers',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 0.8,
                            color: Colors.white, // Optionally, set text color
                          ),
                        ),
                      ),
                    ),

                    ..._users.map((engineer) {
                      if(_isUserAssigned(appointment.engineer, engineer.user_id)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: engineer.image.isNotEmpty == true && engineer.image != ""
                                      ? Image.network(API.usersImages + engineer.image).image
                                      : const AssetImage("assets/icons/user.png"),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: RichText(
                                  softWrap: true,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(text: engineer.name,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${_position.where((position) => position.id == engineer.position).elementAtOrNull(0)?.position}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontXSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ),
                                  ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ],
                )
                : const SizedBox.shrink(),

                SizedBox(height: screenHeight * 0.01,),
                appointment.technician.isNotEmpty || appointment.technician != ""
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade300,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.white70, width: 1.5),
                        ),
                        child: Text(
                          'Technicians',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 0.8,
                            color: Colors.white, // Optionally, set text color
                          ),
                        ),
                      ),
                    ),

                    ..._users.map((technician) {
                      if(_isUserAssigned(appointment.technician, technician.user_id)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: technician.image.isNotEmpty == true && technician.image != ""
                                      ? Image.network(API.usersImages + technician.image).image
                                      : const AssetImage("assets/icons/user.png"),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: RichText(
                                  softWrap: true,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(text: technician.name,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${_position.where((position) => position.id == technician.position).elementAtOrNull(0)?.position}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontXSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ),
                                  ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ],
                )
                : const SizedBox.shrink(),

                SizedBox(height: screenHeight * 0.01,),
                appointment.inCharge.isNotEmpty || appointment.inCharge != ""
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.15),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade300,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.white70, width: 1.5),
                        ),
                        child: Text(
                          'Person In Charge',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 0.8,
                            color: Colors.white, // Optionally, set text color
                          ),
                        ),
                      ),
                    ),

                    ..._users.map((incharge) {
                      if(_isUserAssigned(appointment.inCharge, incharge.user_id)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: incharge.image.isNotEmpty == true && incharge.image != ""
                                      ? Image.network(API.usersImages + incharge.image).image
                                      : const AssetImage("assets/icons/user.png"),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: RichText(
                                  softWrap: true,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(text: incharge.name,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${_position.where((position) => position.id == incharge.position).elementAtOrNull(0)?.position}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontXSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ),
                                  ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ],
                )
                : const SizedBox.shrink(),

                appointment.category == "service"
                ? Center(
                  child: Wrap(
                    children: <Widget>[
                      ..._serviceOrder.map((serviceOrder) {
                        if ((serviceOrder.stat == "Saved" || serviceOrder.stat == "Completed") && serviceOrder.svcId == services.id) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SOPdfPreviewPage(soId: serviceOrder.soId),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade300),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              child: RichText(
                                  softWrap: true,
                                  text:TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Icon(
                                              Icons.download_for_offline_rounded,
                                              color: Colors.white,
                                              size: fontNormalSize, // Specify your desired icon size
                                            ),
                                          ),
                                        ),

                                        TextSpan(text: "SO# ${serviceOrder.soNo}",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: fontXSmallSize,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.8,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ]
                                  )
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }).toList()
                    ],
                  ),
                )
                : const SizedBox.shrink(),

                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _bottomSheetButton(
                    label: "Close",
                    onTap: (){
                      valueChooseAccount = null;
                      valueChooseDepartment = null;
                      valueChoosePosition = null;
                      _filteredUsers.clear();
                      _filteredPosition.clear();
                      Navigator.pop(context);
                    },
                    clr: Colors.orangeAccent,
                    context:context,
                    isClose: true,
                  ),
                ),

                const SizedBox(height: 10,),
              ],
            ),
          );
        }
    ).whenComplete(() {
      valueChooseAccount = null;
      valueChooseDepartment = null;
      valueChoosePosition = null;
      _filteredUsers.clear();
      _filteredPosition.clear();
    });
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

  /*_addTaskBar (){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )
                    )
                ),
                Text("Today",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        )
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }*/
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
          return _opAppointment.where((appointment) {
            TechnicalData? services = _services.where((service) => service.id == appointment.svcId).elementAtOrNull(0);
            // Check if the service date is within the specified range
            DateTime serviceStartDate = DateTime.parse(appointment.startDatetime.toString()); // Remove "00:00:00"
            DateTime serviceEndDate = DateTime.parse(appointment.endDatetime.toString());   // Remove "00:00:00"

            if(services?.status == "Completed"){
              return false;
            } else{
              if(serviceStartDate == serviceEndDate){
                return isSameDay(serviceStartDate,day);
              } else if (isSameDay(day, serviceStartDate)
                  || (day.isAfter(serviceStartDate) && day.isBefore(serviceEndDate))) {
                return true;
              } else if (isSameDay(day, serviceEndDate)
                  || (day.isAfter(serviceStartDate) && day.isBefore(serviceEndDate))) {
                return true;
              } else {
                return false;
              }
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

