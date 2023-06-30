import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CatalogsPage extends StatefulWidget {
  static const String routeName = '/catalogs';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogsPage()
    );
  }

  @override
  State<CatalogsPage> createState() => _CatalogsPageState();
}

class _CatalogsPageState extends State<CatalogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0,
          centerTitle: true,
          title: Text('Catalogs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.menu, color: Colors.white,),
              onSelected: (value){
                setState((){
                  if (value == "categories"){
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: CategoriesPage.routeName,),
                      screen: CategoriesPage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  } else if (value == "sub_categories"){
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: subCategoriesPage.routeName,),
                      screen: subCategoriesPage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  } else if (value == "products"){
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: ProductsPage.routeName,),
                      screen: ProductsPage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  } else if (value == "manufacturers"){
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: ManufacturersPage.routeName,),
                      screen: ManufacturersPage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  }
                });
              },
              itemBuilder: (context)=>[
                const PopupMenuItem(child: Text("Categories"), value: 'categories',),
                const PopupMenuItem(child: Text("Sub Categories"), value: 'sub_categories',),
                const PopupMenuItem(child: Text("Products"), value: 'products',),
                const PopupMenuItem(child: Text("Manufacturers"), value: 'manufacturers',),
              ]
            ),
          ],
        ),
        /*drawer: CustomDrawer(),*/
        body: Container(
          child: Text("Catalogs Page"),
        )
    );
  }
}

