import 'package:enye_app/widget/mybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      child: Text('Forgot Password?', style: TextStyle(color: Colors.black,),),
                    ),
                  ],
                ),
              ),

              //sign-in button
              MyButton(
                onTap: signUserIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
