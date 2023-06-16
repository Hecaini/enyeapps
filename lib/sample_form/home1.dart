import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class NavBarStay extends StatefulWidget {
  const NavBarStay({super.key});

  @override
  State<NavBarStay> createState() => NavBarStays();
}
class NavBarStays extends State<NavBarStay> {

  /*var projects = ['This system is specifically designed to control temperature',
    'The ENYE Phrases',
    'The ENYE Water By-pass system',
    'The ENYE Temperature and Humidity Control and Monitoring System',
    'The Enye Intelligent Fan Coil Control and Monitoring System ',
    'The ENYE Fire & Smoke Protection system ',
    'The Enye’s Carbon Dioxide Control and Monitoring System ',
    'The Enye Water Leak Detection System ',
    'The ENYE Intelligent Stand-alone Direct Digital Controller ',
    'Safety ',
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: CurvedNavigationBar(
        height: 45,
        backgroundColor: Colors.white,
        color: Colors.deepOrange,
        items: const <Widget>[
          Icon(Icons.home, size: 25, color: Colors.white),
          Icon(Icons.settings, size: 25, color: Colors.white,),
          Icon(Icons.contact_support_outlined, size: 25, color: Colors.white),
        ],

      ),

    );
  }
}