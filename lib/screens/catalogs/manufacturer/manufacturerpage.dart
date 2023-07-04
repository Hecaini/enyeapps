import 'package:flutter/material.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class ManufacturersPage extends StatefulWidget {
  ManufacturersPage() : super();

  static const String routeName = '/manufacturer';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ManufacturersPage()
    );
  }

  final String title = 'Manufacturer';

  @override
  _ManufacturersPageState createState() => _ManufacturersPageState();
}

class _ManufacturersPageState extends State<ManufacturersPage> {
  late List<Manufacturer> _manufacturer;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController mfrName;
  late Manufacturer _selectedMfr;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _manufacturer = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    mfrName = TextEditingController();
    _getMfr();
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

  _getMfr(){
    _showProgress('Loading Manufacturers...');
    mfrServices.getManufacturer().then((mfr){
      setState(() {
        _manufacturer = mfr;
      });
      _showProgress(widget.title);
      print("Length ${mfr.length}");
    });
  }

  _addMfr(){
    if (_formKey.currentState!.validate()) {
      _showProgress('Adding Manufacturer...');
      mfrServices.addManufacturer(mfrName.text).then((result) {
        if('success' == result){
          _getMfr();
          _clearValues();
          _successSnackbar(context, "Successfully added.");
        } else if('exist' == result){
          _errorSnackbar(context, "Manufacturer Name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }
      });
    }
  }

  _editMfr(Manufacturer manufacturer){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      _showProgress('Updating Manufacturer...');
      mfrServices.editManufacturer(manufacturer.id, mfrName.text).then((result) {
        if('success' == result){
          _getMfr(); //refresh the list after update
          setState(() {
            _isUpdating = false;
          });
          _successSnackbar(context, "Edited Successfully");
          _clearValues();
        }  else if('exist' == result){
          _errorSnackbar(context, "Manufacturer Name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }

      });
    }
  }

  //delete data by getting classes in services.dart
  _delMfr(Manufacturer manufacturer){
    _showProgress('Deleting Manufacturer...');
    mfrServices.deleteManufacturer(manufacturer.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");
        _getMfr();
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //emptying textfields
  _clearValues(){
    mfrName.text = '';
  }

  //show data to textfield when datatable is clicked
  _showValues(Manufacturer manufacturer){
    mfrName.text = manufacturer.name;
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
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _manufacturer.map((manufacturer) => DataRow(cells: [
            DataCell(Text(manufacturer.id.toString()),
                onTap: (){
                  _showValues(manufacturer);
                  _selectedMfr = manufacturer;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(manufacturer.name.toString()),
                onTap: (){
                  _showValues(manufacturer);
                  _selectedMfr = manufacturer; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delMfr(manufacturer);
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
                _getMfr();
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
                NormalTextField(controller: mfrName, hintText: "Manufacturer Name"),

                const SizedBox(height: 20,),
                _isUpdating ?
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        _editMfr(_selectedMfr);
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
          _addMfr();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

