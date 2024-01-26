import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';
import '../screens/screens.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final String imagePath;


  const CustomAppBar({
    super.key,
    required this.title,
  required this.imagePath,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserLogin? userInfo; //users session
  bool? userSessionFuture;
  RemoteMessage? message ;

  @override
  void initState(){
    super.initState();

    _services = [];

    //calling session data
    CheckSessionData().getUserSessionStatus().then((userSession) {
      if (userSession == true) {
        CheckSessionData().getClientsData().then((value) {
          setState(() {
            userInfo = value;
          });
          _getServices();
        });
        userSessionFuture = userSession;
      } else {
        userSessionFuture = userSession;
      }
    });
  }

  late List<TechnicalData> _services;
  _getServices(){
    if(userInfo?.status != "Employee") {
      TechnicalDataServices.getTechnicalData().then((technicalData){
        setState(() {
          _services = technicalData.where((element) => element.status == "Unread" || element.status == "Re-sched").toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

      if (message?.data["goToPage"].toString() == 'Appointment'){

      } else if (message?.data["goToPage"].toString() == 'Completed'){

      }

      // Continue processing with the casted value
    } else {
      message = const RemoteMessage();
    }

    if (widget.imagePath.isNotEmpty) {
      appBarTitle = Image.asset(widget.imagePath, width: MediaQuery.of(context).size.width * 0.6,);
    } else {
      appBarTitle = Text(widget.title, style: const TextStyle(color: Colors.white));
    }

    return AppBar(

      backgroundColor: Colors.deepOrange,
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (userInfo?.status != "Employee")
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return UnreadPage(message: message as RemoteMessage);
                  },
                ),
              );
            },
            icon: Stack(
              children: [
                Image(
                  image: const AssetImage("assets/icons/ringing.png"),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.scaleDown,  // Use BoxFit.scaleDown to scale the image down
                ),
                if (_services.isNotEmpty)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red.shade300,  // Border color
                          width: 2.0,            // Border width
                        ),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _services.length.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ].toList(), // Convert the Set to a List
    );
  }
}