import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../widget/widgets.dart';
import '../../../screens.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  static const String routeName = '/department';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const DepartmentPage()
    );
  }

  final String title = 'Department';

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> with TickerProviderStateMixin{
  late List<Department> _department;
  late Department _selectedDept;

  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController deptName;
  late TextEditingController deptShName;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _department = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    deptName = TextEditingController();
    deptShName = TextEditingController();
    _getDepartments();
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
    deptName.clear();
    deptShName.clear();
  }

  //show data to textfield when datatable is clicked
  _showValues(Department department){
    deptName.text = department.deptName;
    deptShName.text = department.deptShname;
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

  _addDepartment(){
    if (_formKey.currentState!.validate()) {
      _showProgress('Adding Department...');
      DepartmentServices.addDepartment(deptName.text, deptShName.text).then((result) {
        if('success' == result){
          _getDepartments();
          _clearValues();
          _successSnackbar(context, "Successfully added.");
        } else if('exist' == result){
          _errorSnackbar(context, "Department EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }
      });
    }
  }

  _editDepartment(Department department){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      _showProgress('Updating Department...');
      DepartmentServices.editDepartment(department.id, deptName.text, deptShName.text).then((result) {
        if('success' == result){
          _getDepartments(); //refresh the list after update
          setState(() {
            _isUpdating = false;
          });
          _successSnackbar(context, "Edited Successfully");
          _clearValues();
        }  else if('exist' == result){
          _errorSnackbar(context, "Department EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }

      });
    }
  }

  //delete data by getting classes in services.dart
  _delDepartment(Department department){
    _showProgress('Deleting Department...');
    DepartmentServices.deleteDepartment(department.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");
        _getDepartments();
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
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Short Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _department.map((department) => DataRow(cells: [
            DataCell(Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
              child: Text(department.deptName.toString(),maxLines: 2,
                overflow: TextOverflow.ellipsis,),
            ),
                onTap: (){
                  _showValues(department);
                  _selectedDept = department; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(department.deptShname.toString()),
                onTap: (){
                  _showValues(department);
                  _selectedDept = department; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: const Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'Are you sure you want to DELETE \n ${department.deptName} ?',
                  confirmBtnText: 'Yes',
                  onConfirmBtnTap: (){
                    _delDepartment(department);
                  },
                  cancelBtnText: 'No',
                  onCancelBtnTap: () => Navigator.pop(context),
                  confirmBtnColor: Colors.red,
                );
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
        :SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20,),
                NormalTextField(controller: deptName, hintText: "Department Name", disabling: false,),

                const SizedBox(height: 5,),
                NormalTextField(controller: deptShName, hintText: "Short Name", disabling: false,),

                const SizedBox(height: 20,),
                _isUpdating ?
                Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        _closeKeyboard(context);
                        _editDepartment(_selectedDept);
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
                  child: _department.isEmpty
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
          _closeKeyboard(context);
          _addDepartment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

