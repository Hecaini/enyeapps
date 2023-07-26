import 'package:enye_app/main.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => DashboardPage()
    );
  }

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: [
                  GestureDetector(
                    onTap: (){
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: CatalogsFilePage.routeName,),
                        screen: CatalogsFilePage(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.orange[200],
                      ), //no function??nasasapawan ng pictures
                      child: Column(
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/icons/catalogs_dashboard.png"),),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Text(
                                "Catalogs",
                                style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      await SessionManager().destroy();

                      setState(() {

                        /*PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: loginPage(),
                          withNavBar: false,
                        );*/
                        Navigator.pushNamedAndRemoveUntil(context, "/navbar",
                            ModalRoute.withName("/"));
                        /*Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                            builder: (BuildContext context) {
                               loginPage();
                            },
                          ),
                              (_) => false,
                        );*/
                      });

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.orange[200],
                      ), //no function??nasasapawan ng pictures
                      child: Column(
                        children: [
                          /*Container(
                            height: 75,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/icons/catalogs_dashboard.png"),),
                            ),
                          ),*/

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Text(
                                "LOGOUT",
                                style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

