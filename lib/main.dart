import 'package:enye_app/config/api_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'config/app_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'ADMIN ENYE',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Raleway',
        ),
        home: checkSession(),
      );
    })
  );

}



