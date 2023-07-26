import 'package:enye_app/screens/login/loginpage.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class checkSession extends StatefulWidget {
  const checkSession({super.key});

  @override
  State<checkSession> createState() => _checkSessionState();
}

class _checkSessionState extends State<checkSession> {
  late Future _userSessionFuture;

  @override
  void initState() {
    _userSessionFuture = this._getUserSessionStatus();
    super.initState();
  }

  Future<bool> _getUserSessionStatus() async {
    return SessionManager().containsKey("user_data");
  }

  Widget _loadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      // appBar: AppBar(
      //   title: Text('Navigation POC'),
      // ),
      //drawer: SideMenu(),
      body: FutureBuilder(
        future: _userSessionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool _userLoginStatus = snapshot.data;
            return _userLoginStatus ? CustomNavBar() : loginPage();
          } else {
            return _loadingScreen();
          }
        },
      ),
    );
  }
}
