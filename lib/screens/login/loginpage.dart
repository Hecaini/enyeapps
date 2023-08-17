import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LoginPage()
    );
  }

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool disabling = false;
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //close the keyboard if nakalabas
  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  Future<void> signUserIn() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      dynamic token = await SessionManager().get("token");

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

          var userData = resBodyOfLogin["user_data"];
          await SessionManager().set("user_data",  UserLogin(
              user_id: userData["user_id"],
              name: userData["name"],
              username: userData["username"],
              email: userData["email"],
              position: userData["position"],
              image: userData["image"]
          ));

          TokenServices.updateToken(token.toString(), userData["user_id"]).then((result) {
            if('success' == result){
              print("Updated token successfully");
            } else {
              print("Error updating token");
            }
          });

          setState(() {
            disabling = true;
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
                    Text("Congratulations, Login Successfully."),
                  ],
                ),
              ),
            ).closed.then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CheckSession())));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
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
                  const SizedBox(height: 50,),
                  const Image(image: AssetImage("assets/logo/enyelogo.png")),

                  //email textfield
                  const SizedBox(height: 25,),
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

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    onTap: (){
                      if (disabling == false) {
                        signUserIn();
                      }
                      _onButtonPressed();
                    },
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            settings: const RouteSettings(name: registerPage.routeName,),
                            screen: registerPage(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: const Text(
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
