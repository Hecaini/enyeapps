import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import '../../screens.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage() : super();

  static const String routeName = '/categories';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CategoriesPage()
    );
  }

  final String title = 'Categories';

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late List<Categories> _categories;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController categoryName;
  late Categories _selectedCategory;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _categories = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    categoryName = TextEditingController();
    _getCategories();
  }

  _showProgress(String message){
    setState(() {
      _titleProgess = message;
    });
  }

  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
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
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
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

  _getCategories(){
    _showProgress('Loading Categories...');
    categoriesServices.getCategories().then((categories){
      setState(() {
        _categories = categories;
      });
      _showProgress(widget.title);
      print("Length ${categories.length}");
    });
  }

  _addCategories(){
    if (_formKey.currentState!.validate()) {
      _showProgress('Adding Category...');
      categoriesServices.addCategories(categoryName.text).then((result) {
        if('success' == result){
          _getCategories();
          _clearValues();
          _successSnackbar(context, "Successfully added.");
        } else if('exist' == result){
          _errorSnackbar(context, "Category name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }
      });
    }
  }

  _editCategories(Categories category){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      _showProgress('Updating Category...');
      categoriesServices.editCategories(category.id, categoryName.text).then((result) {
        if('success' == result){
          _getCategories(); //refresh the list after update
          setState(() {
            _isUpdating = false;
          });
          _successSnackbar(context, "Edited Successfully");
          _clearValues();
        }  else if('exist' == result){
          _errorSnackbar(context, "Category name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }

      });
    }
  }

  //delete data by getting classes in services.dart
  _delCategories(Categories category){
    _showProgress('Deleting Category...');
    categoriesServices.deleteCategories(category.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");
        _getCategories();
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //emptying textfields
  _clearValues(){
    categoryName.text = '';
  }

  //show data to textfield when datatable is clicked
  _showValues(Categories category){
    categoryName.text = category.name;
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
            DataColumn(label: Text('Category Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _categories.map((categories) => DataRow(cells: [
            DataCell(Text(categories.id.toString()),
              onTap: (){
                _showValues(categories);
                _selectedCategory = categories;
                setState(() {
                  _isUpdating = true; //set flag updating to show buttons
                });
              }),
            DataCell(Text(categories.name.toString()),
              onTap: (){
                _showValues(categories);
                _selectedCategory = categories; //set the selected category to update
                setState(() {
                  _isUpdating = true; //set flag updating to show buttons
                });
              }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delCategories(categories);
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgess),
        actions: <Widget> [
          IconButton(
            onPressed: (){
              _getCategories();
            },
            icon: Icon(Icons.refresh)
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20,),
                NormalTextField(controller: categoryName, hintText: "Category Name"),

                const SizedBox(height: 20,),
                _isUpdating ?
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        _editCategories(_selectedCategory);
                      },
                      text: 'UPDATE',
                    ),

                    delButton(
                      onTap: () {
                        setState(() {
                          _isUpdating = false;
                        });
                        _clearValues();
                      },
                      text: 'CANCEL',
                    ),
                  ],
                )
                : Container(),

                const SizedBox(height: 20,),
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
          _addCategories();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

