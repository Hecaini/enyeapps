import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class CatalogsFilePage extends StatefulWidget {
  CatalogsFilePage() : super();

  static const String routeName = '/catalogsfile';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogsFilePage()
    );
  }

  final String title = 'Catalogs File';

  @override
  _CatalogsFilePageState createState() => _CatalogsFilePageState();
}

class _CatalogsFilePageState extends State<CatalogsFilePage> {
  late List<CatalogsFile> _catalogsFile;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController catalogsFileName;
  late CatalogsFile _selectedCatalogsFile;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  File? filepath;
  String? filename;
  String? filedata;
  String? showfile;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      if(result != null){
        /*imagepath = File(getimage!.path);
        imagename = getimage.path.split('/').last;
        imagedata = base64Encode(imagepath!.readAsBytesSync());
        print(imagepath);*/
      }
    });
  }

  @override
  void initState(){
    super.initState();
    _catalogsFile = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    catalogsFileName = TextEditingController();
    _getCatalogsFile();
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

  _getCatalogsFile(){
    _showProgress('Loading Catalogs File...');
    catalogsFileSvc.getFileCatalogs().then((catalogsFile){
      setState(() {
        _catalogsFile = catalogsFile;
      });
      _showProgress(widget.title);
      print("Length ${catalogsFile.length}");
    });
  }

  /*_addCategories(){
    if (_formKey.currentState!.validate()) {
      _showProgress('Adding Category...');
      categoriesServices.addCategories(categoryName.text).then((result) {
        if('success' == result){
          _clearValues();
          _successSnackbar(context, "Successfully added.");
        } else if('exist' == result){
          _errorSnackbar(context, "Category name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }
      });
    }
  }*/

  /*_editCategories(Categories category){
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
  }*/

  //delete data by getting classes in services.dart
  /*_delCategories(Categories category){
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
  }*/

  //emptying textfields
  _clearValues(){
    catalogsFileName.text = '';
    _getCatalogsFile();
  }

  //show data to textfield when datatable is clicked
  _showValues(CatalogsFile catalogsFile){
    catalogsFileName.text = catalogsFile.name;
  }

  //data table select all
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('FILE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _catalogsFile.map((CatalogsFile) => DataRow(cells: [
            DataCell(Text(CatalogsFile.name.toString()),
                onTap: (){
                  _showValues(CatalogsFile);
                  _selectedCatalogsFile = CatalogsFile;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(CatalogsFile.filename.toString()),
                onTap: (){
                  _showValues(CatalogsFile);
                  _selectedCatalogsFile = CatalogsFile; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                //_delCategories(CatalogsFile);
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
                _getCatalogsFile();
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
                NormalTextField(controller: catalogsFileName, hintText: "Catalogs File Name"),

                /*InkWell(
                  onTap: selectImage,
                  child: Stack(
                    children: [
                      imagepath != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(imagepath!),
                      ) : _isUpdating
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(API.hostConnect + showimage!),
                      )
                          : CircleAvatar(
                        radius: 64,
                        foregroundColor: Colors.deepOrange,
                        child: Icon(Icons.photo, color: Colors.deepOrange, size: 50,),
                      ),

                      Positioned(child: Icon(Icons.add_a_photo, color: Colors.deepOrange,), bottom: 2, left: 90,),
                    ],
                  ),
                ),*/

                const SizedBox(height: 20,),
                _isUpdating ?
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        //_editCategories(_selectedCategory);
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
          //_addCategories();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

