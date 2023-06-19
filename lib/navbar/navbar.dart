import 'package:enye_app/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../pages/about.dart';
import '../pages/home.dart';
import '../pages/projects.dart';
import '../pages/systems.dart';
import '../sample_form/systemsform.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context){
      return Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: const [HomePage(), ProjectsPage(), SystemsPage(), AboutPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.deepOrange.shade300,
          currentIndex: controller.tabIndex,
          onTap: controller.changeTabIndex,
          items: [
            _bottombarItem(IconlyBold.home, "Home"),
            _bottombarItem(IconlyBold.activity, "Projects"),
            _bottombarItem(IconlyBold.setting, "Systems"),
            _bottombarItem(IconlyBold.call, "About Us")
          ]),
      );
    });
  }
}

//ignore: unused_element
_bottombarItem(IconData icon, String label){
  return BottomNavigationBarItem(icon: Icon(icon), label: label);
}