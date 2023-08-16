import 'package:enye_app/config/api_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/app_session.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
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
        ),
        navigatorKey: navigatorKey,
        home: checkSession(),
      );
    })
  );

}



