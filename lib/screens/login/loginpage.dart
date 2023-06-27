import 'package:enye_app/screens/login/registerpage.dart';
import 'package:enye_app/widget/mybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/widgets.dart';

class loginPage extends StatelessWidget {
  loginPage({super.key});

  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade300,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo application
              SizedBox(height: 50,),
              Image(image: AssetImage("assets/logo/enyelogo.png")),

              //email textfield
              SizedBox(height: 25,),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              //password textfield
              SizedBox(height: 10,),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
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
    );
  }
}
