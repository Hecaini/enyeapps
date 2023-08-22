import 'dart:convert';

import 'package:enye_app/config/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class registerPage extends StatefulWidget {
  static const String routeName = '/register';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => registerPage()
    );
  }

  registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();

}

class _registerPageState extends State<registerPage> {

  late List<Department> _department;
  late List<Position> _position;

  void initState(){
    super.initState();
    _getDepartments();
    _department = [];
    _position = [];
  }

  //text editing controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = false;

  String? valueDept;
  String? valuePosition;
  String? _dropdownError; //kapag wala pa na-select sa option

  _getDepartments(){
    DepartmentServices.getDepartments().then((department){
      setState(() {
        _department = department;
      });
    });
  }

  _getPositions(String department){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions.where((element) => element.departmentId == department).toList();
      });
    });
  }

  //close the keyboard if nakalabas
  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  Future<void> signUserUp() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      //password doesn't match with confirmation password
      if (passwordController.text.trim() != conpasswordController.text.trim()){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
            content: Row(
              children: [
                Icon(Icons.close, color: Colors.white,),
                const SizedBox(width: 10,),
                Text("Password doesn't match !"),
              ],
            ),
          ),
        );

      } else if (valueDept == null || valuePosition == null){
        setState(() => _dropdownError = "Please select an option!");
      } else {
        setState(() => _dropdownError = null);
        //useradmin.dart transfering to json
        userAdmin userAdminModel = userAdmin(
          name: nameController.text.trim(),
          contact: contactController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          department: valueDept.toString(),
          position: valuePosition.toString(),
        );

        try {
          var res = await http.post( //pasiing value to result
            Uri.parse(API.signUpAdmin),
            body: userAdminModel.toJson(),
          );

          if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
            var resBodyOfSignUp = jsonDecode(res.body);

            //if email is already taken
            if(resBodyOfSignUp['email_taken'] == true){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.orangeAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                  content: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange,),
                      const SizedBox(width: 10,),
                      Text("Warning: Email is already taken."),
                    ],
                  ),
                ),
              );
              _formKey.currentState?.reset();

            } else if(resBodyOfSignUp['user_add'] == true){ //registration success
              setState(() {
                disabling = true;
              });
              _formKey.currentState?.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                  content: Row(
                    children: [
                      Icon(Icons.check, color: Colors.greenAccent,),
                      const SizedBox(width: 10,),
                      Text("Congratulations, SignUp Successfully."),
                    ],
                  ),
                ),
              ).closed.then((value) => Navigator.of(context).pop());
            } else {
              ScaffoldMessenger.of(context).showSnackBar( //registration failed
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                  content: Row(
                    children: [
                      Icon(Icons.close, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("Error occured!"),
                    ],
                  ),
                ),
              );
            }
          }

        } catch(e) {
          print(e.toString());
          Fluttertoast.showToast(msg: e.toString());
        }
      }

    }
  }

  //dropdown position list after department
  _positionList(String department){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade50,
        border: Border.all(width: 2, color: Colors.deepOrange.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        alignment: Alignment.bottomCenter,
        underline:Container(),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
        isDense: true,
        iconSize: 36,
        iconEnabledColor: Colors.deepOrange,
        isExpanded: true,
        value: valuePosition,
        onChanged: (value){
          setState(() {
            valuePosition = value;
          });
        },
        hint: const Text("Select Position *"),
        items: _position.map((positsion) => DropdownMenuItem(
          alignment: Alignment.bottomCenter,
          value: positsion.id.toString(),
          child: Text(positsion.position, textAlign: TextAlign.center,),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //logo application
                  const SizedBox(height: 20,),
                  const Image(image: AssetImage("assets/logo/enyelogo.png")),

                  //lets create an account for you
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Let's create an account for you!", style: TextStyle(color: Colors.grey.shade800, fontSize: 18),),
                  ),

                  //fullname textfield
                  const SizedBox(height: 25,),
                  PersonNameTextField(
                    controller: nameController,
                    hintText: 'Fullname',
                    disabling: disabling,
                  ),

                  //contact textfield
                  const SizedBox(height: 10,),
                  ContactTextField(
                    controller: contactController,
                    hintText: 'Contact No (11-digit no.)',
                    disabling: disabling,
                  ),

                  //department
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.5),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade50,
                      border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      alignment: Alignment.bottomCenter,
                      underline:Container(),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      isDense: true,
                      iconSize: 36,
                      iconEnabledColor: Colors.deepOrange,
                      isExpanded: true,
                      value: valueDept,
                      onChanged: (value){
                        setState(() {
                          _getPositions(value!);
                          valueDept = value;
                        });
                      },
                      hint: const Text("Select Department *"),
                      items: _department.map((department) => DropdownMenuItem(
                        alignment: Alignment.bottomCenter,
                        value: department.id.toString(),
                        child: Text(department.deptShname, textAlign: TextAlign.center,),
                      )).toList(),
                    ),
                  ),

                  //position
                  const SizedBox(height: 10,),
                  valueDept != null
                   ? _positionList(valueDept.toString())
                   : const SizedBox.shrink(),

                  _dropdownError == null
                      ? const SizedBox.shrink()
                      : Center(
                    child: Text(
                      _dropdownError ?? "",
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ),

                  //email textfield
                  const SizedBox(height: 10,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                    disabling: disabling,
                  ),

                  //password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    disabling: disabling,
                  ),

                  //confirm password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: conpasswordController,
                    hintText: 'Confirm Password',
                    disabling: disabling,
                  ),

                  //sign-up button
                  const SizedBox(height: 25,),
                  MyButton(
                    text: "Sign Up",
                    onTap: (){
                      if (disabling == false) {
                        signUserUp();
                      }
                      _onButtonPressed();
                    },
                  ),

                  //already have an account
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: TextStyle(color: Colors.grey.shade800),),
                      const SizedBox(height: 4,),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Login now',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
