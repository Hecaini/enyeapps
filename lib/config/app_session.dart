import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../screens/screens.dart';
import '../widget/widgets.dart';

class CheckSession extends StatefulWidget {
  const CheckSession({super.key});

  @override
  State<CheckSession> createState() => _CheckSessionState();
}

class _CheckSessionState extends State<CheckSession> {
  late Future _userSessionFuture;

  @override
  void initState() {
    _userSessionFuture = _getUserSessionStatus();
    super.initState();
  }

  Future<bool> _getUserSessionStatus() async {
    return SessionManager().containsKey("user_data");
  }

  Widget _loadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _userSessionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool userLoginStatus = snapshot.data;
            return userLoginStatus ? const CustomNavBar() : LoginPage();
          } else {
            return _loadingScreen();
          }
        },
      ),
    );
  }
}

class CheckSessionData {

  Future<bool> getUserSessionStatus() async {
    return SessionManager().containsKey("user_data");
  }

  Future <UserLogin> getClientsData() async {
    UserLogin userLogin = UserLogin.fromJson(await SessionManager().get("user_data"));
    return userLogin;
  }

}
