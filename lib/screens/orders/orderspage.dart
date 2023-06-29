import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  static const String routeName = '/orders';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OrdersPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Orders', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Orders Page"),
        )
    );
  }
}

