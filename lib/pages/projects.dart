import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int _selectedIndex = 0;

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
    return const Scaffold(
      extendBody: true,
      body: Center(child: Text("Projects Page",
        style: TextStyle(fontSize: 24.0, color: Colors.deepOrange, fontWeight: FontWeight.bold),),),
    );

      /*Scaffold(
      extendBody: true,
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

                    *//*Image.network("${gridProjects.elementAt(index)['images']}", height: 300, fit: BoxFit.cover,)*//*
                  ),

                ],
              ),
            );
          },
        ),
      ),
    ),
    );*/

  }
}

