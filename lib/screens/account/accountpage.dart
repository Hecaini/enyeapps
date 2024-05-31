import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
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

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {
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

  String? showimage;

  String? selSysProd;
  String? selSvcBy;
  bool _isLoading = true;
  String imageName = '';
  String imageData = '';

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

  _showValues(UserLogin user){
    imageName = user.signature;
    showimage = user.image;
    nameController.text = user.name;
    contactController.text = user.contact;
    emailController.text = user.email;
    positionController.text = user.position;
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? exportedImage;

  processImage(Uint8List? exportedImage) {
    if (exportedImage != null) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      imageName = "IMG_$formattedDate.png"; // Image name with date-time
      imageData = base64Encode(exportedImage);
      print('File name: $imageName');
      print('Base64 data: $imageData');
    } else {
      imageName = ""; // Image name with date-time
      imageData = "";
      print("Failed to capture image");
      print('File name: $imageName');
      print('Base64 data: $imageData');
    }
  }

  void _showSignatureDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Signature Pad",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: fontExtraSize,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Signature(
                controller: controller,
                width: screenWidth * 0.65,
                height: screenHeight * 0.25,
                backgroundColor: Colors.lightBlue[100]!,
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      exportedImage = await controller.toPngBytes();
                      processImage(exportedImage);
                      controller.clear();
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    child: Text(
                      "SAVE",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: fontExtraSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.05,),

                  ElevatedButton(
                    onPressed: () {
                      controller.clear();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: Text(
                      "CLEAR",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: fontExtraSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              child: Text(
                "CLOSE",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: fontExtraSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

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
                    SizedBox(height: screenHeight * 0.02,),
                    showimage != null && showimage != ""
                    ? CircleAvatar(
                      radius: fontNormalSize * 4,
                      backgroundImage: NetworkImage(
                        API.ec_usersImg + showimage!
                      ),
                    )
                    : CircleAvatar(
                      radius: fontNormalSize * 4,
                      foregroundColor: Colors.deepOrange,
                      child: Icon(Icons.person, color: Colors.deepOrange, size: fontNormalSize * 3.5,),
                    ),

                    //fullname textfield
                    SizedBox(height: screenHeight * 0.03,),
                    PersonNameTextField(
                      controller: nameController,
                      hintText: 'Fullname',
                      disabling: true,
                    ),

                    //contact textfield
                    SizedBox(height: screenHeight * 0.015,),
                    ContactTextField(
                      controller: contactController,
                      hintText: 'Contact No (11-digit no.)',
                      disabling: disabling,
                    ),

                    //email textfield
                    SizedBox(height: screenHeight * 0.015,),
                    EmailTextField(
                      controller: emailController,
                      hintText: 'Email',
                      disabling: true,
                    ),

                    //position textfield
                    SizedBox(height: screenHeight * 0.015,),
                    NormalTextField(
                      controller: positionController,
                      hintText: 'Position',
                      disabling: true,
                    ),
                  ],
                ),
              ),

              if (_isUpdating == false)
                SizedBox.shrink()
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.015,),
                      if (exportedImage != null)
                        InkWell(
                          onTap: () => _showSignatureDialog(context),
                          child: Container(
                            padding: EdgeInsets.all(fontNormalSize * 1.5),
                            width: screenWidth * 0.83,
                            height: screenHeight * 0.15,
                            color: Colors.white,
                            child: Image.memory(
                              exportedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      else if (userInfo!.signature.isNotEmpty || userInfo!.signature != "" || userInfo!.signature != null)
                          InkWell(
                            onTap: () => _showSignatureDialog(context),
                            child: Container(
                              padding: EdgeInsets.all(fontNormalSize * 1.5),
                              width: screenWidth * 0.83,
                              height: screenHeight * 0.15,
                              color: Colors.white,
                              child: Image.network(
                                API.ec_usersSig + userInfo!.signature,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: () => _showSignatureDialog(context),
                            child: Container(
                              width: screenWidth * 0.83,
                              height: screenHeight * 0.13,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Text(
                                  "No Signature Captured.\nTap to sign",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                            onTap: (){

                            },
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

              //Other features disabled status EMPLOYEE
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              userInfo?.status == "Employee"
               ? const SizedBox.shrink()
               : Card(
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

                    //department button for ADMIN Only
                    userInfo?.status == "Admin"
                     ? InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const DepartmentPage();
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
                    )
                     : const SizedBox.shrink(),

                    //Positions button
                    userInfo?.status == "Admin"
                     ? InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const PositionPage();
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
                    )
                     : const SizedBox.shrink(),

                    //Users Information button
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const UsersPage();
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

