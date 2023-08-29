
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/screens.dart';

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

      if (message.data["goToPage"].toString() == 'Appointment'){
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
        TechSchedPage(message: message as RemoteMessage),
        CompletedPage(message: message as RemoteMessage),
        AccountPage(),
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
          icon: Image(image: AssetImage("assets/icons/approved.png")),
          title: ("Completed"),
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
            confineInSafeArea: true,
            backgroundColor: Colors.deepOrange, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: const NavBarDecoration(
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
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
