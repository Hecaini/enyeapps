import 'dart:convert';

import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> signUserIn() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      try {
        var res = await http.post( //pasiing value to result
          Uri.parse(API.loginAdmin),
          body: {
            'email' : emailController.text.trim(),
            'password' : passwordController.text.trim(),
          },
        );

        if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
          var resBodyOfLogin = jsonDecode(res.body);

          if(resBodyOfLogin['login'] == true){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.greenAccent,),
                    const SizedBox(width: 10,),
                    Text("Congratulations, Login Successfully."),
                  ],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.close, color: Colors.white,),
                    const SizedBox(width: 10,),
                    Text("Incorrect email or password !"),
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
                  SizedBox(height: 50,),
                  Image(image: AssetImage("assets/logo/enyelogo.png")),

                  //email textfield
                  SizedBox(height: 25,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),

                  //password textfield
                  SizedBox(height: 10,),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                  ),

                  //forgot password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){},
                          child: Text('Forgot Password?', style: TextStyle(color: Colors.grey.shade800,),),
                        ),
                      ],
                    ),
                  ),

                  //sign-in button
                  MyButton(
                    text: "Sign In",
                    onTap: signUserIn,
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
                  /*SizedBox(height: 25,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                      SizedBox(width: 25,),
                      Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                    ],
                  ),*/

                  //not a member sign up
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?', style: TextStyle(color: Colors.grey.shade800),),
                      const SizedBox(height: 4,),
                      TextButton(
                        onPressed: (){
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: registerPage.routeName,),
                            screen: registerPage(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'Register now',
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
