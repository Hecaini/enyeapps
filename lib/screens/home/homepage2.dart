import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SecondScreen extends StatelessWidget {
  static const String routeName = '/home2';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SecondScreen()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
      body: Container(
        child: TextButton(
            onPressed: (){

            },
            child: Icon(Icons.arrow_forward, color: Colors.deepOrange,)
        ),
      ),
    );
  }
}