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
class UnreadPage extends StatefulWidget {

  static const String routeName = '/unread';

  RemoteMessage? message;

  UnreadPage({super.key, required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => UnreadPage(message: message,)
    );
  }

  @override
  State<UnreadPage> createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage> with TickerProviderStateMixin {
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

  int svcUnreadCount = 0;
  int svcSetschedCount = 0;
  int svcReschedCount = 0;

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

    _svcUnread = [];
    _svcSetsched = [];
    _svcResched = [];
    _ecCalendar = [];
    _selectedIndex = 0;
    _getServices();
    _getEcCalendar();

    _users = [];
    _filteredUsers = [];
    _department = [];
    _position = [];
    _filteredPosition = [];
    _getAccounts();
    _getDepartments();
    _getPositions();

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

  //snackbars
  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  late List<TechnicalData> _services;
  late List<TechnicalData> _svcUnread;
  late List<TechnicalData> _svcSetsched;
  late List<TechnicalData> _svcResched;

  _getServices() {
    if(_selectedIndex == 0){
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcUnread =
              technicalData.where((element) => element.status == "Unread").toList();
        });
        _isLoadingUR = false;
      });
    } else if (_selectedIndex == 1){
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcSetsched =
              technicalData.where((element) => element.status == "Set-sched").toList();
        });
        _isLoadingACC = false;
      });
    }  else {
      TechnicalDataServices.getTechnicalData().then((technicalData) {
        setState(() {
          _svcResched =
              technicalData.where((element) => element.status == "Re-sched").toList();
        });
        _isLoadingRS = false;
      });
    }

    TechnicalDataServices.getTechnicalData().then((technicalData) {
      setState(() {
        _services = technicalData;
        svcUnreadCount = technicalData.where((element) => element.status == "Unread").length;
        svcSetschedCount = technicalData.where((element) => element.status == "Set-sched").length;
        svcReschedCount = technicalData.where((element) => element.status == "Re-sched").length;
      });
    });
  }


  //initialDate configurator kapag naka-disable yung date +1 sa days and so on
  bool selectableDayPredicate(DateTime date) {

    int scheduledServiceCount = _services.where((services) {
      if (services.status != "Cancelled"){
        if(DateTime.parse(services.dateSched).month == date.month
            && DateTime.parse(services.dateSched).day == date.day
            && DateTime.parse(services.dateSched).year == date.year){
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).length;

    bool isDateDisabled = _ecCalendar.any((calendarData) {
      DateTime startDate = DateTime.parse(calendarData.start);
      DateTime endDate = DateTime.parse(calendarData.end);

      for (DateTime currentDate = startDate;
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
      currentDate = currentDate.add(const Duration(days: 1))) {
        if (currentDate.month == date.month
            && currentDate.day == date.day
            && currentDate.year == date.year) {
          return true;
        }
      }
      return false;
    });

    if (scheduledServiceCount >= 2){
      return true;
    } else if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return true;
    } else if (isDateDisabled) {
      return true;
    } else {
      return false;
    }
  }

  //datepicker para sa date sched
  late List<CalendarData> _ecCalendar; //get the ec calendar
  DateTime initialDate = DateTime.now().add(const Duration(days: 7));
  DateTime firstDate = DateTime.now().add(Duration(days: 5));
  DateTime lastDate = DateTime.now().add(Duration(days: 60));

  _getEcCalendar(){
    CalendarServices.calendarData(
        DateFormat('yyyy-MM-dd').format(firstDate),
        DateFormat('yyyy-MM-dd').format(lastDate)
    ).then((calendarData){
      if(calendarData.isNotEmpty){
        setState(() {
          _ecCalendar = calendarData;
        });
      }
    });
  }

  void _selectDate(BuildContext context, TechnicalData services, Function(DateTimeRange) onDateSelected) async {
    //initialDate configurator kapag naka-disable yung date +1 sa days and so on
    /*while (selectableDayPredicate(initialDate)) {
      initialDate = initialDate.add(Duration(days: 1));
    }*/

    DateTimeRange? pickedDate = await showDateRangePicker(
        context: context,
        /*initialDate: selectedDate ?? initialDate,*/
        firstDate: services.status == "Re-sched" ? DateTime.parse(services.sDateSched.toString()) : firstDate,
        lastDate: services.status == "Re-sched" ? DateTime.parse(services.eDateSched.toString()) : lastDate,
        /*selectableDayPredicate: (DateTime date) {
          if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
            return false;
          }

          //this code is from ChatGPT to disable dates came from ec calendar HR
          bool isDateDisabled = _ecCalendar.any((CalendarData) {
            DateTime startDate = DateTime.parse(CalendarData.start);
            DateTime endDate = DateTime.parse(CalendarData.end);

            for (DateTime currentDate = startDate;
            currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
            currentDate = currentDate.add(Duration(days: 1))) {
              if (currentDate.isAtSameMomentAs(date)) {
                return true;
              }
            }
            return false;
          });

          if (isDateDisabled) {
            return false;
          }

          //database counting if may sched na disabled na sya
          int scheduledServiceCount = _services.where((services) {
            if (services.status != "Cancelled"){
              return DateTime.parse(services.dateSched).isAtSameMomentAs(date);
            } else {
              return false;
            }
          }).length;
          return scheduledServiceCount < 2;
        }*/
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
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

  String? _dropdownError; //kapag wala pa na-select sa option
  _setSched(TechnicalData services){
    TechnicalDataServices.editToSetSched(
        services.id, services.svcId,
        DateFormat('yyyy-MM-dd').format(selectedDate!.start),
        DateFormat('yyyy-MM-dd').format(selectedDate!.end),
        valueChooseAccount!.toString(), userInfo!.userId.toString()).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        sendPushNotifications("Set-sched", services.svcId);
        _successSnackbar(context, "Set-schedule successfully. \n Kindly wait for client to accept it.");
        _dropdownError = null;
      } else {
        _errorSnackbar(context, "Error occured...");
      }
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

  String? valueChooseAccount;
  String? valueChooseDepartment;
  String? valueChoosePosition;
  String? valueChooseStatus;
  void _showStatusChange(BuildContext context, TechnicalData services) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Set dialog properties such as shape, elevation, etc.
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Availability Date",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                      ),
                    ),

                    //select date range of availability
                    InkWell(
                      onTap: () {
                        _selectDate(context, services, (DateTimeRange pickedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate != null
                                  ? '${DateFormat('EEE, MMM d').format(selectedDate!.start)} TO ${DateFormat('EEE, MMM d').format(selectedDate!.end)}'
                                  : 'Select Date *',
                              style: GoogleFonts.lato(
                                textStyle:
                                const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.8),
                              ),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.deepOrange,),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Select Person In-Charge",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                      ),
                    ),

                    _dropdownError == null
                        ? SizedBox.shrink()
                        : Text(
                      _dropdownError ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 0.8),
                    ),


                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton(
                        alignment: Alignment.bottomCenter,
                        underline:Container(),
                        style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        isDense: true,
                        iconSize: 36,
                        iconEnabledColor: Colors.deepOrange,
                        isExpanded: true,
                        value: valueChooseDepartment,
                        onChanged: (value){
                          setState(() {
                            //use for clearing lang para once magbago
                            //  yung department mag-empty muna yung position (iwas error)
                            if(valueChoosePosition != null){
                              valueChoosePosition = null;
                            }

                            if(valueChooseAccount != null){
                              valueChooseAccount = null;
                            }

                            valueChooseDepartment = value;
                            _filteredPosition = _position.where((element) => element.departmentId == value).toList();
                            _filteredUsers = _users.where((element) => element.department == value).toList();

                            if(_filteredUsers.isEmpty){
                              _dropdownError = "Selected Department has NO DATA. \n SHOWED ALL USERS";
                            } else {
                              _dropdownError = null;
                            }
                          });
                        },
                        hint: const Text("Department"),
                        items: _department.map((department) => DropdownMenuItem(
                          alignment: Alignment.bottomCenter,
                          value: department.id.toString(),
                          child: Text(department.deptShname.toString(), textAlign: TextAlign.center,),
                        )).toList(),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton(
                        alignment: Alignment.bottomCenter,
                        underline:Container(),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        isDense: true,
                        iconSize: 36,
                        iconEnabledColor: Colors.deepOrange,
                        isExpanded: true,
                        value: valueChoosePosition,
                        onChanged: (value){
                          setState(() {
                            valueChoosePosition = value;

                            if(valueChooseAccount != null){
                              valueChooseAccount = null;
                            }

                            if(valueChooseDepartment != null) {
                              _filteredUsers = _users.where((element) => element.position == value && element.department == valueChooseDepartment).toList();
                            } else {
                              _filteredUsers = _users.where((element) => element.position == value).toList();
                            }

                            if(_filteredUsers.isEmpty){
                              _dropdownError = "Selected Position has NO DATA. \n SHOWED ALL USERS";
                            } else {
                              _dropdownError = null;
                            }
                          });
                        },
                        hint: const Text("Position"),
                        items: _filteredPosition.isEmpty
                            ? _position.map((position) => DropdownMenuItem(
                          alignment: Alignment.bottomCenter,
                          value: position.id.toString(),
                          child: Text(position.position.toString(), textAlign: TextAlign.center,),
                        )).toList()
                            : _filteredPosition.map((position) => DropdownMenuItem(
                          alignment: Alignment.bottomCenter,
                          value: position.id.toString(),
                          child: Text(position.position.toString(), textAlign: TextAlign.center,),
                        )).toList(),
                      ),
                    ),

                    //drop-down button svc handler
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton(
                        alignment: Alignment.bottomCenter,
                        underline:Container(),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        isDense: true,
                        iconSize: 36,
                        iconEnabledColor: Colors.deepOrange,
                        isExpanded: true,
                        value: valueChooseAccount,
                        onChanged: (value){
                          setState(() {
                            valueChooseAccount = value;
                          });
                        },
                        hint: const Text("Select Person In Charge * "),
                        items: _filteredUsers.isEmpty
                            ? _users.map((accountInfo) => DropdownMenuItem(
                          alignment: Alignment.bottomCenter,
                          value: accountInfo.user_id.toString(),
                          child: Text("${accountInfo.name.toString()} || ${_position.where((element) => element.id == accountInfo.position).elementAtOrNull(0)?.position}", textAlign: TextAlign.center,),
                        )).toList()
                            : _filteredUsers.map((accountInfo) => DropdownMenuItem(
                          alignment: Alignment.bottomCenter,
                          value: accountInfo.user_id.toString(),
                          child: Text("${accountInfo.name.toString()} || ${_position.where((element) => element.id == accountInfo.position).elementAtOrNull(0)?.position}", textAlign: TextAlign.center,),
                        )).toList(),
                      ),
                    ),

                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        if (selectedDate == null || valueChooseAccount == null || valueChooseAccount!.isEmpty) {
                          setState(() => _dropdownError = "Please select an option!\n Required Date and Person In Charge");
                        } else {
                          _setSched(services);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.deepOrangeAccent,
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        );
      },
    ).whenComplete(() {
      valueChooseAccount = null;
      valueChooseDepartment = null;
      valueChoosePosition = null;
      selectedDate = null;
      _dropdownError = null;
    });
  }

  List<TechnicalData> _filteredSvcUnread = [];
  List<TechnicalData> _filteredSvcSetsched = [];
  List<TechnicalData> _filteredSvcResched = [];

  void filterSystemsList() {
    if(_selectedIndex == 0){
      _filteredSvcUnread = _svcUnread.where((technicalData) {
        final svcId = technicalData.svcId.toLowerCase();
        final searchQuery = searchUnread.text.toLowerCase();
        return svcId.contains(searchQuery);
      }).toList();
    } else if (_selectedIndex == 1){
      _filteredSvcSetsched = _svcSetsched.where((technicalData) {
        final svcId = technicalData.svcId.toLowerCase();
        final searchQuery = searchSetsched.text.toLowerCase();
        return svcId.contains(searchQuery);
      }).toList();
    }  else {
      _filteredSvcResched = _svcResched.where((technicalData) {
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
                    Text("UNREAD", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcUnreadCount > 0)
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
                        svcUnreadCount.toString(),
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
                    Text("SET SCHED", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcSetschedCount > 0)
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
                        svcSetschedCount.toString(),
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
                    Text("RE-SCHED", style: GoogleFonts.rowdies(
                        textStyle: const TextStyle(fontSize: 9.0, letterSpacing: 2.0)
                    ),),

                    if(svcReschedCount > 0)
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
                        svcReschedCount.toString(),
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
                    _svcUnread.isEmpty
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
                          itemCount: searchUnread.text.isEmpty ? _svcUnread.length : _filteredSvcUnread.length,
                          itemBuilder: (_, index){
                            TechnicalData svcUnread = searchUnread.text.isEmpty ? _svcUnread[index] : _filteredSvcUnread[index];

                            return InkWell(
                              onTap: (){
                                _showStatusChange(context, svcUnread);
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
                  _svcSetsched.isEmpty
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
                        itemCount: searchSetsched.text.isEmpty ? _svcSetsched.length : _filteredSvcSetsched.length,
                        itemBuilder: (_, index){
                          TechnicalData svcSetsched = searchSetsched.text.isEmpty ? _svcSetsched[index] : _filteredSvcSetsched[index];

                          return InkWell(
                            onTap: (){
                              _showStatusChange(context, svcSetsched);
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
                  _svcResched.isEmpty
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
                        itemCount: searchSetsched.text.isEmpty ? _svcResched.length : _filteredSvcResched.length,
                        itemBuilder: (_, index){
                          TechnicalData svcResched = searchSetsched.text.isEmpty ? _svcResched[index] : _filteredSvcResched[index];

                          return InkWell(
                            onTap: (){
                              _showStatusChange(context, svcResched);
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
