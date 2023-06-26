import 'package:enye_app/screens/login/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      fontFamily: 'Raleway',
    ),
    home: loginPage(),
  ));
}



