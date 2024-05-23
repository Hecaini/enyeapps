

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ViewCompletePage extends StatefulWidget {
  final TechnicalData services;
  final AppointmentData appointment;

  const ViewCompletePage({super.key, required this.services, required this.appointment});

  @override
  State<ViewCompletePage> createState() => _ViewCompletePageState();
}

class _ViewCompletePageState extends State<ViewCompletePage> {

  bool _isLoading = true;

  UserLogin? userInfo; //users session
  bool? userSessionFuture;
  double? _progress;

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

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }

    return false;
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Booking System', imagePath: 'assets/logo/enyecontrols.png'),
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          SizedBox(height: screenHeight * 0.03),
          Center(
            child: Text(
                "#${widget.services.svcId}",
                style: GoogleFonts.rowdies(
                    textStyle: TextStyle(
                        fontSize: fontXSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                    )
                )
            ),
          ),

          SizedBox(height: screenHeight * 0.03),
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
                    color: Colors.green.shade300,
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
                    color: Colors.green.shade300,
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
                    color: Colors.green.shade300,
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
                              builder: (context) => SOPdfPreviewPage(serviceOrder: serviceOrder),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade300),
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

          Container(
            margin: EdgeInsets.all(16.0), // Margin around the box
            padding: EdgeInsets.all(16.0), // Padding inside the box
            decoration: BoxDecoration(
              color: Colors.green[200], // Background color of the box
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Shadow color
                  blurRadius: 4.0, // Shadow blur radius
                  offset: Offset(2, 2), // Shadow offset
                ),
              ],
            ),
            child: RichText(
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "NOTES : ",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.grey[800], // Darker color for better readability
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "\n${widget.services.notesComplete}",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.grey[800], // Darker color for better readability
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.01,),
          if (widget.appointment.attachFile == "" || widget.appointment.attachFile.isEmpty)
            const SizedBox.shrink()
          else
          _progress != null
          ? SizedBox(
              width: screenWidth * 0.1,
              height: screenHeight * 0.1,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              onTap: () {
                String url = API.completeAttachment + widget.appointment.attachFile.toString();

                FileDownloader.downloadFile(
                    url: url.trim(),
                    onProgress: (name, progress) {
                      setState(() {
                        _progress = progress;
                      });
                    },
                    onDownloadCompleted: (value) {
                      print('path  $value ');
                      _custSnackbar(
                        context,
                        "File successfully downloaded.",
                        Colors.green,
                        Icons.check_box
                      );
                      setState(() {
                        _progress = null;
                      });
                    });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: fontSmallSize * 1.7,
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.insert_drive_file, color: Colors.green, size: fontSmallSize * 1.5),
                    ),
                    SizedBox(width: screenWidth * 0.05,),
                    Expanded(
                      child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <TextSpan>
                        [
                          TextSpan(
                            text: "${widget.appointment.attachFile} (Attached File)",
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

          SizedBox(height: screenHeight * 0.05,),
        ],
      ),
    );
  }
}
