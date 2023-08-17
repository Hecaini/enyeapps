import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/config.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //to update token in database always everytime app opened
  dynamic token = await SessionManager().get("token");
  String user_id = "";

  //this is to configure if the user already signed in
  CheckSessionData().getUserSessionStatus().then((bool) {
    if (bool == true) {
      CheckSessionData().getClientsData().then((value) {
        TokenServices.updateToken(token.toString(), value.user_id).then((result) {
          if('success' == result){
            print("Updated token successfully");
          } else {
            print("Error updating token");
          }
        });
      });
    } else {
      TokenServices.updateToken(token.toString(), user_id.toString()).then((result) {
        if('success' == result){
          print("Updated token successfully");
        } else {
          print("Error updating token");
        }
      });
    }
  });

  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'ADMIN ENYE',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        navigatorKey: navigatorKey,
        home: const CheckSession(),
      );
    })
  );

}



