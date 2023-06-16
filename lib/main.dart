import 'package:enye_app/pages/about.dart';
import 'package:enye_app/pages/comp_profile.dart';
import 'package:enye_app/pages/home.dart';
import 'package:enye_app/pages/social_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';

import 'dashboardicon_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _homeNavigatorKey,
    _systemsNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[_selectedIndex].currentState?.canPop() == true) {
      _navigatorKeys[_selectedIndex]
          .currentState
          ?.pop(_navigatorKeys[_selectedIndex].currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.deepOrange.shade300,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Dashboardicon.systems),
                label: "Company Profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(Dashboardicon.projects),
                label: "Social Media",
              ),
              BottomNavigationBarItem(
                icon: Icon(Dashboardicon.contact_us),
                label: "Contact Us",
              )
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              _homeNavigator(),
              _CoffeeNavigator(),
            ],
          ),
        ),
      ),
    );
  }
}

class _homeNavigator extends StatefulWidget {
  const _homeNavigator();

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

class _HomeNavigatorState extends State<_homeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/company") {
                return CompProfilePage();
              }else if (settings.name == "/socialmedia") {
                return const SocialmediaPage();
              }
              return HomePage();
            });
      },
    );
  }
}

class Books1 extends StatelessWidget {
  const Books1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Books 1"),
        ),
        TextButton(
          child: const Text("Go to books 2"),
          onPressed: () => Navigator.pushNamed(context, '/books2'),
        ),
      ],
    );
  }
}

class Books2 extends StatelessWidget {
  const Books2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Books 2"),
        )
      ],
    );
  }
}

class _CoffeeNavigator extends StatefulWidget {
  const _CoffeeNavigator();

  @override
  _CoffeeNavigatorState createState() => _CoffeeNavigatorState();
}

GlobalKey<NavigatorState> _systemsNavigatorKey = GlobalKey<NavigatorState>();

class _CoffeeNavigatorState extends State<_CoffeeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _systemsNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/coffee2") {
                return const Coffee2();
              }
              return const Coffee1();
            });
      },
    );
  }
}

class Coffee1 extends StatelessWidget {
  const Coffee1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Coffee 1"),
        ),
        TextButton(
          child: const Text("Go to coffee 2"),
          onPressed: () => Navigator.pushNamed(context, '/coffee2'),
        ),
      ],
    );
  }
}

class Coffee2 extends StatelessWidget {
  const Coffee2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Coffee 2"),
        ),
      ],
    );
  }
}
