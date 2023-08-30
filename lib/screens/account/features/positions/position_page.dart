import 'package:flutter/material.dart';

import '../../../../widget/widgets.dart';
import '../../../screens.dart';

class PositionPage extends StatefulWidget {
  const PositionPage({super.key});

  static const String routeName = '/position';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const PositionPage()
    );
  }

  final String title = 'Positions';

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> with TickerProviderStateMixin{
  late List<Department> _department;
  late List<Position> _position;
  late Position _selectedPosition;

  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController positionName;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _department = [];
    _position = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    positionName = TextEditingController();
    _getDepartments();
    _getPositions();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.check, color: Colors.white,),
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
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  //emptying textfields
  _clearValues(){
    positionName.clear();
    valueChooseDept = null;
  }

  //show data to textfield when datatable is clicked
  _showValues(Position position){
    positionName.text = position.position;
    valueChooseDept = position.departmentId;
  }

  String? valueChooseDept;
  String? _dropdownError;
  //department list
  DropdownButton _deptList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChooseDept,
      onChanged: (value) {
        setState(() {
          valueChooseDept = value;
        });
      },
      hint: Text("Select Department *"),
      items: _department.map((department) => DropdownMenuItem(
        value: department.id.toString(),
        child: Text(department.deptShname.toString()),
      )).toList(),
    );
  }

  _getDepartments() async {
    _showProgress('Loading Departments...');
    await Future.delayed(Duration(seconds: 3)); // Simulating API call
    DepartmentServices.getDepartments().then((department){
      setState(() {
        _department = department;
      });
      _isLoading = false;
      _showProgress(widget.title);
    });
  }

  _getPositions() async {
    _showProgress('Loading Positions...');
    await Future.delayed(Duration(seconds: 3)); // Simulating API call
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
      _isLoading = false;
      _showProgress(widget.title);
    });
  }

  _addDepartment(){
    if (_formKey.currentState!.validate()) {
      if (valueChooseDept == null) {
        setState(() => _dropdownError = "Please select an option!");
      } else {
        _showProgress('Adding Position...');
        PositionServices.addPosition(positionName.text, valueChooseDept.toString()).then((result) {
          if('success' == result){
            _getPositions();
            _clearValues();
            _successSnackbar(context, "Successfully added.");
          } else if('exist' == result){
            _errorSnackbar(context, "Position EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  _editDepartment(Position position){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      _showProgress('Updating Position...');
      PositionServices.editPosition(position.id, positionName.text, valueChooseDept.toString()).then((result) {
        if('success' == result){
          _getPositions(); //refresh the list after update
          setState(() {
            _isUpdating = false;
          });
          _successSnackbar(context, "Edited Successfully");
          _clearValues();
        }  else if('exist' == result){
          _errorSnackbar(context, "Position EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }

      });
    }
  }

  //delete data by getting classes in services.dart
  _delDepartment(Position position){
    _showProgress('Deleting Position...');
    PositionServices.deletePosition(position.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");
        _getPositions();
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //data table select all
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Positions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _position.map((positions) => DataRow(cells: [
            DataCell(Text(positions.position.toString(),maxLines: 2,
              overflow: TextOverflow.ellipsis,),
                onTap: (){
                  _showValues(positions);
                  _selectedPosition = positions; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(
                Text(_department.where((department) => department.id.toString() == positions.departmentId.toString()).elementAtOrNull(0)!.deptShname.toString()),
                onTap: (){
                  _showValues(positions);
                  _selectedPosition = positions; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: const Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delDepartment(positions);
              },
            )),
          ])).toList(),
        ),
      ),
    );
  }

  void _closeKeyboard(BuildContext context) {
    // Unfocus any active focus nodes (close the keyboard)
    FocusManager.instance.primaryFocus?.unfocus();
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
                _getDepartments();
              },
              icon: const Icon(Icons.refresh)
          ),
        ],
      ),
      body: _isLoading
        ? Center(child: SpinningContainer(controller: _controller),)
        : SafeArea(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 20,),
              NormalTextField(controller: positionName, hintText: "Department Name", disabling: false,),

              const SizedBox(height: 5,),
              _deptList(),
              _dropdownError == null
                  ? SizedBox.shrink()
                  : Text(
                _dropdownError ?? "",
                style: TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 20,),
              _isUpdating ?
              Row(
                children: <Widget>[
                  const SizedBox(width: 20,),
                  editButton(
                    onTap: () {
                      _closeKeyboard(context);
                      _editDepartment(_selectedPosition);
                    },
                    text: 'UPDATE',
                  ),

                  delButton(
                    onTap: () {
                      setState(() {
                        _isUpdating = false;
                      });
                      _closeKeyboard(context);
                      _clearValues();
                    },
                    text: 'CANCEL',
                  ),
                ],
              )
                  : Container(),

              const SizedBox(height: 20,),
              Expanded(
                child: _position.isEmpty
                    ? const Center(
                  child: (Text(
                    "No Data Available",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey
                    ),
                  )),
                )
                    : _dataBody(),
              ),
            ],
          ),
        ),
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_isUpdating == false){
            _closeKeyboard(context);
            _addDepartment();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

