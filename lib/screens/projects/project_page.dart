import 'package:enye_app/screens/screens.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ProjectsPage extends StatefulWidget {
  static const String routeName = '/projects';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProjectsPage()
    );
  }

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String selectedCategory = 'ALL';

  List<Projects> filteredProjects = [];

  void initState() {
    super.initState();
    // Initially, show all products
    filteredProjects = projectList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'Projects', imagePath: '',),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(12.0),
          child: Column(
            children: [

              //project categories
              Container(
                height: 110,
                width: MediaQuery.of(context).size.width * 1,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: 120,
                  ),
                  itemCount: projCategoriesList.length,
                  itemBuilder: (context, index){
                    return
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = projCategoriesList[index].category;
                            filterProjects();
                          });
                        },
                        child: Column(
                          children: [
                            Image.asset("${projCategoriesList[index].images}",
                              color: Colors.deepOrange.shade400,
                              height: 55,
                              width: 55,
                              alignment: Alignment.center,),

                            Text("${projCategoriesList[index].title}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,),
                          ],
                        ),
                      );

                    /*Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.deepOrange.shade100, width: 1.0,),
                          left: BorderSide(color: Colors.deepOrange.shade100, width: 1.0,),
                        ),
                      ),
                      child: Column(
                        children: [
                          Image.asset("${gridProjCategories.elementAt(index)['images']}", color: Colors.deepOrange.shade400, height: 50, width: 50,),

                          Expanded(
                            child: TextButton(
                                child: Text(
                                  "${gridProjCategories.elementAt(index)['title']}",
                                  style: TextStyle(fontSize: 12.0, color: Colors.deepOrange.shade400, fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: (){
                                  filteredProjects;
                                },
                            ),
                          )
                        ],
                      )
                    );*/
                  },
                ),
              ),

              //project items
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  mainAxisExtent: 270,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index){

                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: detailedProjPage.routeName, arguments: {'projId': filteredProjects[index].proj_id}),
                          screen: detailedProjPage(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      });
                    },
                    child: Container(
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
                                image: DecorationImage(image: NetworkImage("${filteredProjects[index].images}"), fit: BoxFit.cover),
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
                                      "${filteredProjects[index].title}",
                                      style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void filterProjects() {
    if (selectedCategory == 'ALL') {
      filteredProjects = projectList;
    } else {
      filteredProjects =
          projectList.where((projectList) => projectList.category == selectedCategory).toList();
    }
  }
}