import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List _categories = ['assets/icons/hvac.png', 'assets/icons/motorizedvalve.png', 'assets/icons/sensors.png', 'assets/icons/valve.png', 'assets/icons/software.png'];

  final List <Map<String, dynamic>> gridProjects = [
    {"title": "1 Nito Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622619484.jpg"},
    {"title": "8912 Aseana", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620662.jpg"},
    {"title": "Alveo Financial Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620397.png"},
    {"title": "Alveo High Park", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620529.jpg"},
    {"title": "Ayala Land Vermosa BLDG.", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622687669.jpg"},
    {"title": "Ayala Triangle Gardens", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620781.jpg"},
    {"title": "BA Lepanto Building", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622621124.jpg"},
    {"title": "BDO Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622621376.jpg"}
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              mainAxisExtent: 270,
            ),
            itemCount: gridProjects.length,
            itemBuilder: (context, index){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.orange[200],
                ), //no function??nasasapawan ng pictures
                child: Column(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        height: 270,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage("${gridProjects.elementAt(index)['images']}"), fit: BoxFit.cover),
                        ),

                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.3)],
                              stops: [0.0, 1],
                              begin: Alignment.topCenter,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(top: 50.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0)],
                                ),
                              ),
                              child: Text(
                                "${gridProjects.elementAt(index)['title']}",
                                style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*Image.network("${gridProjects.elementAt(index)['images']}", height: 300, fit: BoxFit.cover,)*/
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),

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

      /*Center(child: Text('Projects Page'),),*/

      /* SizedBox(
          height: 90,
          child: ListView.builder(
            itemCount: _categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return projCategories(
                iconShow: _categories[index],
              );
            },
          ),
        ),*/

  }
}

