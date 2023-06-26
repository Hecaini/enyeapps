import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/screens/screens.dart';

class detailedProjPage extends StatelessWidget {
  static const String routeName = '/detailedproj';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => detailedProjPage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final filteredProjects = ModalRoute.of(context)?.settings?.arguments as Map<String, String>;
    final projId = filteredProjects['projId'].toString();

    List<Projects> detailedProjects = [];

    detailedProjects = projectList.where((projectList) => projectList.proj_id == projId).toList();

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'ENYE CONTROLS', imagePath: 'assets/logo/enyecontrols.png',),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("${detailedProjects[0].images}"), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.2)],
              stops: [0.0, 1],
              begin: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              //PROJECT TITLE
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Text(
                    "${detailedProjects[0].title}",
                    style: TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),

              //PROJECT DESCRIPTION 1
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.all(17.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Text(
                    "${detailedProjects[0].description1}",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 2.0,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


              //PROJECT DESCRIPTION 2
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "${detailedProjects[0].description2}",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2.0,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}