import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class subCategoriesPage extends StatelessWidget {
  static const String routeName = '/subcategories';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => subCategoriesPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Sub Categories', imagePath: '',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Sub Categories Page"),
        )
    );
  }
}

