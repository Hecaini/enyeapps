import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/pages/projects.dart';
import 'package:enye_app/pages/systems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/controller.dart';
import '../navbar/navbar.dart';
import '../sample_form/systemsform.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //List pages = [SystemsPage(), HomePage(), AboutPage()];

  final controller = Get.put(NavBarController());

  final List <Map<String, dynamic>> gridCategories = [
    {"title": "Systems", "images": "images/icons/hvac-systems.png", "path": 2},
    {"title": "Projects", "images": "images/icons/projects.png", "path": 1},

  ];

  final List<String> imgList = [
    'images/images_1/pix1.png',
    'images/images_1/pix2.png',
    'images/images_1/pix3.png',
    'images/images_1/pix4.png',
    'images/images_1/pix5.png',
    'images/images_1/pix6.png',
    'images/images_1/pix6.2.png',
    'images/images_1/pix6.3.png',
    'images/images_1/pix7.png',
    'images/images_1/pix8.png',
    'images/images_1/pix9.png',
    'images/images_1/pix10.png',
    'images/images_1/pix11.png',

  ];

  var projects = ['This system is specifically designed to control temperature',
    'The ENYE Phrases',
    'The ENYE Water By-pass system',
    'The ENYE Temperature and Humidity Control and Monitoring System',
    'The Enye Intelligent Fan Coil Control and Monitoring System ',
    'The ENYE Fire & Smoke Protection system ',
    'The Enye’s Carbon Dioxide Control and Monitoring System ',
    'The Enye Water Leak Detection System ',
    'The ENYE Intelligent Stand-alone Direct Digital Controller ',
    'Safety ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/logo/enyecontrols.png", height: 30),
        actions: [
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
                        image: AssetImage("images/images_1/wallpaper.jpg"), fit: BoxFit.cover)),
                child: const Text(
                  "Hi",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBar(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("Account"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_emergency),
              title: const Text("Contact Us"),
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("Informations"),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: const Text("Systems"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.air),
              title: const Text("Projects"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProjectsPage(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text("Log Out"),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(2),
              /*child: Text(
                "PROJECTS OF ENYE CONTROLS",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
            ),
            CarouselSlider(
                items: imgList.map((item) => Container(
                  margin: const EdgeInsets.all(.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      item,
                      fit: BoxFit.fill,
                    ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: 470,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                )),

            //GRID VIEW HOME
            Padding(
              padding: EdgeInsets.all(21.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 21.0,
                  mainAxisSpacing: 21.0,
                  mainAxisExtent: 100,
                ),
                itemCount: gridCategories.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        controller.changeTabIndex(gridCategories[index]['path']);
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){ return Scaffold(body: gridCategories[index]['path']); }),
                        );*/
                      });
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white30,
                      ),
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset("${gridCategories.elementAt(index)['images']}", height: 50, width: 50, fit: BoxFit.fill,),
                          ),
                          Text(
                            "${gridCategories.elementAt(index)['title']}",
                            style: TextStyle(fontSize: 12.0, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

