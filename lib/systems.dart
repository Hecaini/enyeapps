import 'package:enye_app/gdview/picnum1.dart';
import 'package:enye_app/home.dart';
import 'package:enye_app/products.dart';
import 'package:flutter/material.dart';

class SystemsPage extends StatefulWidget {
  const SystemsPage({super.key});

  @override
  State<SystemsPage> createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
    final List _categories = ['assets/icons/hvac.png', 'assets/icons/motorizedvalve.png', 'assets/icons/sensors.png', 'assets/icons/valve.png', 'assets/icons/software.png'];

    final List <Map<String, dynamic>> gridProjects = [
      {"title": "System Info #1", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653447224.png"},
      {"title": "System Info #2", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653448162.png"},
      {"title": "System Info #3", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653448199.png"},
      {"title": "System Info #4", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653448274.png"},
      {"title": "System Info #5", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653448353.png"},
      {"title": "System Info #6", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653448438.png"},
      {"title": "System Info #7", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653449023.png"},
      {"title": "System Info #8", "images": "https://enyecontrols.com/ec_cpanel/images/systems/1653458552.png"}
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
              mainAxisExtent: 270,
            ),
            itemCount: gridProjects.length,
            itemBuilder: (context, index){
              return GestureDetector(
                  onTap: (){
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PicNo1()),
                      );
                    }
                    else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo2()),
                      );
                    }
                    else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo3()),
                      );
                    }
                    else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo4()),
                      );
                    }
                    else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo5()),
                      );
                    }
                    else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo6()),
                      );
                    }
                    else if (index == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo7()),
                      );
                    }
                    else if (index == 7) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PicNo8()),
                      );
                    }
                  },

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
                              colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.2)],
                              stops: [0.0,1],
                              begin: Alignment.topCenter,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
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
      );
}
}

