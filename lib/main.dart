import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboardicon_icons.dart';

void main(){
  runApp(const CupertinoApp(
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          height: 60,
          iconSize: 30,
          activeColor: Colors.deepOrange,
          inactiveColor: Colors.deepOrange.shade300,
          items: const [
            BottomNavigationBarItem(icon: Icon(Dashboardicon.home_nav,), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Dashboardicon.systems_nav,), label: "Systems"),
            BottomNavigationBarItem(icon: Icon(Dashboardicon.projects_nav,), label: "Projects"),
            BottomNavigationBarItem(icon: Icon(Dashboardicon.contact_us_nav,), label: "Contacts"),
          ],
        ),
        tabBuilder: (context, index) {
          return Container();
        }
    );
  }
}



