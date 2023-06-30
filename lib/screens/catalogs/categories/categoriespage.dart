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

  _showSnackbar(context, message){
    //_scaffoldKey.currentState?.showSnackbar(SnackBar(content: Text(message)));
  }

  _getCategories(){
    _showProgress('Loading Categories...');
    Services.getCategories().then((categories){
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
      Services.addCategories(categoryName.text).then((result) {
        if('success' == result){
          _getCategories();
          _clearValues();
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
      Services.editCategories(category.id, categoryName.text).then((result) {
        if('success' == result){
          _getCategories(); //refresh the list after update
          setState(() {
            _isUpdating = false;
          });
          _clearValues();
        }

      });
    }
  }

  _delCategories(Categories category){
    if (_formKey.currentState!.validate()) {
      _showProgress('Deleting Category...');
      Services.deleteCategories(category.id).then((result) {
        if('success' == result){
          _getCategories();
          _clearValues();
        }

      });
    }
  }

  _clearValues(){
    categoryName.text = '';
  }

  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Category Name')),
          ],
          rows: _categories.map((categories) => DataRow(cells: [
            DataCell(Text(categories.id.toString())),
            DataCell(Text(categories.name.toString())),
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
                _isUpdating ?
                Row(
                  children: <Widget>[
                    editButton(
                      onTap: () {
                        //_editCategories();
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

