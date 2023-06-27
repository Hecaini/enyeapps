import 'package:enye_app/widget/mybutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class registerPage extends StatelessWidget {
  static const String routeName = '/register';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => registerPage()
    );
  }

  registerPage({super.key});

  //text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  void signUserUp(){}

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
              MyTextField(
                controller: nameController,
                hintText: 'Fullname',
                obscureText: false,
              ),

              //email textfield
              const SizedBox(height: 10,),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              //password textfield
              const SizedBox(height: 10,),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //confirm password textfield
              const SizedBox(height: 10,),
              MyTextField(
                controller: conpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
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
    );
  }
}
