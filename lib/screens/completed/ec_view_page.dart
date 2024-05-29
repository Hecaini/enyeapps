

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ECViewCompletePage extends StatefulWidget {
  final List<EventsData> events;
  final TSISData tsis;

  const ECViewCompletePage({super.key, required this.events, required this.tsis});

  @override
  State<ECViewCompletePage> createState() => _ECViewCompletePageState();
}

class _ECViewCompletePageState extends State<ECViewCompletePage> with TickerProviderStateMixin {

  bool _isLoadingAcc = true;
  bool _isLoadingSO = true;

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

    _getEngAccounts();
    _getServiceOrder();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  List<EngUsers> _engUsers = [];
  _getEngAccounts(){
    UsersInfoServices.getEngUsers().then((accountInfo){
      setState(() {
        _engUsers = accountInfo;
      });
      _isLoadingAcc = false;
    });
  }

  List<SOData> _serviceOrder = [];
  _getServiceOrder(){
    SOServices.getAllServiceOrder().then((serviceOrder){
      setState(() {
        _serviceOrder = serviceOrder.where((so) =>
            widget.events.any((event) => event.id == so.eventId) && so.tsisId == widget.tsis.tsisId
            && (so.stat == "Save" || so.stat == "Completed")
        ).toList();
      });
      _isLoadingSO = false;
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
              size: fontNormalSize * 1.8,
            ),
            SizedBox(width: screenWidth * 0.03,),
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

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

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
      body: _isLoadingAcc || _isLoadingSO
        ? Center(child: SpinningContainer(controller: _controller),)
        : ListView(
            children: [
          SizedBox(height: screenHeight * 0.03),
          Center(
            child: Text(
                "#${widget.tsis.tsisNo}",
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
                        TextSpan(text: "Project :  ",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Colors.grey
                            ),
                          ),
                        ),

                        TextSpan(text: widget.tsis.project,
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

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                    softWrap: true,
                    text:TextSpan(
                        children: <TextSpan> [
                          TextSpan(text: "Location :  ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontSmallSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          TextSpan(text: widget.tsis.location,
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

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    text:TextSpan(
                        children: <TextSpan> [
                          TextSpan(text: "Subject :  ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontSmallSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          TextSpan(text: widget.tsis.subject,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontNormalSize,
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
                RichText(
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    text:TextSpan(
                        children: <TextSpan> [
                          TextSpan(text: "Problem :  ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontSmallSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          TextSpan(text: "\n \t - ${widget.tsis.problem}",
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
              if(widget.tsis.remarks.isNotEmpty || widget.tsis.remarks != "")
                RichText(
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    text:TextSpan(
                        children: <TextSpan> [
                          TextSpan(text: "Remarks :  ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontSmallSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          TextSpan(text: "\n \t - ${widget.tsis.remarks}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: fontNormalSize,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: Colors.black54
                              ),
                            ),
                          ),
                        ]
                    )
                ),

                SizedBox(height: screenHeight * 0.015,),
                RichText(
                  softWrap: true,
                  text:TextSpan(
                      children: <TextSpan> [
                        TextSpan(
                          text: 'Client : ',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Colors.grey
                            ),
                          ),
                        ),

                        TextSpan(
                          text: "\n \t ${widget.tsis.clientName}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: Colors.black54
                            ),
                          ),
                        ),

                        TextSpan(
                          text: ' | ${widget.tsis.contactPerson} | ${widget.tsis.contactNumber} | ${widget.tsis.email}',
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
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.02,),
          Column(
            children: widget.events.map((event) => ExpansionTile(
              initiallyExpanded: true,
              title: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.deepOrange,
                    size: fontNormalSize * 1.5,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '${DateFormat.yMMMd().format(DateTime.parse(event.start))} TO ${DateFormat.yMMMd().format(DateTime.parse(event.end))}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: fontSmallSize, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              children: [
                event.engineer.isNotEmpty || event.engineer != ""
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

                    ..._engUsers.map((engineer) {
                      if(_isUserAssigned(event.engineer, engineer.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: engineer.picture.isNotEmpty == true && engineer.picture != ""
                                      ? Image.network(API.ec_usersImg + engineer.picture).image
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
                                    TextSpan(text: "${engineer.firstname} ${engineer.lastname}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${engineer.roleType}",
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

                    SizedBox(height: screenHeight * 0.01,),
                  ],
                )
                : const SizedBox.shrink(),

                event.technician.isNotEmpty || event.technician != ""
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

                    ..._engUsers.map((technician) {
                      if(_isUserAssigned(event.technician, technician.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: technician.picture.isNotEmpty == true && technician.picture != ""
                                      ? Image.network(API.ec_usersImg + technician.picture).image
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
                                    TextSpan(text: "${technician.firstname} ${technician.lastname}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${technician.roleType}",
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

                    SizedBox(height: screenHeight * 0.01,),
                  ],
                )
                : const SizedBox.shrink(),

                Center(
                  child: Wrap(
                    children: <Widget>[
                      ..._serviceOrder.map((serviceOrder) {
                        if (serviceOrder.tsisId == widget.tsis.tsisId && serviceOrder.eventId == event.id) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SOPdfPage(soId: serviceOrder.soId),
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
                ),
                Center(
                  child: Wrap(
                    children: <Widget>[
                      ..._serviceOrder.map((serviceOrder) {
                        if (serviceOrder.coc == "" || serviceOrder.coc.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          if (serviceOrder.tsisId == widget.tsis.tsisId && serviceOrder.eventId == event.id){
                            return _progress != null
                                ? SizedBox(
                              width: screenWidth * 0.1,
                              height: screenHeight * 0.1,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                                : GestureDetector(
                              onTap: () {
                                String url = API.ECcompAtt + serviceOrder.coc.toString();

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
                                            text: "${serviceOrder.coc} (Attached File)",
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
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      }).toList()
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02,),
              ],
            )).toList(),
          ),

          // ...widget.events.map((event) {
          //    return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         SizedBox(height: screenHeight * 0.03,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Icon(
          //               Icons.calendar_month_rounded,
          //               color: Colors.deepOrange,
          //               size: fontNormalSize * 1.5,
          //             ),
          //             const SizedBox(width: 4),
          //             Text(
          //               '${DateFormat.yMMMd().format(DateTime.parse(event.start))} TO ${DateFormat.yMMMd().format(DateTime.parse(event.end))}',
          //               style: GoogleFonts.poppins(
          //                 textStyle: TextStyle(fontSize: fontNormalSize, letterSpacing: 0.5, fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //           ],
          //         ),
          //
          //         event.engineer.isNotEmpty || event.engineer != ""
          //         ? Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //
          //               SizedBox(height: screenHeight * 0.02,),
          //
          //               Center(
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
          //                   decoration: BoxDecoration(
          //                     color: Colors.deepOrange.shade300,
          //                     borderRadius: BorderRadius.circular(25.0),
          //                     border: Border.all(color: Colors.white70, width: 1.5),
          //                   ),
          //                   child: Text(
          //                     'Engineers',
          //                     style: TextStyle(
          //                       fontSize: fontSmallSize,
          //                       letterSpacing: 0.8,
          //                       color: Colors.white, // Optionally, set text color
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //
          //               ..._engUsers.map((engineer) {
          //                 if(_isUserAssigned(event.engineer, engineer.username)) {
          //                   return Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                     children: [
          //                       Container(
          //                         width: (screenWidth + screenHeight) / 25,
          //                         height: (screenWidth + screenHeight) / 25,
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           image: DecorationImage(
          //                             image: engineer.picture.isNotEmpty == true && engineer.picture != ""
          //                                 ? Image.network(API.ec_usersImg + engineer.picture).image
          //                                 : const AssetImage("assets/icons/user.png"),
          //                           ),
          //                         ),
          //                       ),
          //                       Flexible(
          //                         child: Container(
          //                           width: MediaQuery.of(context).size.width * 0.75,
          //                           child: RichText(
          //                             softWrap: true,
          //                             text: TextSpan(children: <TextSpan>
          //                             [
          //                               TextSpan(text: "${engineer.firstname} ${engineer.lastname}",
          //                                 style: GoogleFonts.poppins(
          //                                   textStyle: TextStyle(
          //                                       fontSize: fontSmallSize,
          //                                       fontWeight: FontWeight.w800,
          //                                       letterSpacing: 0.8,
          //                                       color: Colors.black54
          //                                   ),
          //                                 ),
          //                               ),
          //
          //                               TextSpan(text: "\n${engineer.roleType}",
          //                                 style: GoogleFonts.poppins(
          //                                   textStyle: TextStyle(
          //                                       fontSize: fontXSmallSize,
          //                                       fontWeight: FontWeight.w800,
          //                                       letterSpacing: 0.8,
          //                                       color: Colors.grey
          //                                   ),
          //                                 ),
          //                               ),
          //                             ]
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 } else {
          //                   return SizedBox.shrink();
          //                 }
          //               }).toList(),
          //             ],
          //           )
          //         : const SizedBox.shrink(),
          //
          //         event.technician.isNotEmpty || event.technician != ""
          //         ? Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //
          //               SizedBox(height: screenHeight * 0.02,),
          //
          //               Center(
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
          //                   decoration: BoxDecoration(
          //                     color: Colors.deepOrange.shade300,
          //                     borderRadius: BorderRadius.circular(25.0),
          //                     border: Border.all(color: Colors.white70, width: 1.5),
          //                   ),
          //                   child: Text(
          //                     'Technicians',
          //                     style: TextStyle(
          //                       fontSize: fontSmallSize,
          //                       letterSpacing: 0.8,
          //                       color: Colors.white, // Optionally, set text color
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //
          //               ..._engUsers.map((technician) {
          //                 if(_isUserAssigned(event.technician, technician.username)) {
          //                   return Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                     children: [
          //                       Container(
          //                         width: (screenWidth + screenHeight) / 25,
          //                         height: (screenWidth + screenHeight) / 25,
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           image: DecorationImage(
          //                             image: technician.picture.isNotEmpty == true && technician.picture != ""
          //                                 ? Image.network(API.ec_usersImg + technician.picture).image
          //                                 : const AssetImage("assets/icons/user.png"),
          //                           ),
          //                         ),
          //                       ),
          //                       Flexible(
          //                         child: Container(
          //                           width: MediaQuery.of(context).size.width * 0.75,
          //                           child: RichText(
          //                             softWrap: true,
          //                             text: TextSpan(children: <TextSpan>
          //                             [
          //                               TextSpan(text: "${technician.firstname} ${technician.lastname}",
          //                                 style: GoogleFonts.poppins(
          //                                   textStyle: TextStyle(
          //                                       fontSize: fontSmallSize,
          //                                       fontWeight: FontWeight.w800,
          //                                       letterSpacing: 0.8,
          //                                       color: Colors.black54
          //                                   ),
          //                                 ),
          //                               ),
          //
          //                               TextSpan(text: "\n${technician.roleType}",
          //                                 style: GoogleFonts.poppins(
          //                                   textStyle: TextStyle(
          //                                       fontSize: fontXSmallSize,
          //                                       fontWeight: FontWeight.w800,
          //                                       letterSpacing: 0.8,
          //                                       color: Colors.grey
          //                                   ),
          //                                 ),
          //                               ),
          //                             ]
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 } else {
          //                   return SizedBox.shrink();
          //                 }
          //               }).toList(),
          //             ],
          //           )
          //         : const SizedBox.shrink(),
          //
          //         SizedBox(height: screenHeight * 0.02,),
          //         Center(
          //           child: Wrap(
          //             children: <Widget>[
          //               ..._serviceOrder.map((serviceOrder) {
          //                 if (serviceOrder.tsisId == widget.tsis.tsisId && serviceOrder.eventId == event.id) {
          //                   return Padding(
          //                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          //                     child: ElevatedButton(
          //                       onPressed: () {
          //                         Navigator.of(context).push(
          //                           MaterialPageRoute(
          //                             builder: (context) => SOPdfPage(soId: serviceOrder.soId),
          //                           ),
          //                         );
          //                       },
          //                       style: ButtonStyle(
          //                         backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade300),
          //                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //                           RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(25.0),
          //                             side: BorderSide(color: Colors.white),
          //                           ),
          //                         ),
          //                       ),
          //                       child: RichText(
          //                           softWrap: true,
          //                           text:TextSpan(
          //                               children: [
          //                                 WidgetSpan(
          //                                   child: Padding(
          //                                     padding: EdgeInsets.only(right: 8.0),
          //                                     child: Icon(
          //                                       Icons.download_for_offline_rounded,
          //                                       color: Colors.white,
          //                                       size: fontNormalSize, // Specify your desired icon size
          //                                     ),
          //                                   ),
          //                                 ),
          //
          //                                 TextSpan(text: "SO# ${serviceOrder.soNo}",
          //                                   style: GoogleFonts.poppins(
          //                                     textStyle: TextStyle(
          //                                       fontSize: fontXSmallSize,
          //                                       fontWeight: FontWeight.w700,
          //                                       letterSpacing: 0.8,
          //                                       color: Colors.white,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ]
          //                           )
          //                       ),
          //                     ),
          //                   );
          //                 } else {
          //                   return const SizedBox.shrink();
          //                 }
          //               }).toList()
          //             ],
          //           ),
          //         ),
          //         Center(
          //           child: Wrap(
          //             children: <Widget>[
          //               ..._serviceOrder.map((serviceOrder) {
          //                 if (serviceOrder.coc == "" || serviceOrder.coc.isEmpty) {
          //                   return const SizedBox.shrink();
          //                 } else {
          //                   if (serviceOrder.tsisId == widget.tsis.tsisId && serviceOrder.eventId == event.id){
          //                     return _progress != null
          //                             ? SizedBox(
          //                                 width: screenWidth * 0.1,
          //                                 height: screenHeight * 0.1,
          //                                 child: Center(
          //                                   child: CircularProgressIndicator(),
          //                                 ),
          //                               )
          //                             : GestureDetector(
          //                                 onTap: () {
          //                                   String url = API.ECcompAtt + serviceOrder.coc.toString();
          //
          //                                   FileDownloader.downloadFile(
          //                                       url: url.trim(),
          //                                       onProgress: (name, progress) {
          //                                         setState(() {
          //                                           _progress = progress;
          //                                         });
          //                                       },
          //                                       onDownloadCompleted: (value) {
          //                                         print('path  $value ');
          //                                         _custSnackbar(
          //                                             context,
          //                                             "File successfully downloaded.",
          //                                             Colors.green,
          //                                             Icons.check_box
          //                                         );
          //                                         setState(() {
          //                                           _progress = null;
          //                                         });
          //                                       });
          //                                 },
          //                                 child: Padding(
          //                                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          //                                   child: Row(
          //                                     children: [
          //                                       CircleAvatar(
          //                                         radius: fontSmallSize * 1.7,
          //                                         backgroundColor: Colors.green.shade100,
          //                                         child: Icon(Icons.insert_drive_file, color: Colors.green, size: fontSmallSize * 1.5),
          //                                       ),
          //                                       SizedBox(width: screenWidth * 0.05,),
          //                                       Expanded(
          //                                         child: RichText(
          //                                           softWrap: true,
          //                                           textAlign: TextAlign.start,
          //                                           text: TextSpan(children: <TextSpan>
          //                                           [
          //                                             TextSpan(
          //                                               text: "${serviceOrder.coc} (Attached File)",
          //                                               style: GoogleFonts.poppins(
          //                                                 textStyle: TextStyle(
          //                                                   fontSize: fontXSmallSize,
          //                                                   fontWeight: FontWeight.w700,
          //                                                   letterSpacing: 0.8,
          //                                                   color: Colors.black54,
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                           ]
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                               );
          //                   } else {
          //                     return const SizedBox.shrink();
          //                   }
          //                 }
          //               }).toList()
          //             ],
          //           ),
          //         ),
          //       ],
          //   );
          // }).toList(),

          SizedBox(height: screenHeight * 0.05,),
        ],
          ),
    );
  }
}
