import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/pages/projects.dart';
import 'package:enye_app/pages/systems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/controller.dart';
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
    {"title": "Systems", "images": "images/icons/thermostat.png", "path": 2},
    {"title": "Projects", "images": "images/icons/skyscraper.png", "path": 1},

  ];

  final List<String> imgList = [
    'https://enyecontrols.com/ec_cpanel/images/systems/1653447224.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448162.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448199.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448274.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448353.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448438.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653449023.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653458552.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653458587.png',
    'https://enyecontrols.com/ec_cpanel/images/systems/1653448038.png',

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
                    child: Image.network(
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
                  crossAxisCount: 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 16.0,
                  mainAxisExtent: 120,
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
                        color: Colors.orange[800]?.withOpacity(0.8),
                      ),
                      child: Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                            child: Image.asset("${gridCategories.elementAt(index)['images']}", height: 75, width: 85, fit: BoxFit.fill,),
                          ),
                          Text(
                            "${gridCategories.elementAt(index)['title']}",
                            style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
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
