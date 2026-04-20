
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../screens/screens.dart';
import '../screens/webview/webview_system.dart';

class CustomNavBar extends StatefulWidget {

  static const String routeName = '/';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CustomNavBar()
    );
  }

  const CustomNavBar({
    super.key,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {

  late Future _userSessionFuture;
  int _initialIndex = 0;

  @override
  void initState() {
    _userSessionFuture = this._getUserSessionStatus();
    super.initState();
  }

  Future<bool> _getUserSessionStatus() async {
    return SessionManager().containsKey("user_data");
  }

  Widget _loadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    RemoteMessage? message;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

      if (message.data["goToPage"].toString() == 'Appointment' || message.data["goToPage"].toString() == 'Re-sched' || message.data["goToPage"].toString() == 'Accepted' || message.data["goToPage"].toString() == 'Booking'){
        _initialIndex = 0;
      } else if (message.data["goToPage"].toString() == 'Completed'){
        _initialIndex = 1;
      }

      // Continue processing with the casted value
    } else {
      message = RemoteMessage();
    }

    List<Widget> _buildScreens() {
      return [
        //DashboardPage(),
        //OrdersPage(),
        //AppointmentPage(),
        //CatalogsPage(),

        //QuotationPage(),
        // TechSchedPage(message: message as RemoteMessage),
        SchedulePage(message: message as RemoteMessage),
        ECCompletedPage(message: message as RemoteMessage),
        AccountPage(),
        WebViewPage(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        /*PersistentBottomNavBarItem(
          icon: Image(image: AssetImage("assets/icons/quotation.png")),
          title: ("Quotation"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),*/
        PersistentBottomNavBarItem(
          icon: Image(image: AssetImage("assets/icons/appointment.png")),
          title: ("Appointment"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Image(image: AssetImage("assets/icons/history.png")),
          title: ("History"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Image(image: AssetImage("assets/icons/profile.png")),
          title: ("Account"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Image(image: AssetImage("assets/logo/enyelogo.png")),
          title: ("System"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ];
    }

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: _initialIndex);

    return FutureBuilder(
      future: _userSessionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool _userLoginStatus = snapshot.data;
          return _userLoginStatus ? PersistentTabView(
            //hideNavigationBar: widget.sessionData,
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineToSafeArea: true,
            backgroundColor: Colors.deepOrange, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardAppears: true,
            decoration: const NavBarDecoration(
              colorBehindNavBar: Colors.white,
            ),
            navBarStyle: NavBarStyle.style9, // Choose the nav bar style with this property.
          ) : LoginPage();
        } else {
          return _loadingScreen();
        }
      },
    );
  }
}
