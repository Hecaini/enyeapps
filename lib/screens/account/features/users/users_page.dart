import 'package:enye_app/screens/account/features/users/users_tasktile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../screens.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  static const String routeName = '/user';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const UsersPage()
    );
  }

  final String title = 'Users Info';

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin{
  late TabController _controller;
  List<String> userStatus = <String>['Manager', 'Assistant', 'Admin', 'Employee'];
  int _selectedIndex = 0;

  late List<UsersInfo> _users;
  late List<Department> _department;
  late List<Position> _position;

  void initState(){
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
        _getUsersInfo();
      });
      print("Selected Index: " + _controller.index.toString());
    });

    _getUsersInfo();
    _getDepartments();
    _getPositions();
    _users = [];
    _department = [];
    _position = [];
  }

  @override
  void dispose() {
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


  _getUsersInfo(){
    if(_selectedIndex == 0){
      UsersInfoServices.getUsersInfo().then((UsersInfo){
        setState(() {
          _users = UsersInfo.where((user) => user.status == "").toList();
        });
      });
    } else {
      UsersInfoServices.getUsersInfo().then((UsersInfo){
        setState(() {
          _users = UsersInfo.where((user) => user.status != "").toList();
        });
      });
    }
  }

  _getDepartments(){
    DepartmentServices.getDepartments().then((department){
      setState(() {
        _department = department;
      });
    });
  }

  _getPositions(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });
  }

  _editStatus(UsersInfo user){
    UsersInfoServices.editStatus(user.user_id, valueChooseStatus.toString()).then((result) {
      if('success' == result){
        _getUsersInfo(); //refresh the list after update
        //sendPushNotifications("On Process", services.svcId);
        _successSnackbar(context, "Status Changed Successfully");
        _dropdownError = null;
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  String? valueChooseStatus;
  String? _dropdownError; //kapag wala pa na-select sa option
  void _showStatusChange(BuildContext context, UsersInfo user,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return Dialog(
          // Set dialog properties such as shape, elevation, etc.
          child: StatefulBuilder(
            builder: (BuildContext context, setState){
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Status for USER to Login",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),
                      ),
                    ),
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
                        value: valueChooseStatus,
                        onChanged: (value){
                          setState(() {
                            valueChooseStatus = value;
                          });
                        },
                        hint: const Text("Select Status of Employee"),
                        items: userStatus.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.bottomCenter,
                            value: value,
                            child: Text(value, textAlign: TextAlign.center,),
                          );
                        }).toList(),
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

                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        if (valueChooseStatus == null || valueChooseStatus!.isEmpty) {
                          setState(() => _dropdownError = "Please select an option!");
                        } else {
                          _editStatus(user);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.deepOrangeAccent,
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      valueChooseStatus = null;
      _dropdownError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _selectedIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users Information'),
          bottom: TabBar(
            controller: _controller,
            indicatorWeight: 5.0,
            tabs: <Widget>[
              Tab(
                child: Text("NEW", style: GoogleFonts.rowdies(
                  textStyle: const TextStyle(fontSize: 18.0, letterSpacing: 3.0)
                ),),
              ),
              Tab(
                child: Text("OLD", style: GoogleFonts.rowdies(
                    textStyle: const TextStyle(fontSize: 18.0, letterSpacing: 3.0)
                ),),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            //NEW USERS
            ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_, index){
                UsersInfo users = _users[index];

                return InkWell(
                  onTap: (){
                    _showStatusChange(context, users);
                  },
                  child: UsertaskTile(
                    users: users,
                    departments: _department.where((element) => element.id == users.department).elementAtOrNull(0)!.deptShname.toString(),
                    position: _position.where((element) => element.id == users.position).elementAtOrNull(0)!.position.toString(),
                  ),
                );
              }
            ),

            //OLD USERS
            ListView.builder(
                itemCount: _users.length,
                itemBuilder: (_, index){
                  UsersInfo users = _users[index];

                  return InkWell(
                    onTap: (){

                    },
                    child: UsertaskTile(
                      users: users,
                      departments: _department.where((element) => element.id == users.department).elementAtOrNull(0)!.deptShname.toString(),
                      position: _position.where((element) => element.id == users.position).elementAtOrNull(0)!.position.toString(),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}