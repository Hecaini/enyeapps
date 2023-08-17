import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
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

  late bool _isUpdating = false;

  File? imagepath;
  String? imagename;
  String? imagedata;
  String? showimage;
  ImagePicker imagePicker = new ImagePicker();

  Future<void> selectImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
    });
  }

  //kapag wala pa na-select sa option
  String? _dropdownError;

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CustomAppBar(title: 'Account', imagePath: 'assets/logo/enyecontrols.png',),
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
                      onTap: selectImage,
                      child: Stack(
                        children: [
                          imagepath != null
                              ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(imagepath!),
                          ) : _isUpdating
                              ? CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(API.productImages + showimage!),
                          )
                              : CircleAvatar(
                            radius: 64,
                            foregroundColor: Colors.deepOrange,
                            child: Icon(Icons.photo, color: Colors.deepOrange, size: 50,),
                          ),

                          Positioned(child: Icon(Icons.add_a_photo, color: Colors.deepOrange,), bottom: 2, left: 90,),
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

                    //position textfield
                    const SizedBox(height: 10,),
                    NormalTextField(
                      controller: positionController,
                      hintText: 'Position',
                      disabling: disabling,
                    ),

                    //email textfield
                    const SizedBox(height: 10,),
                    EmailTextField(
                      controller: emailController,
                      hintText: 'Email',
                      disabling: disabling,
                    ),
                  ],
                ),
              ),

              //logout button
              ElevatedButton.icon(
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
                          return LoginPage();
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
            ],
          ),
        ),
    );
  }
}

