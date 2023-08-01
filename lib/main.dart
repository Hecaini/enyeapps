import 'package:enye_app/screens/login/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'config/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("USER DATA: ${await SessionManager().containsKey("user_data")}");

  if (await SessionManager().containsKey("user_data") == false){
    runApp( MaterialApp(
      title: 'ADMIN ENYE',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Raleway',
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    ));
  } else {
    runApp( MaterialApp(
      title: 'ADMIN ENYE',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Raleway',
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/navbar',
      onGenerateRoute: AppRouter.onGenerateRoute,
    ));
  }
}



