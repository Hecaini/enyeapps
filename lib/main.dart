import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'config/app_session.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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



