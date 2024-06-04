import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:path/path.dart' as path;

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../screens.dart';

class ViewSOPage extends StatefulWidget {
  final String soId;

  const ViewSOPage({
    super.key,
    required this.soId,
  });

  @override
  State<ViewSOPage> createState() => _ViewSOPageState();
}

class _ViewSOPageState extends State<ViewSOPage> with TickerProviderStateMixin {
  bool disabling = true;
  String? selSysProd;
  String? selSvcBy;
  bool _isLoading = true;
  bool _isLoadingFiles = true;
  String imageName = '';
  String imageData = '';
  double? _progress;
  Map<int, double?> _fileProgress = {};

  final txtTimeIn = TextEditingController();
  final txtTimeOut = TextEditingController();
  final txtSysProduct = TextEditingController();
  final txtLocation = TextEditingController();
  final txtComplaint = TextEditingController();
  final txtStatus = TextEditingController();
  final txtRemarks = TextEditingController();
  final txtConforme = TextEditingController();
  final txtConformeEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSOFiles();
    _getEngAccounts();
  }

  var items = [
    'Fully Operational',
    'For Further Testing',
    'Parts need to be Replaced'
  ];

  List<EngUsers> _servicedBy = [];
  String servicedByUsername = '';

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

  List<SOData> _serviceOrder = [];
  List<SOFilesData> _serviceOrderFiles = [];
  _getServiceOrder(){
    SOServices.getServiceOrder(widget.soId).then((getServiceOrder) {
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

          _servicedBy.clear();
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

  _getSOFiles(){
    SOServices.getServiceOrderFiles(widget.soId).then((serviceOrderFile) {
      setState(() {
        _serviceOrderFiles = serviceOrderFile;
        _isLoadingFiles = false;
      });
    });
  }

  //below this are for account infos get to server
  List<EngUsers> _engUsers = [];
  _getEngAccounts(){
    UsersInfoServices.getEngUsers().then((accountInfo){
      setState(() {
        _engUsers = accountInfo.where((e) => e.status != 'Resigned').toList();
        _getServiceOrder();
      });
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
                  _getSOFiles();
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
                          "SO# ${_serviceOrder[0].soNo}",
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
                          "DAY ${_serviceOrder[0].day}",
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
                            onChanged: disabling ? null : (String? newValue) {
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

                        SizedBox(height: screenHeight * 0.02),
                        NormalTextField(
                          controller: txtConformeEmail,
                          hintText: 'Conforme Email',
                          disabling: disabling,
                        ),

                        SizedBox(height: screenHeight * 0.01),
                          if (_serviceOrder.isNotEmpty)
                            if (_serviceOrder[0].conformeSignature.isEmpty || _serviceOrder[0].conformeSignature == "" || _serviceOrder[0].conformeSignature == null)
                                Container(
                                  width: screenWidth * 0.83,
                                  height: screenHeight * 0.13,
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Text(
                                      "No Signature Captured.",
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
                              )
                            else
                              Container(
                                width: screenWidth * 0.83,
                                height: screenHeight * 0.2,
                                color: Colors.white,
                                child: Image.network(
                                  API.ec_conformeSig + _serviceOrder[0].conformeSignature,
                                  fit: BoxFit.fill,
                                ),
                              )
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: ElevatedButton(
                      onPressed: () {
                        if(disabling == false) {
                          _unfocusAll();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MultipleECUsersDialogWidget(
                                  users: _engUsers,
                                  chosenPosition: "Engineer & Technician",
                                  initiallySelectedUsers: _servicedBy);
                            },
                          ).then((selectedItems) {
                            setState(() {
                              if (selectedItems != null) {
                                // Display selected items
                                _servicedBy = selectedItems;
                              }
                            });
                          });
                        }
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
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: ElevatedButton(
                      onPressed: () {
                        if(disabling == false) {
                          _unfocusAll();
                        }
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
                        'Attach File',
                        style: TextStyle(
                          fontSize: fontNormalSize,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  if (_serviceOrderFiles.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Wrap(
                          children: _serviceOrderFiles.map((file) {
                            double? fileProgress = _fileProgress[int.parse(file.id)];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5),
                              child: fileProgress != null
                              ? SizedBox(
                                width: screenWidth * 0.1,
                                height: screenHeight * 0.1,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : InkWell(
                                onTap: disabling ? (){
                                  String filename = path.basename(file.location);
                                  print(filename);
                                  String url = API.ECsoAttach + filename;

                                  FileDownloader.downloadFile(
                                      url: url.trim(),
                                      onProgress: (name, progress) {
                                        setState(() {
                                          _fileProgress[int.parse(file.id)] = progress;
                                        });
                                      },
                                      onDownloadCompleted: (value) {
                                        print('path  $value ');
                                        _custSnackbar(
                                            context,
                                            "File successfully downloaded.",
                                            Colors.green,
                                            Icons.check_box
                                        );
                                        setState(() {
                                          _fileProgress[int.parse(file.id)] = null;
                                        });
                                      });
                                } : null ,
                                child: Chip(
                                  label: Text(
                                    file.name,
                                    style: TextStyle(color: Colors.grey.shade800, fontSize: fontXSmallSize),
                                  ),
                                  backgroundColor: Colors.deepOrange.shade50,
                                  deleteIcon: Icon(Icons.cancel, size: (screenHeight + screenWidth) / 70,), // Add delete icon
                                  deleteIconColor: Colors.deepOrange,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "No attachment included",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.03),
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

                  SizedBox(height: screenHeight * 0.04),
                  whiteButton(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    text: 'CLOSE',
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

