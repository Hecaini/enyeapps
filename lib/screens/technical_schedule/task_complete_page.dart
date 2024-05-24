import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class TaskCompletedPage extends StatefulWidget {
  final TechnicalData services;
  final AppointmentData appointment;
  final String selectedDay;

  const TaskCompletedPage({super.key, required this.services, required this.appointment, required this.selectedDay});

  @override
  State<TaskCompletedPage> createState() => _TaskCompletedPageState();
}

class _TaskCompletedPageState extends State<TaskCompletedPage> {

  bool _isLoading = true;
  String? _dropdownError; //kapag wala pa na-select sa option
  bool disabling = false;
  final TextEditingController note = TextEditingController();

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  @override
  void initState() {
    super.initState();

    //calling session data
    CheckSessionData().getUserSessionStatus().then((session) {
      if (session == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
        });
        userSessionFuture = session;
      } else {
        userSessionFuture = session;
      }
    });

    _getAccounts();
    _getServiceOrder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  File? filePath;
  String? fileName;
  String? fileData;
  String? showData;
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

  bool _isImage(String filePath) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    final ext = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(ext);
  }

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }
    return false;
  }

  List<UsersInfo> _users = [];
  List<Position> _position = [];

  _getAccounts(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });

    UsersInfoServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users = accountInfo;
      });
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

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.82),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: (screenHeight + screenWidth) / 50,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Expanded(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(children: <TextSpan>
                [
                  TextSpan(
                    text: message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPushNotifications(String status, String svcId, String appId) async {
    //final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
    final response = await http.post(
      Uri.parse(API.pushNotif),
      body: {
        'action' : status,
        'svc_id' : svcId,
        'appointment_id' : appId,
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

  _taskComplete(){
    TechnicalDataServices.editTaskCompleted(
      widget.services.id, widget.appointment.id, widget.selectedDay,
      note.text, fileName.toString(), fileData.toString()
    ).then((result) {
      if(result.contains("success")){
        // _getServices(); //refresh the list after update
        // sendPushNotifications("Completed", services.svcId);
        _custSnackbar(
            context,
            "Task Completed Successfully !",
            Colors.green,
            Icons.check_box
        );
        print("Result Task Complete : $result");
        sendPushNotifications("Completed", widget.services.id, widget.appointment.id);
        
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context, true);
        });
      } else {
        _custSnackbar(
            context,
            "Error occured... $result",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible){
          return Scaffold(
            appBar: const CustomAppBar(title: 'Booking System', imagePath: 'assets/logo/enyecontrols.png'),
            resizeToAvoidBottomInset: true,
            body: ListView(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Text(
                      'TASK COMPLETE',
                      style: GoogleFonts.rowdies(
                          textStyle: TextStyle(
                              fontSize: fontXSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          )
                      )
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

                                TextSpan(text: widget.services.svcTitle,
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

                                TextSpan(text: widget.services.svcDesc,
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
                                  text: '${widget.services.reqName} | ${widget.services.reqPosition}',
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
                            '${DateFormat.yMMMMd().format(DateTime.parse(widget.appointment.startDatetime))} TO ${DateFormat.yMMMMd().format(DateTime.parse(widget.appointment.endDatetime))}',
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
                            '${DateFormat.jm().format(DateTime.parse(widget.appointment.startDatetime))} - ${DateFormat.jm().format(DateTime.parse(widget.appointment.endDatetime))}',
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
                                  text: TextSpan(text: "\t${widget.services.clientName}",
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
                                  text: TextSpan(text: "\t${widget.services.clientContact}",
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
                                  text: TextSpan(text: widget.services.clientEmail,
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
                                  text: TextSpan(text: "\t${widget.services.clientProjName}",
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
                                  text: TextSpan(text: "\t${widget.services.clientCompany}",
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
                                  text: TextSpan(text: "\t${widget.services.clientLocation}",
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
                widget.appointment.engineer.isNotEmpty || widget.appointment.engineer != ""
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
                      if(_isUserAssigned(widget.appointment.engineer, engineer.user_id)) {
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
                widget.appointment.technician.isNotEmpty || widget.appointment.technician != ""
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
                      if(_isUserAssigned(widget.appointment.technician, technician.user_id)) {
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
                widget.appointment.inCharge.isNotEmpty || widget.appointment.inCharge != ""
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
                      if(_isUserAssigned(widget.appointment.inCharge, incharge.user_id)) {
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

                widget.appointment.category == "service"
                ? Center(
                  child: Wrap(
                    children: <Widget>[
                      ..._serviceOrder.map((serviceOrder) {
                        if ((serviceOrder.stat == "Saved" || serviceOrder.stat == "Completed") && serviceOrder.svcId == widget.services.id) {
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

                SizedBox(height: screenHeight * 0.05),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [

                      //drop-down button
                      SizedBox(height: screenHeight * 0.01,),
                      NormalTextField(
                        controller: note,
                        hintText: 'Note',
                        disabling: false,
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      InkWell(
                        onTap: (){
                          if(disabling != true){
                            selectFile();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  if (filePath != null && _isImage(filePath!.path))
                                    CircleAvatar(
                                      radius: fontSmallSize * 1.7,
                                      backgroundImage: FileImage(filePath!),
                                    )
                                  else if (showData != null && showData!.isNotEmpty && _isImage(showData!))
                                    CircleAvatar(
                                      radius: fontSmallSize * 1.7,
                                      backgroundImage: FileImage(File(API.attachment + showData!)),
                                    )
                                  else
                                    CircleAvatar(
                                      radius: fontSmallSize * 1.7,
                                      foregroundColor: Colors.deepOrange,
                                      child: Icon(Icons.insert_drive_file, color: Colors.deepOrange, size: fontSmallSize * 1.5),
                                    ),
                                  if (!disabling)
                                    Positioned(
                                      bottom: fontSmallSize * 0.05,
                                      left: fontSmallSize * 1.8,
                                      child: Icon(Icons.add, color: Colors.deepOrange),
                                    ),
                                ],
                              ),
                              SizedBox(width: 8), // Add some space between the avatar and the text
                              Expanded(
                                child: RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(
                                      text: filePath != null ? filePath!.path.split('/').last : "Attach file",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: fontXSmallSize,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      _dropdownError == null
                          ? const SizedBox.shrink()
                          : Center(
                        child: Text(
                          _dropdownError ?? "",
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),

                      //save button for acknowledge
                      const SizedBox(height: 10,),

                    ],
                  )
                ),

                SizedBox(height: screenHeight * 0.02),
                addButton(
                  onTap: () {
                    setState(() {
                      if (note.text.trim().isEmpty) {
                        setState(() => _dropdownError = "Fill out the fields!");
                      } else {
                        setState(() {
                          _taskComplete();
                          // Navigator.of(context).pop();
                        });
                      }
                    });
                  },
                  text: 'Task Complete'
                ),

                if (isKeyboardVisible) SizedBox(height: screenHeight * 0.05,),

                SizedBox(height: screenHeight * 0.02,),
              ],
            ),
          );
        }
    );
  }
}
