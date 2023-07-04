import 'package:flutter/material.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class subCategoriesPage extends StatefulWidget {
  subCategoriesPage() : super();

  static const String routeName = '/subcategories';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => subCategoriesPage()
    );
  }

  final String title = 'Sub Categories';


  @override
  _subCategoriesPageState createState() => _subCategoriesPageState();
}

class _subCategoriesPageState extends State<subCategoriesPage> {

  late List<Categories> _categories;
  late List<subCategories> _subcategories;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController subCategoryName;
  late subCategories _selectedSubCategory;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _subcategories = [];
    _categories = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    subCategoryName = TextEditingController();
    _getSubCategories();
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

  _getSubCategories(){
    _showProgress('Loading Sub Categories...');

    subCatServices.getSubCategories().then((subCategories){ //para pumunta sa PHP file na subCategories at hindi sa PRODUCTS
      setState(() {
        _subcategories = subCategories;
      });
      _showProgress(widget.title);
      print("Length ${subCategories.length}");
    });
  }

  _addSubCategories(){
    if (_formKey.currentState!.validate()) {
      if (valueChoose == null) {
        setState(() => _dropdownError = "Please select an option!");
      } else {
        setState(() => _dropdownError = "");
        _showProgress('Adding Sub Category...');
        subCatServices.addSubCategories(subCategoryName.text, valueChoose.toString()).then((result) {
          if('success' == result){
            _getSubCategories();
            _clearValues();
            _successSnackbar(context, "Successfully added.");
          } else if('exist' == result){
            _errorSnackbar(context, "Sub Category name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  _editSubCategories(subCategories subcategory){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      if (valueChoose == null) {
        setState(() => _dropdownError = "Please select an option!");
      } else {
        _showProgress('Updating Category...');
        subCatServices.editSubCategories(
            subcategory.id, subCategoryName.text, valueChoose.toString()).then((
            result) {
          if ('success' == result) {
            _getCategories();
            _getSubCategories(); //refresh the list after update
            setState(() {
              _isUpdating = false;
            });
            _successSnackbar(context, "Edited Successfully");
            _clearValues();
          } else if ('exist' == result) {
            _errorSnackbar(context, "Sub Category name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  //delete data by getting classes in services.dart
  _delSubCategories(subCategories subcategory){
    _showProgress('Deleting Category...');
    subCatServices.deleteSubCategories(subcategory.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");
        _getSubCategories();
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //emptying textfields
  _clearValues(){
    subCategoryName.text = '';
  }

  //show data to textfield when datatable is clicked
  _showValues(subCategories subcategory){
    subCategoryName.text = subcategory.name;
    valueChoose = subcategory.category_id;
    _getCategories();
  }

  String? valueChoose;
  String? _dropdownError;
  //category list
  DropdownButton _categoryList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChoose,
      onChanged: (value) {
        setState(() {
          valueChoose = value;
        });
      },
      hint: Text("Select Category"),
      items: _categories.map((categories) => DropdownMenuItem(
        value: categories.id.toString(),
        child: Text(categories.name.toString()),
      )).toList(),
    );
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
            DataColumn(label: Text('Sub Category Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Category Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _subcategories.map((subCategories) => DataRow(cells: [
            DataCell(Text(subCategories.id.toString()),
                onTap: (){
                  _showValues(subCategories);
                  _selectedSubCategory = subCategories;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(subCategories.name.toString()),
                onTap: (){
                  _showValues(subCategories);
                  _selectedSubCategory = subCategories; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(_categories.where((categories) => categories.id.toString() == subCategories.category_id.toString()).elementAt(0).name),
                onTap: (){
                  _showValues(subCategories);
                  _selectedSubCategory = subCategories; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delSubCategories(subCategories);
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
                _getSubCategories();
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
                NormalTextField(controller: subCategoryName, hintText: "Sub Category Name"),

                const SizedBox(height: 10,),
                _categoryList(),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Text(
                  _dropdownError ?? "",
                  style: TextStyle(color: Colors.red),
                ),

                const SizedBox(height: 5,),
                _isUpdating ?
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        _editSubCategories(_selectedSubCategory);
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
          _addSubCategories();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

