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
  //text editing controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final positionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = false;

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

      } else {
        //useradmin.dart transfering to json
        userAdmin userAdminModel = userAdmin(
          name: nameController.text.trim(),
          contact: contactController.text.trim(),
          position: positionController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
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

                  //position textfield
                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: positionController,
                    hintText: 'Position',
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

                  //or continue with
                  /*const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade500,)
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with', style: TextStyle(color: Colors.grey.shade800,),),
                        ),
                        Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade500,)
                        ),
                      ],
                    ),
                  ),*/

                  //gmail + facebook sign in
                  /*const SizedBox(height: 25,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                      SizedBox(width: 25,),
                      Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                    ],
                  ),*/

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
