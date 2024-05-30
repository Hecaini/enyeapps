import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class SOPage extends StatefulWidget {
  final TSISData tsis;
  final String selectedDay;
  final EventsData event;

  const SOPage({
    super.key,
    required this.tsis,
    required this.selectedDay,
    required this.event,
  });

  @override
  State<SOPage> createState() => _SOPageState();
}

class _SOPageState extends State<SOPage> with TickerProviderStateMixin {
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

    _getEngAccounts();
    _getSONumber();
  }

  var items = [
    'Fully Operational',
    'For Further Testing',
    'Parts need to be Replaced'
  ];

  List<EngUsers> _servicedBy = [];
  String servicedByIds = '';

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }
    return false;
  }

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
        margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.82),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: fontNormalSize * 1.8,
            ),
            SizedBox(width: screenWidth * 0.03,),
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

  List<GetSONumber> _soNumber = [];
  _getSONumber(){
    SOServices.getSONumber(widget.tsis.tsisId, widget.selectedDay, widget.event.id).then((getSONumber) {
      setState(() {
        _soNumber = getSONumber;
        if (_soNumber.isNotEmpty) {
          if(_soNumber[0].soStatus == "Save"){
            _getServiceOrder();
          } else {
            _isLoading = false;
          }
        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoading = false;
          print("No service order numbers retrieved");
        }
      });
    });
  }

  List<SOData> _serviceOrder = [];
  _getServiceOrder(){
    SOServices.getServiceOrder(_soNumber[0].soId).then((getServiceOrder) {
      setState(() {
        _serviceOrder = getServiceOrder;
        _isLoading = false;

        if (_serviceOrder.isNotEmpty) {
          txtTimeIn.text = _serviceOrder[0].timeIn;
          txtTimeOut.text = _serviceOrder[0].timeOut;
          txtSysProduct.text = _serviceOrder[0].systemProduct;
          txtLocation.text = _serviceOrder[0].location;
          txtComplaint.text = _serviceOrder[0].complaint;
          txtStatus.text = _serviceOrder[0].status;
          txtRemarks.text = _serviceOrder[0].remark;
          selSysProd = _serviceOrder[0].service;
          txtConforme.text = _serviceOrder[0].conforme;
          selSvcBy = _serviceOrder[0].servicedBy;

          for (var engUser in _engUsers) {
            if (_isUserAssigned(_serviceOrder[0].servicedBy, engUser.username)) {
              _servicedBy.add(engUser);
            }
          }

        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoading = false;
          print("No service order retrieved");
        }
      });
    });
  }

  //below this are for account infos get to server
  List<EngUsers> _engUsers = [];
  _getEngAccounts(){
    UsersInfoServices.getEngUsers().then((accountInfo){
      setState(() {
        _engUsers = accountInfo.where((e) => e.status != 'Resigned').toList();
      });
    });
  }

  _saveSO(){
    DateTime now = DateTime.now();

    SODataServices.saveSO(
        widget.tsis.tsisId, _soNumber[0].soId,
        txtTimeIn.text, txtTimeOut.text,
        txtSysProduct.text, txtLocation.text, txtComplaint.text,
        txtStatus.text, txtRemarks.text,
        selSysProd!, selSvcBy!, widget.selectedDay,
        txtConforme.text, imageName, imageData
    ).then((result) {
      if('success' == result){
        // sendPushNotifications();
        // _getServices();
        // clearFields();
        // Navigator.of(context).pop();

        _custSnackbar(
            context,
            "Successfully saved !",
            Colors.green,
            Icons.check_box
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SOPdfPreviewPage(soId: _soNumber[0].soId),
            ),
          ).then((value) {
            // Refresh the services once the StatusPage is popped
            _getEngAccounts();
            _getSONumber();
            setState(() {});
          });
        });
      } else {
        _custSnackbar(
            context,
            "Error occured... $result",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
  }

  _updateSO(){
    SODataServices.updateSO(
        _soNumber[0].soId, txtTimeIn.text,
        txtTimeOut.text, txtSysProduct.text,
        txtLocation.text, txtComplaint.text,
        txtStatus.text, txtRemarks.text,
        selSysProd!, selSvcBy!,
        txtConforme.text, imageName, imageData
    ).then((result) {
      if('success' == result){

        _custSnackbar(
            context,
            "Successfully updated !",
            Colors.green,
            Icons.check_box
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SOPdfPreviewPage(soId: _soNumber[0].soId),
            ),
          ).then((value) {
            // Refresh the services once the StatusPage is popped
            _getEngAccounts();
            _getSONumber();
            setState(() {});
          });
        });
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

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
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
                  _getSONumber();
                  _getEngAccounts();
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

                  SizedBox(height: screenHeight * 0.015),
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

                        SizedBox(height: screenHeight * 0.015),
                        NormalTextField(
                          controller: txtSysProduct,
                          hintText: 'System / Product',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.015),
                        NormalTextField(
                          controller: txtLocation,
                          hintText: 'Location',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.015),
                        NormalTextField(
                          controller: txtComplaint,
                          hintText: 'Complaint',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.015),
                        NormalTextField(
                          controller: txtStatus,
                          hintText: 'Status',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.015),
                        NormalTextField(
                          controller: txtRemarks,
                          hintText: 'Remarks / Recommendation',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.015),
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
                          if (_serviceOrder.isNotEmpty)
                            if (_serviceOrder[0].conformeSignature.isNotEmpty || _serviceOrder[0].conformeSignature != "")
                              InkWell(
                                onTap: () => _showSignatureDialog(context),
                                child: Container(
                                  width: screenWidth * 0.83,
                                  height: screenHeight * 0.2,
                                  color: Colors.white,
                                  child: Image.network(
                                    API.ec_conformeSig + _serviceOrder[0].conformeSignature,
                                    fit: BoxFit.fill,
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

                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: ElevatedButton(
                      onPressed: () {
                        _unfocusAll();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MultipleECUsersDialogWidget(users: _engUsers, chosenPosition: "Engineer & Technician", initiallySelectedUsers: _servicedBy);
                          },
                        ).then((selectedItems) {
                          setState(() {
                            if (selectedItems != null) {
                              // Display selected items
                              _servicedBy = selectedItems;
                            }
                          });
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade300),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      child: Text(
                        'Serviced By : ',
                        style: TextStyle(
                          fontSize: fontNormalSize,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  if (_servicedBy != null)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Wrap(
                          children: _servicedBy.map((eng_tech) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5),
                              child: Chip(
                                label: Text(
                                  eng_tech.username,
                                  style: TextStyle(color: Colors.grey.shade800, fontSize: fontXSmallSize),
                                ),
                                backgroundColor: Colors.deepOrange.shade50,
                                deleteIcon: Icon(Icons.cancel, size: (screenHeight + screenWidth) / 70,), // Add delete icon
                                deleteIconColor: Colors.deepOrange,
                                onDeleted: () {
                                  setState(() {
                                    _servicedBy.remove(eng_tech); // Remove item from the list
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.04),
                  if (_serviceOrder.isNotEmpty && _serviceOrder[0].stat == "Save")
                    editButton(
                        onTap: () {
                          if(txtTimeIn.text.isEmpty || txtTimeOut.text.isEmpty || txtSysProduct.text.isEmpty ||
                              txtLocation.text.isEmpty || txtComplaint.text.isEmpty || txtStatus.text.isEmpty ||
                              txtRemarks.text.isEmpty || selSysProd == null || txtConforme.text.isEmpty || _servicedBy == null){
                            _custSnackbar(
                                context,
                                "Kindly fill out the fields and select service by !",
                                Colors.redAccent,
                                Icons.error
                            );
                          } else {
                            servicedByIds = _servicedBy.map((serviceBy) => serviceBy.username.toString()).join(', ');
                            print(servicedByIds);

                            // _updateSO();
                          }
                        },
                        text: 'UPDATE'
                    )
                  else
                    addButton(
                        onTap: () {
                          if(txtTimeIn.text.isEmpty || txtTimeOut.text.isEmpty || txtSysProduct.text.isEmpty ||
                              txtLocation.text.isEmpty || txtComplaint.text.isEmpty || txtStatus.text.isEmpty ||
                              txtRemarks.text.isEmpty || selSysProd == null || txtConforme.text.isEmpty || _servicedBy == null){
                            _custSnackbar(
                                context,
                                "Kindly fill out the fields and select service by !",
                                Colors.redAccent,
                                Icons.error
                            );
                          } else {
                            servicedByIds = _servicedBy.map((serviceBy) => serviceBy.username.toString()).join(', ');
                            print(servicedByIds);

                            // _saveSO();
                          }
                        },
                        text: 'SAVE'
                    ),

                  SizedBox(height: screenHeight * 0.04),
                  if (_serviceOrder.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SOPdfPage(soId: _serviceOrder[0].soId),
                          ),
                        );
                        // rootBundle.
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue.shade300,
                              width: 1.0, // Thickness of the underline
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,  // Use min to prevent the Row from occupying more space than its children need.
                          children: <Widget>[
                            Icon(
                              Icons.download_for_offline_rounded,
                              color: Colors.blue.shade300,
                              size: (screenHeight + screenWidth) / 40,
                            ),// Example icon
                            SizedBox(width: 8),  // Space between icon and text
                            Text(
                              "GENERATE PDF FILE",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: fontNormalSize,
                                fontFamily: 'Rowdies',
                                color: Colors.blue.shade300,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
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

class MultipleECUsersDialogWidget extends StatefulWidget {
  final List<EngUsers> users;
  final String chosenPosition;
  final List<EngUsers> initiallySelectedUsers;

  MultipleECUsersDialogWidget({super.key, required this.users, required this.chosenPosition, required this.initiallySelectedUsers,});

  @override
  _MultipleECUsersDialogWidgetState createState() => _MultipleECUsersDialogWidgetState();
}

class _MultipleECUsersDialogWidgetState extends State<MultipleECUsersDialogWidget> {

  List<EngUsers> _users = [];
  List<EngUsers> _filteredUsers = [];
  Map<EngUsers, bool> _checkedUsers = {};

  @override
  void initState() {
    super.initState();

    if (widget.chosenPosition == "Engineer & Technician") {
      _users = widget.users.where((user) =>
        (user.roleType == "Engineer") || (user.roleType == "Technician")).toList();
    } else {
      _users = widget.users;
    }

    _filteredUsers = List.from(_users);
    _users.forEach((user) {
      _checkedUsers[user] = widget.initiallySelectedUsers.contains(user);
    });
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = List.from(_users);
      });
    } else {
      setState(() {
        _filteredUsers = _users.where((user) => user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.roleType.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  List<EngUsers> getSelectedItems() {
    List<EngUsers> selectedItems = [];
    _checkedUsers.forEach((key, value) {
      if (value) {
        selectedItems.add(key);
      }
    });
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return AlertDialog(
      contentPadding: EdgeInsets.all(2.0),
      title: Text(widget.chosenPosition),
      content: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextField(
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(
                  fontSize: fontNormalSize,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: fontSmallSize,
                ),
                prefixIcon: Icon(Icons.search, size: fontNormalSize * 1.5,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                EngUsers user = _filteredUsers[index];
                return CheckboxListTile(
                  title: Text(
                    "${user.username} - ${user.roleType}",
                    style: TextStyle(
                      fontSize: fontNormalSize
                    ),
                  ),
                  value: _checkedUsers[user],
                  onChanged: (bool? value) {
                    setState(() {
                      _checkedUsers[user] = value!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.white),
              ),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
                fontSize: fontNormalSize
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Get selected items and return them to the caller
            List<EngUsers> selectedItems = getSelectedItems();
            Navigator.of(context).pop(selectedItems); // Close the dialog and return selected items
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.white),
              ),
            ),
          ),
          child: Text(
            'Submit',
            style: TextStyle(
                fontSize: fontNormalSize
            ),
          ),
        ),
      ],
    );
  }
}

