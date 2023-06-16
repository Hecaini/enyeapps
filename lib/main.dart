import 'package:enye_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main(){
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppPage.getnavbar(),
    getPages: AppPage.routes,
  ));
}


