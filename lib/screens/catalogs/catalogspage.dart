import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class CatalogsPage extends StatefulWidget {
  static const String routeName = '/catalogs';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogsPage()
    );
  }

  final String title = 'Catalogs';

  @override
  _CatalogsPageState createState() => _CatalogsPageState();
}

class _CatalogsPageState extends State<CatalogsPage> {
  late String _titleProgess;
  late List<Catalogs> _catalogs;
  late TextEditingController searchBox;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _titleProgess = widget.title;
    searchBox = TextEditingController();
    _catalogs = [];
    _getCatalogs();
  }

  _showProgress(String message){
    setState(() {
      _titleProgess = message;
    });
  }

  _getCatalogs(){
    _showProgress('Loading Catalogs...');
    catalogsServices.getCatalogs().then((Catalogs){
      setState(() {
        _catalogs = Catalogs;
      });
      _showProgress(widget.title);
      print("Length ${Catalogs.length}");
    });
  }

  //data table select all
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Model Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Sized', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Sale Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Manufacturer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _catalogs.map((Catalogs) => DataRow(cells: [
            DataCell(Text(Catalogs.id.toString()),
                onTap: (){
                  /*_showValues(Products);
                  _selectedProduct = Products;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });*/
                }),
            DataCell(Text(Catalogs.model_name.toString()),
                onTap: (){

                }),
            DataCell(Text(Catalogs.sized.toString()),
                onTap: (){

                }),
            DataCell(Text(Catalogs.sale_price.toString()),
                onTap: (){

                }),
            DataCell(Text(Catalogs.products_id.toString()),
                onTap: (){

                }),
            DataCell(Text(Catalogs.manufacturer_id.toString()),
                onTap: (){

                }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                //_delProducts(_selectedProduct);
              },
            )),
          ])).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(_titleProgess, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
                onPressed: (){
                  _getCatalogs();
                },
                icon: Icon(Icons.refresh)
            ),

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
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 20,),
                  NormalTextField(controller: searchBox, hintText: ""),

                  const SizedBox(height: 5,),
                  Expanded(
                    child: _dataBody(),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: addCatalogsPage.routeName,),
              screen: addCatalogsPage(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Icon(Icons.add),
        ),
    );
  }
}

