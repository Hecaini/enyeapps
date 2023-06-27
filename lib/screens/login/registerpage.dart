import 'dart:convert';

import 'package:enye_app/config/api_connection.dart';
import 'package:enye_app/screens/login/useradmin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:enye_app/widget/mybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

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

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  Future<void> signUserUp() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      userAdmin userAdminModel = userAdmin(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
      );
      try {
        var res = await http.post( //pasiing value to result
          Uri.parse(API.signUpAdmin),
          body: userAdminModel.toJson(),
        );

        if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
          var resBodyOfSignUp = jsonDecode(res.body);
          if(resBodyOfSignUp['email_taken'] == true){
            Fluttertoast.showToast(
              msg: "Email is already taken.",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red.shade100,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else if(resBodyOfSignUp['user_add'] == true){
            successToast();
            Fluttertoast.showToast(msg: "Congratulations, SignUp Successfully.");
          } else {
            Fluttertoast.showToast(msg: "Error Occured.");
          }
        }

      } catch(e) {

      }

      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
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
                  ),

                  //email textfield
                  const SizedBox(height: 10,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),

                  //password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                  ),

                  //confirm password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: conpasswordController,
                    hintText: 'Confirm Password',
                  ),

                  //sign-up button
                  const SizedBox(height: 25,),
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                  ),

                  //or continue with
                  const SizedBox(height: 30,),
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
                  ),

                  //gmail + facebook sign in
                  const SizedBox(height: 25,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                      SizedBox(width: 25,),
                      Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                    ],
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
                          Navigator.of(context).popUntil(ModalRoute.withName("/"));
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
