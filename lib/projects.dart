import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              mainAxisExtent: 300,
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
                        child: Image.network("${gridProjects.elementAt(index)['images']}", height: 300, fit: BoxFit.cover,),
                    ),

                  ],
                ),
              );
            },
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

