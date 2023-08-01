
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/screens.dart';
class CustomNavBar extends StatefulWidget {

  static const String routeName = '/navbar';

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
  bool? _sessionData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SessionManager().containsKey("user_data").then((value) => _sessionData = value);
    if (_sessionData == false){
      _sessionData = true;
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => loginPage()));
    } else {
      _sessionData = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _buildScreens() {
      return [
        DashboardPage(),
        //OrdersPage(),
        AppointmentPage(),
        CatalogsPage(),
        AccountPage(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.dashboard),
          title: ("Dashboard"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        /*PersistentBottomNavBarItem(
          icon: Icon(Icons.list),
          title: ("Orders"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),*/
        PersistentBottomNavBarItem(
          icon: Icon(Icons.book),
          title: ("Appointment"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.shop),
          title: ("Products"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: ("Account"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ];
    }

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    //SessionManager().containsKey("user_data").then((value) => _sessionData = value);
    print(_sessionData);

    return PersistentTabView(
      hideNavigationBar: _sessionData == false ? true : false,
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
    );

      /*BottomAppBar(
      color: Colors.deepOrange,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              color: Colors.white,
              tooltip: 'Home',
              icon: const Icon(Dashboardicon.home_nav, semanticLabel: 'Home'),
              onPressed: (){
                Navigator.pushNamed(context, '/');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Systems',
              icon: const Icon(Dashboardicon.systems_nav, semanticLabel: 'Systems',),
              onPressed: (){
                Navigator.pushNamed(context, '/systems');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Projects',
              icon: const Icon(Dashboardicon.projects_nav, semanticLabel: 'Projects',),
              onPressed: (){
                Navigator.pushNamed(context, '/projects');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Contacts',
              icon: const Icon(Dashboardicon.contact_us_nav, semanticLabel: 'Contacts',),
              onPressed: (){
                Navigator.pushNamed(context, '/contacts');
              },),
          ],
        ),
      ),
    );*/
  }
}
