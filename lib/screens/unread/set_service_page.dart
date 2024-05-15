import 'package:enye_app/screens/technical_schedule/technical_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class SetServicePage extends StatefulWidget {
  final TechnicalData services;

  const SetServicePage({super.key, required this.services});

  @override
  State<SetServicePage> createState() => _SetServicePageState();
}

class _SetServicePageState extends State<SetServicePage> with TickerProviderStateMixin {

  bool _isLoading = true;
  bool disabling = false;

  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  final txtNotes = TextEditingController();
  final txtLocation = TextEditingController();
  final txtComplaint = TextEditingController();
  final txtStatus = TextEditingController();
  final txtRemarks = TextEditingController();
  final txtConforme = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();

    _getAccounts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<UsersInfo> _users = [];
  List<Position> _position = [];
  List<UsersInfo> _usersEngineers = [];
  List<UsersInfo> _usersTechnicians = [];

  _getAccounts(){
    PositionServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });

    UsersInfoServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users = accountInfo;
      });
    });
  }

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

  Future<void> _showDateTimePicker(bool isStartDateTime) async {
    DateTime? initialDate = isStartDateTime ? _selectedStartDate : _selectedEndDate;
    DateTime? selectedDate = await showOmniDateTimePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: _selectedStartDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 60,
      secondsInterval: 60,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDateTime) {
          _selectedStartDate = selectedDate;
          txtStartDate.text = DateFormat('MMM d, yyyy hh:mm a').format(_selectedStartDate!).toString();
        } else {
          _selectedEndDate = selectedDate;
          txtEndDate.text = DateFormat('MMM d, yyyy hh:mm a').format(_selectedEndDate!).toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible){
          return Scaffold(
            appBar: const CustomAppBar(title: 'Booking System', imagePath: 'assets/logo/enyecontrols.png'),
            resizeToAvoidBottomInset: true,
            body: ListView(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Text(
                    'SET SCHEDULE FOR SUPPORT',
                    style: GoogleFonts.rowdies(
                      textStyle: TextStyle(
                          fontSize: fontExtraSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      )
                    )
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),
                Form(
                  child: Column(
                    children: [

                      OnTapTextField(
                        onTap: () {
                          _selectedStartDate = null;
                          txtEndDate.clear();
                          _showDateTimePicker(true);
                        },
                        controller: txtStartDate,
                        hintText: 'START DATE',
                        disabling: true,
                      ),

                      SizedBox(height: screenHeight * 0.015),
                      OnTapTextField(
                        onTap: () {
                          if(_selectedStartDate != null && txtStartDate.text != null){
                            _showDateTimePicker(false);
                          }
                        },
                        controller: txtEndDate,
                        hintText: 'END DATE',
                        disabling: true,
                      ),

                      SizedBox(height: screenHeight * 0.015),
                      NormalTextField(
                        controller: txtRemarks,
                        hintText: 'Notes',
                        disabling: disabling,
                      ),

                      SizedBox(height: screenHeight * 0.015),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultipleUsersDialogWidget(users: _users, position: _position, chosenPosition: "Engineer");
                        },
                      ).then((selectedItems) {
                        if (selectedItems != null) {
                          // Display selected items
                          _usersEngineers = selectedItems;
                        }
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
                      'Engineers',
                      style: TextStyle(
                        fontSize: fontNormalSize,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                if (_usersEngineers != null)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Wrap(
                        children: _usersEngineers.map((engineer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            child: Chip(
                              label: Text(
                                engineer.username,
                                style: TextStyle(color: Colors.grey.shade800, fontSize: fontXSmallSize),
                              ),
                              backgroundColor: Colors.deepOrange.shade50,
                              deleteIcon: Icon(Icons.cancel, size: (screenHeight + screenWidth) / 70,), // Add delete icon
                              deleteIconColor: Colors.deepOrange,
                              onDeleted: () {
                                setState(() {
                                  _usersEngineers.remove(engineer); // Remove item from the list
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultipleUsersDialogWidget(users: _users, position: _position, chosenPosition: "Technician");
                        },
                      ).then((selectedItems) {
                        if (selectedItems != null) {
                          // Display selected items
                          _usersTechnicians = selectedItems;
                        }
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
                      'Technicians',
                      style: TextStyle(
                        fontSize: fontNormalSize,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                if (_usersTechnicians != null)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Wrap(
                        children: _usersTechnicians.map((technician) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            child: Chip(
                              label: Text(
                                technician.username,
                                style: TextStyle(color: Colors.grey.shade800, fontSize: fontXSmallSize),
                              ),
                              backgroundColor: Colors.deepOrange.shade50,
                              deleteIcon: Icon(Icons.cancel, size: (screenHeight + screenWidth) / 70,), // Add delete icon
                              deleteIconColor: Colors.deepOrange,
                              onDeleted: () {
                                setState(() {
                                  _usersTechnicians.remove(technician); // Remove item from the list
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.04),
                addButton(
                  onTap: () {
                    // _saveSO();
                  },
                  text: 'SAVE'
                ),
                if (isKeyboardVisible) SizedBox(height: screenHeight * 0.05,),

                SizedBox(height: screenHeight * 0.02,),
              ],
            ),
          );
        }
    );
  }
}

class MultipleUsersDialogWidget extends StatefulWidget {
  final List<UsersInfo> users;
  final List<Position> position;
  final String chosenPosition;

  MultipleUsersDialogWidget({super.key, required this.users, required this.position, required this.chosenPosition});

  @override
  _MultipleUsersDialogWidgetState createState() => _MultipleUsersDialogWidgetState();
}

class _MultipleUsersDialogWidgetState extends State<MultipleUsersDialogWidget> {

  List<UsersInfo> _users = [];
  List<UsersInfo> _filteredUsers = [];
  Map<UsersInfo, bool> _checkedUsers = {};

  @override
  void initState() {
    super.initState();

    if(widget.chosenPosition == "Engineer"){
      _users = widget.users.where((user) =>
        widget.position
            .where((position) => position.id == user.position)
            .elementAtOrNull(0)
            ?.position
            ?.toLowerCase()
            ?.contains("engineer") ?? false)
      .toList();
    } else if (widget.chosenPosition == "Technician"){
      _users = widget.users.where((user) =>
        widget.position
            .where((position) => position.id == user.position)
            .elementAtOrNull(0)
            ?.position
            ?.toLowerCase()
            ?.contains("technician") ?? false)
      .toList();
    } else {
      _users = widget.users;
    }

    _filteredUsers = List.from(_users);
    _users.forEach((users) => _checkedUsers[users] = false);
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = List.from(_users);
      });
    } else {
      setState(() {
        _filteredUsers = _users.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  List<UsersInfo> getSelectedItems() {
    List<UsersInfo> selectedItems = [];
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

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return AlertDialog(
      title: Text(widget.chosenPosition),
      content: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(
                  fontSize: fontNormalSize,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: fontNormalSize,
                ),
                prefixIcon: Icon(Icons.search, size: (screenWidth + screenHeight) / 40,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                UsersInfo user = _filteredUsers[index];
                return CheckboxListTile(
                  title: Text(
                    user.name,
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
            List<UsersInfo> selectedItems = getSelectedItems();
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
