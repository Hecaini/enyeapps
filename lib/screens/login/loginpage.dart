import 'package:enye_app/screens/login/registerpage.dart';
import 'package:enye_app/widget/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

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

  void signUserIn(){
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
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
                  SizedBox(height: 25,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                      SizedBox(width: 25,),
                      Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                    ],
                  ),

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
