import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/account';

  const AccountPage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const AccountPage()
    );
  }

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //text editing controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final positionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = true;

  bool _isUpdating = false;

  File? imagepath;
  String? imagename;
  String? imagedata;
  String? showimage;
  ImagePicker imagePicker = ImagePicker();

  UserLogin? userInfo; //users session
  bool? userSessionFuture;

  void initState(){
    super.initState();

    //calling session data
    CheckSessionData().getUserSessionStatus().then((bool) {
      if (bool == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
            _showValues(userInfo!);
          });
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }

  Future<void> selectImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
    });
  }

  _showValues(UserLogin user){
    showimage = user.image;
    nameController.text = user.name;
    contactController.text = user.contact;
    emailController.text = user.email;
    positionController.text = user.position;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: const CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
        body: Center(
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        if(disabling != true){
                          selectImage();
                        }
                      },
                      child: Stack(
                        children: [
                          imagepath != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: FileImage(imagepath!),
                            )
                          : showimage != null && showimage != ""
                            ? CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(API.usersImages + showimage!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                foregroundColor: Colors.deepOrange,
                                child: Icon(Icons.photo, color: Colors.deepOrange, size: 50,),
                              ),

                          disabling == false
                            ? const Positioned(bottom: 2, left: 90,child: Icon(Icons.add_a_photo, color: Colors.deepOrange,),)
                            : const SizedBox.shrink(),
                        ],
                      ),
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

                    //email textfield
                    const SizedBox(height: 10,),
                    EmailTextField(
                      controller: emailController,
                      hintText: 'Email',
                      disabling: disabling,
                    ),

                    //position textfield
                    const SizedBox(height: 10,),
                    NormalTextField(
                      controller: positionController,
                      hintText: 'Position',
                      disabling: disabling,
                    ),
                  ],
                ),
              ),

              //edit cancel save
              _isUpdating == false
                ? GestureDetector(
                    onTap: (){
                      setState(() {
                        _isUpdating = true;
                        disabling = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.yellow.shade700,
                            child: Icon(Icons.edit, color: Colors.yellowAccent, size: 21,),
                          ),
                        ],
                      ),
                    )
                  )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.save, color: Colors.greenAccent, size: 21,),
                            ),
                          ),

                          SizedBox(width: 15,),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                _isUpdating = false;
                                disabling = true;
                                imagepath = null;
                                _showValues(userInfo!);
                              });
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.red.shade600,
                              child: Icon(Icons.close, color: Colors.white, size: 21,),
                            ),
                          ),
                        ],
                      ),
                    ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      const Icon(Icons.settings, size: 24,),

                      const SizedBox(width: 25,),
                      Text("Other Features", style: GoogleFonts.lato(fontSize: 16, letterSpacing: 0.8),),
                    ],
                  ),
                  children: [

                    //department button
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DepartmentPage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.deepOrange.shade100, Colors.deepOrange.withOpacity(0.1)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25,),
                            Icon(
                              Icons.label_important_outlined,
                              size: 15,
                              color: Colors.deepOrange.shade400,
                            ),
                            const SizedBox(width: 10,),
                            Flexible(
                              child: Text(
                                "Department",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Positions button
                    InkWell(
                      onTap: (){

                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.deepOrange.shade100, Colors.deepOrange.withOpacity(0.1)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25,),
                            Icon(
                              Icons.label_important_outlined,
                              size: 15,
                              color: Colors.deepOrange.shade400,
                            ),
                            const SizedBox(width: 10,),
                            Flexible(
                              child: Text(
                                "Positions",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Users Information button
                    InkWell(
                      onTap: (){

                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.deepOrange.shade100, Colors.deepOrange.withOpacity(0.1)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25,),
                            Icon(
                              Icons.label_important_outlined,
                              size: 15,
                              color: Colors.deepOrange.shade400,
                            ),
                            const SizedBox(width: 10,),
                            Flexible(
                              child: Text(
                                "Users Information",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25.0),
              //logout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    dynamic token = await SessionManager().get("token");
                    await SessionManager().remove("user_data");

                    //clear the client_id in a token
                    TokenServices.updateToken(token.toString(), "").then((result) {
                      if('success' == result){
                        print("Updated token successfully");
                      } else {
                        print("Error updating token");
                      }
                    });

                    setState(() {
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LoginPage();
                          },
                        ),
                            (_) => false,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 24.0,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

