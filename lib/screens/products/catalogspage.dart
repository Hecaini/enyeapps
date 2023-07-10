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

  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.75,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.75,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _delCatalogs(Catalogs catalogs){
    catalogsServices.deleteCatalogs(catalogs.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");//refresh the list after update
        _getCatalogs();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
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
            //DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Model Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Sized', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Sale Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _catalogs.map((Catalogs) => DataRow(cells: [
            /*DataCell(
              ConstrainedBox(constraints: BoxConstraints(maxWidth: 10, minWidth: 5),
                  child: Text(Catalogs.id.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,)),
              onTap: (){
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: editCatalogsPage.routeName, arguments: {'catalogs': Catalogs}),
                  screen: editCatalogsPage(catalogs: Catalogs,),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),*/
            DataCell(
              ConstrainedBox(constraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                  child: Text(Catalogs.model_name.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,)),
              onTap: (){
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: editCatalogsPage.routeName, arguments: {'catalogs': Catalogs}),
                  screen: editCatalogsPage(catalogs: Catalogs,),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),
            DataCell(
              ConstrainedBox(constraints: BoxConstraints(maxWidth: 150, minWidth: 50),
              child: Text(Catalogs.sized.toString(), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true,)),
              onTap: (){
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: editCatalogsPage.routeName, arguments: {'catalogs': Catalogs}),
                  screen: editCatalogsPage(catalogs: Catalogs,),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),
            DataCell(Text(Catalogs.sale_price.toString()),
              onTap: (){
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: editCatalogsPage.routeName, arguments: {'catalogs': Catalogs}),
                  screen: editCatalogsPage(catalogs: Catalogs,),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),

            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delCatalogs(Catalogs);
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
              settings: RouteSettings(name: addCatalogsPage.routeName),
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

