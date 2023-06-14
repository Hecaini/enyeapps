import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/projects.dart';
import 'package:enye_app/systems.dart';
import 'package:flutter/material.dart';

import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List <Map<String, dynamic>> gridCategories = [
    {"title": "Systems", "images": "images/icons/hvac-systems.png", "path": SystemsPage()},
    {"title": "Projects", "images": "images/icons/projects.png", "path": ProjectsPage()},
    {"title": "EC Bills", "images": "images/icons/ec-bills.png", "path": AboutPage()},
    {"title": "Contact Us", "images": "images/icons/contact-us.png", "path": AboutPage()},
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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "PROJECTS OF ENYE CONTROLS",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
            items: imgList.map((item) => Container(
              margin: const EdgeInsets.all(8),
              width: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  item,
                  fit: BoxFit.fill,
                ),
              ),
            )).toList(),
            options: CarouselOptions(
              height: 270,
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            )),

        //GRID VIEW HOME
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(21.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 21.0,
                mainAxisSpacing: 21.0,
                mainAxisExtent: 125,
              ),
              itemCount: gridCategories.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (BuildContext context){ return gridCategories[index]['path']; }),
                      );
                    });
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.orange[100],
                    ),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset("${gridCategories.elementAt(index)['images']}", color: Colors.deepOrange, height: 60, width: 60, fit: BoxFit.fill,),
                        ),
                        Text(
                          "${gridCategories.elementAt(index)['title']}",
                          style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )

      ],
    );
  }
}

