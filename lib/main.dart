import 'package:enye_app/products.dart';
import 'package:enye_app/projects.dart';
import 'package:enye_app/systems.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'about.dart';
import 'home.dart';


void main(){

  runApp(const MyApp());}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Enye App',
        themeMode: ThemeMode.system,
        home: Home()

    );
  }
}


class Home extends StatefulWidget {
   const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pages = [HomePage(), SystemsPage(), ProductsPage(), ProjectsPage(), AboutPage()];

  int _selectedIndex = 0;

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
      appBar: AppBar(
        title: Image.asset("images/logo/enyecontrols.png", height: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: Container(
                //color: Colors.deepOrange,
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                        image: AssetImage("images/images_1/wallpaper.jpg"))),
                child: const Text(
                  "ronfrancia.enye@gmail.com",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text("Shop"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("Labels"),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text("Sign Up"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.login_outlined),
              title: const Text("Log In"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],

      bottomNavigationBar: Container(
        color: Colors.deepOrange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: GNav(
            backgroundColor: Colors.deepOrange,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.deepOrange.shade200,
            padding: EdgeInsets.all(6),
            gap: 10,
            selectedIndex: _selectedIndex,
            onTabChange: (index){
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(icon: Icons.home, text: 'Home',),
              GButton(icon: Icons.settings, text: 'Systems',),
              GButton(icon: Icons.shop, text: 'Products',),
              GButton(icon: Icons.hvac, text: 'Projects',),
              GButton(icon: Icons.contacts, text: 'About',),
            ],
          ),
        ),
      ),
    );
  }
}
