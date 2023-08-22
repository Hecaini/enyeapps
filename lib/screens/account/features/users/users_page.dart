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

                  },
                  child: UsertaskTile(
                    users: users,
                    departments: _department.where((element) => element.id == users.department).elementAt(0).deptShname.toString(),
                    position: _position.where((element) => element.id == users.position).elementAt(0).position.toString(),
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