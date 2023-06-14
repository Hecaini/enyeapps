import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "PRODUCTS OF ENYE CONTROLS",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            height: 300,
          ),
          items: ['images/images_2/pic1.jpg',
            'images/images_2/pic2.jpg',
            'images/images_2/pic3.jpg',
            'images/images_2/pic4.jpg',
            'images/images_2/pic5.jpg',
            'images/images_2/pic6.jpg',
            'images/images_2/pic7.jpg',
            'images/images_2/pic8.jpg',
            'images/images_2/pic3.jpg',
            'images/images_2/pic10.jpg'
          ].map((i) {
            return Builder(
                builder : (BuildContext context){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),

                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(i, height: 200,),

                          const SizedBox(height: 10,),
                          if(i=='images/images_2/pic1.jpg')
                            Text(projects[0], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic2.jpg')
                            Text(projects[1], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic3.jpg')
                            Text(projects[2], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic4.jpg')
                            Text(projects[3], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic5.jpg')
                            Text(projects[4], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic6.jpg')
                            Text(projects[5], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic7.jpg')
                            Text(projects[6], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic8.jpg')
                            Text(projects[7], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic3.jpg')
                            Text(projects[8], style: const TextStyle(fontWeight: FontWeight.normal),),
                          if(i=='images/images_2/pic10.jpg')
                            Text(projects[9], style: const TextStyle(fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  );
                }
            );
          }).toList(),
        ),
      ],
    );
  }
}

