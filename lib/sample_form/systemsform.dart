import 'package:enye_app/navbar/navbar.dart';
import 'package:enye_app/pages/home.dart';
import 'package:enye_app/pages/projects.dart';
import 'package:enye_app/sample_form/systemsformdescrip.dart';
import 'package:flutter/material.dart';
//import 'about.dart';

class SystemsForm extends StatelessWidget {
  const SystemsForm({super.key});

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
             //   Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBar(),));
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

      body: CustomScrollView(
        slivers: [
         const SliverAppBar(
            leading: Text(''),
           // title: Image.asset("images/logo/enyecontrols.png", height: 30),
            backgroundColor: Colors.deepOrangeAccent,
            expandedHeight: 70,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
              title: Text('SYSTEMS OF ENYECONTROLS', style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                //fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: .2,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),),
              centerTitle: true,
            ),

          ),
          /*SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 120.0,
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.center,
                 child: ShaderMask(
                 shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                 colors: [Colors.deepOrange, Colors.deepOrangeAccent],
                  begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
                  ).createShader(bounds);
                  },
                  child: const Text(
                  'SYSTEMS OF ENYECONTROLS',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    decorationColor: Colors.red,
                    decorationThickness: 5.0,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        offset: Offset(3.0, 1.0),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              ),
            ]),
          ),*/
          SliverToBoxAdapter(
          child: GestureDetector(
          onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBarStay(),));
          },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix1.png',
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> System2(),));
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 400,
                    color: Colors.deepOrange,
                    margin: EdgeInsets.all(15.0),
                    child: Image.asset(
                       'images/images_1/pix2.png',
                         fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
             child: GestureDetector(
               onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> System3(),));
               },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix3.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
           child: GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> System4(),));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix4.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
           child: GestureDetector(
           onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> System5(),));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix5.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
           child: GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> System6(),));
           },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix6.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> System66(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix6.2.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
           child: GestureDetector(
           onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> System666(),));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix6.3.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
             onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> System7(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix7.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
             onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> System8(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix8.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
             onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> System9(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix9.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
             onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> System10(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix10.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
             onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> System11(),));
             },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                  margin: EdgeInsets.all(15.0),
                  child: Image.asset(
                      'images/images_1/pix11.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}


/*class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {

  final List <Map<String, dynamic>> gridCategories = [
    {"title": "Systems", "images": "images/icons/hvac-systems.png", "path": SystemsPage()},
    {"title": "Projects", "images": "images/icons/projects.png", "path": ProjectsPage()},
    {"title": "Company Profile", "images": "images/icons/website.png", "path": AboutPage()},
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Icon(Icons.menu),
            title: Image.asset("images/logo/enyecontrols.png", height: 30),
            expandedHeight: 300,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Container(
              height: 400,
              color: Colors.deepOrange,
            ),
            ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Container(
                  height: 400,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );*/
    /*return Column(
      children: [
        *//*const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "PROJECTS OF ENYE CONTROLS",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),*//*
        CarouselSlider(
            items: imgList.map((item) => Container(
              //  margin: const EdgeInsets.all(8),
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
              height: 380,
              autoPlay: true,
              aspectRatio: .5,
              enlargeCenterPage: false,
              // enlargeStrategy: CenterPageEnlargeStrategy.height,
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
                mainAxisExtent: 100,
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
          ),
        )

      ],
    );*/



