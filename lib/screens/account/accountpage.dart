import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/account';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AccountPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Account Details Page"),
        )
    );
  }
}

