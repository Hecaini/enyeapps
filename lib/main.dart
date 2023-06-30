import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config/app_router.dart';


void main(){
  runApp( MaterialApp(
    title: 'ADMIN ENYE',
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      fontFamily: 'Raleway',
    ),
    onGenerateRoute: AppRouter.onGenerateRoute,
    initialRoute: '/',
  ));
}



