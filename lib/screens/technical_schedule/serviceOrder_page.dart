import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class ServiceOrderPage extends StatefulWidget {
  final TechnicalData services;
  final String selectedDay;

  const ServiceOrderPage({
    super.key,
    required this.services,
    required this.selectedDay,
  });

  @override
  State<ServiceOrderPage> createState() => _ServiceOrderPageState();
}

class _ServiceOrderPageState extends State<ServiceOrderPage> with TickerProviderStateMixin {
  bool disabling = false;
  String? selSysProd;
  String? selSvcBy;
  bool _isLoading = true;
  String imageName = '';
  String imageData = '';

  final txtTimeIn = TextEditingController();
  final txtTimeOut = TextEditingController();
  final txtSysProduct = TextEditingController();
  final txtLocation = TextEditingController();
  final txtComplaint = TextEditingController();
  final txtStatus = TextEditingController();
  final txtRemarks = TextEditingController();
  final txtConforme = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getPositions();
    _getAccounts();
    _getSONumber();
  }

  var items = [
    'Fully Operational',
    'For Further Testing',
    'Parts need to be Replaced'
  ];

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: (screenHeight + screenWidth) / 75,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Expanded(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(children: <TextSpan>
                [
                  TextSpan(
                    text: message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? exportedImage;

  processImage(Uint8List exportedImage) {
    if (exportedImage != null) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      imageName = "IMG_$formattedDate.png"; // Image name with date-time
      imageData = base64Encode(exportedImage);
      print('File name: $imageName');
      print('Base64 data: $imageData');
    } else {
      print("Failed to capture image");
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
                width: screenWidth * 0.9,
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
                      processImage(exportedImage!);
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

  List<GetSONumber> _soNumber = [];
  _getSONumber(){
    SODataServices.getSONumber(widget.services.id, widget.selectedDay).then((getSONumber) {
      setState(() {
        _soNumber = getSONumber;
        _isLoading = false;
      });
    });
  }

  List<Position> _position = [];
  _getPositions(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });
  }

  //below this are for account infos get to server
  List<UsersInfo> _users = [];
  _getAccounts(){
    UsersInfoServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users = accountInfo;
      });
    });
  }

  _updateSO(){
    DateTime now = DateTime.now();

    SODataServices.updateSO(
        widget.services.id, _soNumber[0].soId,
        txtTimeIn.text, txtTimeOut.text,
        now.toString(), txtSysProduct.text,
        txtLocation.text, txtComplaint.text,
        txtStatus.text, txtRemarks.text,
        selSysProd!, selSvcBy!,
        txtConforme.text, imageName, imageData
    ).then((result) {
      if('success' == result){
        // sendPushNotifications();
        // _getServices();
        // clearFields();
        // Navigator.of(context).pop();

        _custSnackbar(
            context,
            "Success... $result",
            Colors.green,
            Icons.check_box
        );
      } else {
        _custSnackbar(
            context,
            "Error occured...$result",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible){
          return Scaffold(
            appBar: const CustomAppBar(title: 'Booking System', imagePath: 'assets/logo/enyecontrols.png'),
            resizeToAvoidBottomInset: true,
            body: _isLoading
              ? Center(child: SpinningContainer(controller: _controller),)
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {
                      _getPositions();
                      _getAccounts();
                      _getSONumber();
                    });
                  },
                  child: ListView(
                    children: [
                        SizedBox(height: screenHeight * 0.03),
                        Center(
                          child: Text(
                            'SERVICE WORK ORDER',
                            style: GoogleFonts.rowdies(
                                textStyle: TextStyle(
                                    fontSize: fontXSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                )
                            )
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "SO# ${_soNumber[0].soNo}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontExtraSize,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2
                                  ),
                                ),
                              ),

                              Text(
                                "DAY ${_soNumber[0].dayCount}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontExtraSize,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Form(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: NormalTextField(
                                      controller: txtTimeIn,
                                      hintText: 'IN',
                                      disabling: disabling,
                                    ),
                                  ),
                                  Expanded(
                                    child: NormalTextField(
                                      controller: txtTimeOut,
                                      hintText: 'OUT',
                                      disabling: disabling,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              NormalTextField(
                                controller: txtSysProduct,
                                hintText: 'System / Product',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              NormalTextField(
                                controller: txtLocation,
                                hintText: 'Location',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              NormalTextField(
                                controller: txtComplaint,
                                hintText: 'Complaint',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              NormalTextField(
                                controller: txtStatus,
                                hintText: 'Status',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              NormalTextField(
                                controller: txtRemarks,
                                hintText: 'Remarks / Recommendation',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                height: screenHeight * 0.065,
                                width: screenWidth * 0.83,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DropdownButton(
                                  alignment: Alignment.center,
                                  underline:Container(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: fontSmallSize,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2
                                    ),
                                  ),
                                  isDense: true,
                                  iconSize: (screenHeight + screenWidth) / 25,
                                  iconEnabledColor: Colors.deepOrange,
                                  isExpanded: true,
                                  value: selSysProd, // Ensures the selected item is shown
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selSysProd = newValue;
                                    });
                                  },
                                  hint: RichText(
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(children: <TextSpan>
                                    [
                                      TextSpan(
                                        text: "System/Product serviced is/are now",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                            color: Colors.black54
                                          ),
                                        ),
                                      ),
                                    ]
                                    ),
                                  ),
                                  items: items.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.04),
                              NormalTextField(
                                controller: txtConforme,
                                hintText: 'Conforme',
                                disabling: disabling,
                              ),

                              SizedBox(height: screenHeight * 0.01),
                              if (exportedImage != null)
                                InkWell(
                                  onTap: () => _showSignatureDialog(context),
                                  child: Container(
                                    width: screenWidth * 0.83,
                                    height: screenHeight * 0.2,
                                    color: Colors.white,
                                    child: Image.memory(
                                      exportedImage!,
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

                              SizedBox(height: screenHeight * 0.03),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                height: screenHeight * 0.075,
                                width: screenWidth * 0.83,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DropdownButton(
                                  alignment: Alignment.center,
                                  underline:Container(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2
                                    ),
                                  ),
                                  isDense: true,
                                  iconSize: (screenHeight + screenWidth) / 25,
                                  iconEnabledColor: Colors.deepOrange,
                                  isExpanded: true,
                                  value: selSvcBy, // Ensures the selected item is shown
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selSvcBy = newValue;
                                    });
                                  },
                                  hint: RichText(
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(children: <TextSpan>
                                    [
                                      TextSpan(
                                        text: "Service by *",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: fontSmallSize,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                              color: Colors.black54
                                          ),
                                        ),
                                      ),
                                    ]
                                    ),
                                  ),
                                  items: _users.map((accountInfo) => DropdownMenuItem(
                                    alignment: Alignment.bottomCenter,
                                    value: accountInfo.user_id.toString(),
                                    child: RichText(
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      text: TextSpan(children: <TextSpan>
                                      [
                                        TextSpan(
                                          text: "${accountInfo.name.toString()} || ${_position.where((element) => element.id == accountInfo.position).elementAtOrNull(0)?.position}",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: fontSmallSize,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.2,
                                                color: Colors.black54
                                            ),
                                          ),
                                        ),
                                      ]
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.01),

                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),
                        addButton(
                          onTap: () {
                            _updateSO();
                          },
                          text: 'SAVE'
                        ),

                        SizedBox(height: screenHeight * 0.02,),
                        if (isKeyboardVisible) SizedBox(height: screenHeight * 0.05,),

                        SizedBox(height: screenHeight * 0.02,),
                    ],
                  ),
                ),
          );
        }
    );
  }
}
