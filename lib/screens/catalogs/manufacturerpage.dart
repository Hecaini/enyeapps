import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class ManufacturersPage extends StatelessWidget {
  static const String routeName = '/manufacturer';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ManufacturersPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Manufacturers', imagePath: '',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Manufacturers Page"),
        )
    );
  }
}

