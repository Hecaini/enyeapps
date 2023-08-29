import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _TechSchedPageState extends State<TechSchedPage> {
  final RemoteMessage message = const RemoteMessage();

  TextEditingController? searchTransaction;
  final TextEditingController note = TextEditingController();

  final kToday = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

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

    //calling session data
    CheckSessionData().getUserSessionStatus().then((userSession) {
      if (userSession == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getServices();
        });
        userSessionFuture = userSession;
      } else {
        userSessionFuture = userSession;
      }
    });

    if(widget.message!.data["datesched"] != null){
      _selectedDay = DateTime.parse(widget.message?.data["datesched"]);

      /*WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()),
        );
      });*/
    } else {
      _selectedDay = _focusedDay;
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

  //below this are for technical datas get to server
  late List<TechnicalData> _services;
  _getServices(){
    if(userInfo?.status == "Employee") {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status != "Completed" && element.status != "Cancelled" && element.svcHandler == userInfo?.userId).toList();
        });
      });
    } else {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status != "Completed" && element.status != "Cancelled").toList();
        });
      });
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
  _editToOnProcess(TechnicalData services){
    TechnicalDataServices.editToOnProcess(services.id, services.svcId, valueChooseAccount!.toString(), userInfo!.userId.toString()).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        sendPushNotifications("On Process", services.svcId);
        _successSnackbar(context, "Acknowledge Successfully");
        _dropdownError = null;
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  _editToCompleted(TechnicalData services){
    TechnicalDataServices.editTaskCompleted(services.id, services.svcId, note.text.trim()).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        sendPushNotifications("Completed", services.svcId);
        _successSnackbar(context, "Task Completed Successfully");
        note.text = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Technical Schedule', imagePath: 'assets/logo/enyecontrols.png',),
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //_addTaskBar(),
          _addDateBar(),

          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: _services.length,
              itemBuilder: (_, index){
                TechnicalData services = _services[index];

                if (DateFormat.yMd().format(DateTime.parse(services.dateSched)) == DateFormat.yMd().format(_selectedDay!)){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(context, services);
                              },
                              child: TaskTile(services: services),
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
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheet (BuildContext context, TechnicalData services) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: (services.status == "On Process" && userInfo?.status == "Employee")
            || (services.status == "Unread" && userInfo?.status != "Employee")
            || (services.status == "On Process" && userInfo?.status != "Employee" && services.svcHandler == userInfo?.userId)
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

              services.status == "Unread" ?
              _bottomSheetButton(
                label: "Acknowledge",
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    _showAnotherBottomSheet(context, services, "Acknowledge");
                  });
                },
                clr: Colors.blue,
                context:context,
              ): Container(),

              (services.status == "On Process" && userInfo?.status == "Employee")
                || (services.status == "On Process" && userInfo?.status != "Employee" && services.svcHandler == userInfo?.userId) ?
              _bottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    _showAnotherBottomSheet(context, services, "Task Completed");
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
                    _showAnotherBottomSheet(context, services, "View");
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
  _showAnotherBottomSheet (BuildContext context, TechnicalData services, String whatToDo) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: MasonryGridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              children: <Widget> [
                Container(
                  height: 6,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4, right: MediaQuery.of(context).size.width * 0.4, top: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                  ),
                ),

                const SizedBox(height: 30,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        softWrap: true,
                        text:TextSpan(
                          children: <TextSpan> [
                            const TextSpan(text: "Title :  ",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                            TextSpan(text: services.svcTitle,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                          ]
                        )
                      ),

                      const SizedBox(height: 10,),
                      RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              const TextSpan(text: "Description :  ",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                              TextSpan(text: services.svcDesc,
                                style: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.8),),
                            ]
                        )
                      ),

                      const SizedBox(height: 15,),
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
                            DateFormat.yMMMMd().format(DateTime.parse(services.dateSched)),
                            style: GoogleFonts.lato(
                              textStyle:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Client Name : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientName}",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                                ),

                                const SizedBox(height: 5,),
                                const Text("Contact : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientContact}",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                                ),

                                const SizedBox(height: 5,),
                                const Text("Email : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: services.clientEmail,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                                ),
                                //Text(services.svcDesc, maxLines: 5, softWrap: false,),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Project Name : ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientProjName}",
                                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500, letterSpacing: 0.8),),
                                ),

                                const SizedBox(height: 5,),
                                const Text("Company :", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientCompany}",
                                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500, letterSpacing: 0.8),),
                                ),

                                const SizedBox(height: 5,),
                                const Text("Location :", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${services.clientLocation}",
                                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500, letterSpacing: 0.8),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                whatToDo == "View"
                 ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30,),

                      services.svcHandler != ''
                       ? RichText(
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                const TextSpan(text: "Person In Charge :  ",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepOrange, letterSpacing: 0.8),),

                                TextSpan(text: _users.where((accInfo) => accInfo.user_id == services.svcHandler).elementAt(0).name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54, letterSpacing: 0.8),),

                                TextSpan(text: "\n\t ${_users.where((accInfo) => accInfo.user_id == services.svcHandler).elementAt(0).position} || ${_users.where((accInfo) => accInfo.user_id == services.svcHandler).elementAt(0).contact}",
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      )
                       : const SizedBox.shrink(),

                      const SizedBox(height: 20,),
                      services.notesComplete != ''
                        ? RichText(
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              const TextSpan(text: "Notes :  ",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepOrange, letterSpacing: 0.8),),

                              TextSpan(text: services.notesComplete,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54, letterSpacing: 0.8),),
                            ]
                        )
                    )
                        : const SizedBox.shrink(),
                    ],
                  ),
                )
                 : const SizedBox.shrink(),

                //save data into On Process
                whatToDo == "Acknowledge"
                 ? StatefulBuilder(
                  builder: (BuildContext context, setState){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [

                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                height: 55,
                                width: MediaQuery.of(context).size.width * 0.35,
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

                                      valueChooseDepartment = value;
                                      _filteredPosition = _position.where((element) => element.departmentId == value).toList();
                                      _filteredUsers = _users.where((element) => element.department == value).toList();

                                      if(_filteredUsers.isEmpty){
                                        _dropdownError = "Selected Department has NO DATA, SHOW ALL USERS";
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
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                height: 55,
                                width: MediaQuery.of(context).size.width * 0.52,
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
                                      if(valueChooseDepartment != null) {
                                        _filteredUsers = _users.where((element) => element.position == value && element.department == valueChooseDepartment).toList();
                                      } else {
                                        _filteredUsers = _users.where((element) => element.position == value).toList();
                                      }

                                      if(_filteredUsers.isEmpty){
                                        _dropdownError = "Selected Position has NO DATA, SHOW ALL USERS";
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
                            ],
                          ),

                          //drop-down button svc handler
                          const SizedBox(height: 10,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.9,
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
                          _bottomSheetButton(
                            label: "Proceed to Processing",
                            onTap: (){
                              if (valueChooseAccount == null || valueChooseAccount!.isEmpty) {
                                setState(() => _dropdownError = "Please select Person In Charge !");
                              } else {
                                setState(() {
                                  _editToOnProcess(services);
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            clr: Colors.green,
                            context:context,
                          ),
                        ],
                      )
                    );
                  }
                )
                 : const SizedBox.shrink(),

                //save data into Task Completed
                whatToDo == "Task Completed"
                    ? StatefulBuilder(
                    builder: (BuildContext context, setState){
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [

                              //drop-down button
                              const SizedBox(height: 10,),
                              NormalTextField(
                                controller: note,
                                hintText: 'Note',
                                disabling: false,
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
                              _bottomSheetButton(
                                label: "Task Completed",
                                onTap: (){
                                  setState(() {
                                    if (note.text.trim().isEmpty) {
                                      setState(() => _dropdownError = "Fill out the fields!");
                                    } else {
                                      setState(() {
                                        _editToCompleted(services);
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  });
                                },
                                clr: Colors.green,
                                context:context,
                              ),
                            ],
                          )
                      );
                    }
                )
                    : const SizedBox.shrink(),

                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _bottomSheetButton(
                    label: "Close",
                    onTap: (){
                      _dropdownError = null;
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
      _dropdownError = null;
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
        eventLoader: (day) => _services.where((services) => isSameDay(DateTime.parse(services.dateSched),day)).toList(),
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

