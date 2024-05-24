import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

// ignore: must_be_immutable
class BookingsPage extends StatefulWidget {

  static const String routeName = '/unread';

  RemoteMessage? message;

  BookingsPage({super.key, required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookingsPage(message: message,)
    );
  }

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with TickerProviderStateMixin {
  final searchUnread = TextEditingController();
  final searchSetsched = TextEditingController();
  final searchResched = TextEditingController();

  late TabController _controllerTab;
  late int _selectedIndex;

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  bool _isLoadingUR = true;
  bool _isLoadingACC = true;
  bool _isLoadingRS = true;

  int svcSupportCount = 0;
  int svcMeetingCount = 0;
  int svcOthersCount = 0;

  DateTimeRange? selectedDate;

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

    _controllerTab = TabController(length: 3, vsync: this);
    _controllerTab.addListener(() {
      setState(() {
        _selectedIndex = _controllerTab.index;
        _getServices();
      });
    });

    _ecCalendar = [];
    _selectedIndex = 0;
    _getServices();
    _getEcCalendar();

    if (widget.message!.data["goToPage"] == "Booking") {
      _selectedIndex = 0;
      searchUnread.text = '${widget.message!.data["code"]}';
    } else if (widget.message!.data["goToPage"] == "Re-sched") {
      _selectedIndex = 2;
      searchResched.text = '${widget.message!.data["code"]}';
    } else {
      _selectedIndex = 0;
    }
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controllerTab.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<TechnicalData> _services = [];
  List<TechnicalData> _svcSupport = [];
  List<TechnicalData> _svcMeeting = [];
  List<TechnicalData> _svcOthers = [];

  _getServices() {
    if(_selectedIndex == 0){
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcSupport =
              technicalData.where((element) => (element.service == "Installation" || element.service == "Survey" || element.service == "Technical Support")
                  && (element.status == "Unread" || element.status == "Re-sched")).toList();
        });
        _isLoadingUR = false;
      });
    } else if (_selectedIndex == 1){
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcMeeting =
              technicalData.where((element) => (element.status == "Presentaion/Consultation" || element.service == "Technical Meeting")
                  && (element.status == "Unread" || element.status == "Re-sched")).toList();
        });
        _isLoadingACC = false;
      });
    }  else {
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcOthers =
              technicalData.where((element) => element.status == "Other"
                  && (element.status == "Unread" || element.status == "Re-sched")).toList();
        });
        _isLoadingRS = false;
      });
    }

    TechnicalDataServices.getTechnicalData().then((technicalData) {
      setState(() {
        _services = technicalData;
        svcSupportCount = technicalData.where((element) => (element.service == "Installation" || element.service == "Survey" || element.service == "Technical Support")
            && (element.status == "Unread" || element.status == "Re-sched")).length;

        svcMeetingCount = technicalData.where((element) => (element.service == "Presentaion/Consultation" || element.service == "Technical Meeting")
            && (element.status == "Unread" || element.status == "Re-sched")).length;

        svcOthersCount = technicalData.where((element) => element.service == "Other" && (element.status == "Unread" || element.status == "Re-sched")).length;
      });
    });
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

  //datepicker para sa date sched
  late List<CalendarData> _ecCalendar; //get the ec calendar
  DateTime initialDate = DateTime.now().add(const Duration(days: 7));
  DateTime firstDate = DateTime.now().add(Duration(days: 5));
  DateTime lastDate = DateTime.now().add(Duration(days: 60));

  _getEcCalendar(){
    CalendarServices.calendarData().then((calendarData){
      if(calendarData.isNotEmpty){
        setState(() {
          _ecCalendar = calendarData;
        });
      }
    });
  }

  String? _dropdownError; //kapag wala pa na-select sa option
  _setSched(TechnicalData services){
    // TechnicalDataServices.editToSetSched(
    //     services.id, services.svcId,
    //     DateFormat('yyyy-MM-dd').format(selectedDate!.start),
    //     DateFormat('yyyy-MM-dd').format(selectedDate!.end),
    //     valueChooseAccount!.toString(), userInfo!.userId.toString()).then((result) {
    //   if('success' == result){
    //     _getServices(); //refresh the list after update
    //     sendPushNotifications("Set-sched", services.svcId);
    //     _custSnackbar(
    //       context,
    //       "Set-schedule successfully. \n Kindly wait for client to accept it.",
    //       Colors.green,
    //       Icons.check_box
    //     );
    //     _dropdownError = null;
    //   } else {
    //     _custSnackbar(
    //         context,
    //         "Error occured...",
    //         Colors.redAccent,
    //         Icons.error
    //     );
    //   }
    // });
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

  List<TechnicalData> _filteredSvcSupport = [];
  List<TechnicalData> _filteredSvcMeeting = [];
  List<TechnicalData> _filteredSvcOthers = [];

  void filterSystemsList() {
    if(_selectedIndex == 0){
      _filteredSvcSupport = _svcSupport.where((technicalData) {
        final svcId = technicalData.svcId.toLowerCase();
        final searchQuery = searchUnread.text.toLowerCase();
        return svcId.contains(searchQuery);
      }).toList();
    } else if (_selectedIndex == 1){
      _filteredSvcMeeting = _svcMeeting.where((technicalData) {
        final svcId = technicalData.svcId.toLowerCase();
        final searchQuery = searchSetsched.text.toLowerCase();
        return svcId.contains(searchQuery);
      }).toList();
    }  else {
      _filteredSvcOthers = _svcOthers.where((technicalData) {
        final svcId = technicalData.svcId.toLowerCase();
        final searchQuery = searchResched.text.toLowerCase();
        return svcId.contains(searchQuery);
      }).toList();
    }
  }

  //this code is for tile if open, other closes
  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.message!.data["goToPage"] == "Re-sched" || widget.message!.data["goToPage"] == "Booking") {
      filterSystemsList();
    }

    return DefaultTabController(
      initialIndex: _selectedIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of all Bookings'),
          bottom: TabBar(
            controller: _controllerTab,
            isScrollable: true,
            indicatorWeight: 5.0,
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: [
                    Text("SUPPORT", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcSupportCount > 0)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red.shade300,  // Border color
                            width: 2.0,            // Border width
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          svcSupportCount.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Text("MEETING", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcMeetingCount > 0)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red.shade300,  // Border color
                            width: 2.0,            // Border width
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          svcMeetingCount.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Text("OTHERS", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcOthersCount > 0)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red.shade300,  // Border color
                            width: 2.0,            // Border width
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          svcOthersCount.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controllerTab,
          children: <Widget>[
            //UNREAD
            _isLoadingUR
                ? Center(child: SpinningContainer(controller: _controller),)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: searchUnread,
                    decoration: InputDecoration(
                      labelText: 'Search SERVICE #',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: searchUnread.text.isNotEmpty
                          ? IconButton(
                        onPressed: () {
                          searchUnread.clear();
                          FocusScope.of(context).unfocus();
                          filterSystemsList();
                        },
                        icon: const Icon(Icons.clear),
                      )
                          : null, // Set suffixIcon to null when text is empty
                    ),
                    onChanged: (value) {
                      setState(() {
                        filterSystemsList();
                        if(searchUnread.text.isEmpty){
                          FocusScope.of(context).unfocus();
                        }
                      });
                    },
                    onEditingComplete: (){
                      filterSystemsList();
                    },
                  ),
                ),
                _svcSupport.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: (Text(
                      "No Data Available",
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.grey
                      ),
                    )),
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                      itemCount: searchUnread.text.isEmpty ? _svcSupport.length : _filteredSvcSupport.length,
                      itemBuilder: (_, index){
                        TechnicalData svcUnread = searchUnread.text.isEmpty ? _svcSupport[index] : _filteredSvcSupport[index];

                        return InkWell(
                          onTap: (){
                            // _showStatusChange(context, svcUnread);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SetServicePage(services: svcUnread)),
                            ).then((value) {
                              // Refresh the services once the StatusPage is popped
                              _getServices();
                              _getEcCalendar();
                              setState(() {});
                            });
                          },
                          child: BookingtaskTile(services: svcUnread),
                        );
                      }
                  ),
                )
              ],
            ),

            //SET-SCHED
            _isLoadingACC
                ? Center(child: SpinningContainer(controller: _controller),)
                : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextField(
                      controller: searchSetsched,
                      decoration: InputDecoration(
                        labelText: 'Search SERVICE #',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchSetsched.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            searchSetsched.clear();
                            FocusScope.of(context).unfocus();
                            filterSystemsList();
                          },
                          icon: const Icon(Icons.clear),
                        )
                            : null, // Set suffixIcon to null when text is empty
                      ),
                      onChanged: (value) {
                        setState(() {
                          filterSystemsList();
                          if(searchSetsched.text.isEmpty){
                            FocusScope.of(context).unfocus();
                          }
                        });
                      },
                      onEditingComplete: (){
                        filterSystemsList();
                      },
                    ),
                  ),

                  const SizedBox(height: 25,),
                  _svcMeeting.isEmpty
                      ? const Expanded(
                    child: Center(
                      child: (Text(
                        "No Data Available",
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.grey
                        ),
                      )),
                    ),
                  )
                      : Expanded(
                    child: ListView.builder(
                        itemCount: searchSetsched.text.isEmpty ? _svcMeeting.length : _filteredSvcMeeting.length,
                        itemBuilder: (_, index){
                          TechnicalData svcSetsched = searchSetsched.text.isEmpty ? _svcMeeting[index] : _filteredSvcMeeting[index];

                          return InkWell(
                            onTap: (){
                              // _showStatusChange(context, svcSetsched);
                            },
                            child: BookingtaskTile(services: svcSetsched),
                          );
                        }
                    ),
                  ),
                ]
            ),

            //RE-SCHED
            _isLoadingRS
                ? Center(child: SpinningContainer(controller: _controller),)
                : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextField(
                      controller: searchResched,
                      decoration: InputDecoration(
                        labelText: 'Search SERVICE #',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchResched.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            searchResched.clear();
                            FocusScope.of(context).unfocus();
                            filterSystemsList();
                          },
                          icon: const Icon(Icons.clear),
                        )
                            : null, // Set suffixIcon to null when text is empty
                      ),
                      onChanged: (value) {
                        setState(() {
                          filterSystemsList();
                          if(searchResched.text.isEmpty){
                            FocusScope.of(context).unfocus();
                          }
                        });
                      },
                      onEditingComplete: (){
                        filterSystemsList();
                      },
                    ),
                  ),

                  const SizedBox(height: 25,),
                  _svcOthers.isEmpty
                      ? const Expanded(
                    child: Center(
                      child: (Text(
                        "No Data Available",
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.grey
                        ),
                      )),
                    ),
                  )
                      : Expanded(
                    child: ListView.builder(
                        itemCount: searchSetsched.text.isEmpty ? _svcOthers.length : _filteredSvcOthers.length,
                        itemBuilder: (_, index){
                          TechnicalData svcResched = searchSetsched.text.isEmpty ? _svcOthers[index] : _filteredSvcOthers[index];

                          return InkWell(
                            onTap: (){
                              // _showStatusChange(context, svcResched);
                            },
                            child: BookingtaskTile(services: svcResched),
                          );
                        }
                    ),
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }
}
