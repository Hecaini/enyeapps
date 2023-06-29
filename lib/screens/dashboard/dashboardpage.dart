import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => DashboardPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Container(
        child: Text("Dashboard Page"),
      )
    );
  }
}

