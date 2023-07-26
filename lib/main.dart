import 'package:enye_app/screens/login/loginpage.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'config/app_router.dart';
import 'config/app_session.dart';

void main() {

  runApp( MaterialApp(
    title: 'ADMIN ENYE',
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      fontFamily: 'Raleway',
    ),
    home: checkSession(),
  ));

}



