import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
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

  //this is to configure if the user already signed in
  CheckSessionData().getUserSessionStatus().then((userSession) {
    if (userSession == true) {
      CheckSessionData().getClientsData().then((value) {
        TokenServices.updateToken(token.toString(), value.userId).then((result) {
          if('success' == result){
            print("Updated token successfully");
          } else {
            print("Error updating token");
          }
        });
      });
    } else {
      TokenServices.updateToken(token.toString(), "").then((result) {
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
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme.copyWith(
              // Modify the TextStyle for different text elements here
              displayLarge: const TextStyle(
                fontSize: 24,
                letterSpacing: 1.5, // Adjust the letter spacing here
              ),
              bodyLarge: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 0.8, // Adjust the letter spacing here
              ),
              // Add more TextStyle entries as needed
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        home: const CheckSession(),
      );
    })
  );

}



