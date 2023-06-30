import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  static const String routeName = '/categories';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CategoriesPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Categories', imagePath: '',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Categories Page"),
        )
    );
  }
}

