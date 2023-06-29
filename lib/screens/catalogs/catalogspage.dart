import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class CatalogsPage extends StatelessWidget {
  static const String routeName = '/catalogs';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Catalogs', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Catalogs Page"),
        )
    );
  }
}

