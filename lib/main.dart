import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


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
  var projects = [' Phrases',
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
                        image: AssetImage("images/images_1/wallpaper.jpg"))),
                child: const Text(
                  "ronfrancia.enye@gmail.com",
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
              leading: const Icon(Icons.label),
              title: const Text("Systems"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text("Projects"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text("Products"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "PROJECTS OF ENYE CONTROLS3333333333333333333",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CarouselSlider(
                items: imgList.map((item) => Container(
                  child: Center(child: Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,

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

                      child: Column(
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
                    );
            }
                  );
            }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

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