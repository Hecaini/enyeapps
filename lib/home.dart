import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> imgList = [
    'images/images_2/pix1.png',
    'images/images_2/pix2.png',
    'images/images_2/pix3.png',
    'images/images_2/pix4.png',
    'images/images_2/pix5.png',
    'images/images_2/pix6.png',
    'images/images_2/pix7.png',
    'images/images_2/pix8.png',
    'images/images_2/pix9.png',
    'images/images_2/pix10.png',

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
                child: Image.asset(
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
            height: 200,
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

