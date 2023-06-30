import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  static const String routeName = '/products';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Products', imagePath: '',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Products Page"),
        )
    );
  }
}

