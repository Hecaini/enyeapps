
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widget/widgets.dart';
import '../../config/config.dart';
import '../screens.dart';

// ignore: must_be_immutable
class ECCompletedPage extends StatefulWidget {

  RemoteMessage? message;

  ECCompletedPage({super.key, required this.message});

  @override
  State<ECCompletedPage> createState() => _ECCompletedPageState();
}

class _ECCompletedPageState extends State<ECCompletedPage> with TickerProviderStateMixin {
  final searchController = TextEditingController();

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  bool _isLoadingTSIS = true;
  bool _isLoadingCompleteEvents = true;
  bool _isLoadingSelTSIS = true;

  @override
  void initState(){
    super.initState();

    //calling session data
    CheckSessionData().getUserSessionStatus().then((session) {
      if (session == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getCompleteEvents();
        });
        userSessionFuture = session;
      } else {
        userSessionFuture = session;
      }
    });

    if(widget.message!.data["goToPage"] == "Completed"){
      searchController.text = '${widget.message!.data["code"]}';
    }

  }

  List<EventsData> _completeEvents = [];
  List<String> tsidList = [];
  _getCompleteEvents(){
    if(userInfo?.status == "Employee") {
      ScheduleDataServices.getCompleteEvents().then((compEvent){
        setState(() {
          _completeEvents = compEvent.where((e) => _isUserAssigned(e.engineer, userInfo!.username) || _isUserAssigned(e.technician, userInfo!.username)).toList();
        });
        _isLoadingCompleteEvents = false;

        if(_isLoadingCompleteEvents == false){
          _getTsis();
        }
      });
    } else {
      ScheduleDataServices.getCompleteEvents().then((compEvent){
        setState(() {
          _completeEvents = compEvent;
        });
        _isLoadingCompleteEvents = false;
        if(_isLoadingCompleteEvents == false){
          _getTsis();
        }
      });
    }
  }

  List<TSISData> _tsis = [];
  List<TSISData> _filteredTSIS = [];
  _getTsis(){
    ScheduleDataServices.getTSIS().then((tsis) {
      setState(() {
        // Filter _tsis to include only TSISData objects with tsisId found in _completeEvents
        _tsis = tsis.where((tsisData) => _completeEvents.any((event) => event.tsisId == tsisData.tsisId)).toList();
        _filteredTSIS = tsis.where((tsisData) => _completeEvents.any((event) => event.tsisId == tsisData.tsisId)).toList();
      });
      _isLoadingTSIS = false;
    });
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTSIS = List.from(_tsis);
      });
    } else {
      setState(() {
        _filteredTSIS = _tsis.where((tsis) => tsis.tsisNo.toLowerCase().contains(query.toLowerCase()) ||
           tsis.contactPerson.toLowerCase().contains(query.toLowerCase()) ||
           tsis.clientName.toLowerCase().contains(query.toLowerCase()) ||
           tsis.project.toLowerCase().contains(query.toLowerCase())).toList();
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
    searchController.dispose();
    super.dispose();
  }

  //this code is for tile if open, other closes
  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      appBar: const CustomAppBar(title: 'History', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: _isLoadingTSIS || _isLoadingCompleteEvents
        ? Center(child: SpinningContainer(controller: _controller),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {

          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                onChanged: _filterSearchResults,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search SERVICE #',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      FocusScope.of(context).unfocus();
                      // filterSystemsList();
                    },
                    icon: const Icon(Icons.clear),
                  )
                      : null, // Set suffixIcon to null when text is empty
                ),
                onEditingComplete: () {
                  // filterSystemsList();
                },
              ),
            ),

            const SizedBox(height: 25,),
            _completeEvents.isEmpty || _tsis.isEmpty
            ? const Expanded(
              child: Center(
                child: (Text(
                  "No Data Available",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.grey
                  ),
                )),
              ),
            )
            : Expanded(
              child: ListView.builder(
                  itemCount: _filteredTSIS.length,
                  itemBuilder: (context, index) {
                    TSISData tsis = _filteredTSIS[index];
                    List<EventsData> events = _completeEvents.where((e) => e.tsisId == tsis.tsisId).toList();

                    return Container(
                      margin: EdgeInsets.only(left: fontSmallSize, right: fontSmallSize, bottom: fontSmallSize),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: ExpansionTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        textColor: Colors.white,
                        backgroundColor: Colors.green,
                        key: Key(_currentExpandedTileIndex.toString()),
                        initiallyExpanded: index == _currentExpandedTileIndex,
                        onExpansionChanged: ((newState) {
                          if (newState) {
                            setState(() {
                              _currentExpandedTileIndex = index;
                            });
                          } else {
                            setState(() {
                              _currentExpandedTileIndex = -1;
                            });
                          }
                        }),
                        title: Text(
                          "#${tsis.tsisNo}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              setState(() {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ECViewCompletePage(tsis: tsis, events: events)),
                                );
                              });
                            },
                            child: Container(
                              width: screenWidth,
                              child: Container(
                                padding: EdgeInsets.only(left: fontNormalSize, right: fontNormalSize, bottom: fontSmallSize),
                                //  width: SizeConfig.screenWidth * 0.78,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tsis.project,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: fontSmallSize,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          ),
                                        ),

                                        SizedBox(height: screenHeight * 0.005,),
                                        Text(
                                          tsis.location,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: fontSmallSize,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.8,
                                              color: Colors.white),
                                          ),
                                        ),

                                        SizedBox(height: screenHeight * 0.005,),
                                        Text(
                                          "\t - ${tsis.problem}",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: fontSmallSize,
                                              letterSpacing: 0.8,
                                              color: Colors.white),
                                          ),
                                        ),

                                        if (tsis.remarks != "" || tsis.remarks.isNotEmpty)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: screenHeight * 0.005,),
                                              Text(
                                                "Remarks : ",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: fontSmallSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                ),
                                              ),

                                              Text(
                                                "\t - ${tsis.remarks}",
                                                textAlign: TextAlign.justify,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),

                                        SizedBox(height: screenHeight * 0.02,),
                                        Text(
                                          "Requestor : ",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: fontSmallSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          ),
                                        ),
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            softWrap: true,
                                            text:TextSpan(
                                                children: <TextSpan> [
                                                  TextSpan(
                                                    text: '\t ${tsis.clientName} \n \t${tsis.contactPerson} | ${tsis.contactNumber}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      color: Colors.white),
                                                    ),
                                                  ),
                                                ]
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 150,
                                    width: 0.5,
                                    color: Colors.grey[200]!.withOpacity(0.7),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      tsis.status.toUpperCase(),
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "On Process") {
      return Colors.orangeAccent;
    } else if (status == "Unread") {
      return Colors.blue;
    } else if (status == "Completed") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
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
}

