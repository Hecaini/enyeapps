import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatelessWidget {
  static const String routeName = '/contacts';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ContactsPage()
    );
  }

  Future<void> _launchURL (String url) async{
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Contact Us', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/backgrounds/wallpaper-contacts.png"), fit: BoxFit.fill),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.7), Colors.deepOrange.shade100.withOpacity(0.6)],
              stops: [0.0, 1],
              begin: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                children: [

                  //QUEZON CITY OFFICE DATA
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [

                          //OFFICE LOCATED
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Quezon City Office',
                                style: TextStyle(fontSize: 32, color: Colors.white),
                              ),
                            ),
                          ),

                          //MAPS LOCATION OF OFFICE
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(top: 30.0, left: 20.0),
                              child: TextButton(
                                child: const Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(child: Icon(Icons.location_on, size: 30, )),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '1, 82 Scout Ojeda St., Brgy. Obrero Diliman, Quezon City. 1103 Philippines',
                                        style: TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 1.0, overflow: TextOverflow.visible,),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  _launchURL("https://www.google.com/maps?ll=14.62891,121.028002&z=16&t=m&hl=en&gl=PH&mapclient=embed&cid=10169760891713574313");
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/backgrounds/mapqc.png"), fit: BoxFit.fill),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                _launchURL("https://www.google.com/maps?ll=14.62891,121.028002&z=16&t=m&hl=en&gl=PH&mapclient=embed&cid=10169760891713574313");
                              },
                            ),
                          ),

                          //EMAIL ME
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                              child: TextButton.icon(
                                onPressed: (){
                                  final toEmail  = 'enyecontrols@enyecontrols.com';
                                  final url = 'mailto:$toEmail';

                                  _launchURL(url);
                                },
                                icon: Icon(Icons.mail, size: 25,),
                                label: Text('enyecontrols@enyecontrols.com',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.visible,),
                                ),
                              ),
                            ),
                          ),

                          //Contact Sales Eng.
                          Column(
                            children: [
                              const Text('Sales & Engineering',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      final phoneNumber  = '+63976165949';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    icon: Icon(Icons.call, size: 25,),
                                    label: const Text('+639 7616-5949',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),

                                  Text('/', style: TextStyle(color: Colors.black54,fontSize: 16.0,letterSpacing: 1.0,fontWeight: FontWeight.bold, overflow: TextOverflow.visible,),),

                                  TextButton(
                                    onPressed: (){
                                      final phoneNumber  = '(02)83523250';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    child: const Text('(02) 8352-3250',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),

                          //Procurement & Logistics
                          Column(
                            children: [
                              const Text('Procurement & Logistics',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      final phoneNumber  = '+63972194163';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    icon: Icon(Icons.call, size: 25,),
                                    label: const Text('+639 7219-4163',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),

                                  Text('/', style: TextStyle(color: Colors.black54,fontSize: 16.0,letterSpacing: 1.0,fontWeight: FontWeight.bold, overflow: TextOverflow.visible,),),

                                  TextButton(
                                    onPressed: (){
                                      final phoneNumber  = '(02)83523250';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    child: const Text('(02) 8352-3250',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),

                          //HR, Admin, Accounting
                          Column(
                            children: [
                              const Text('HR, Admin, Accounting',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      final phoneNumber  = '+63972185329';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    icon: Icon(Icons.call, size: 25,),
                                    label: const Text('+639 7218-5329',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),

                                  Text('/', style: TextStyle(color: Colors.black54,fontSize: 16.0,letterSpacing: 1.0,fontWeight: FontWeight.bold, overflow: TextOverflow.visible,),),

                                  TextButton(
                                    onPressed: (){
                                      final phoneNumber  = '(02)83523250';
                                      final url = 'tel:$phoneNumber';

                                      _launchURL(url);
                                    },
                                    child: const Text('(02) 8352-3250',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  //CEBU OFFICE DATA
                  Container(
                    child: Column(
                      children: [

                        //OFFICE LOCATED
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'CEBU Office',
                              style: TextStyle(fontSize: 32, color: Colors.white),
                            ),
                          ),
                        ),

                        //MAPS LOCATION OF OFFICE
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: TextButton(
                              child: const Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.location_on, size: 30, )),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  Lofice 2, Lot 5, Blk 7, Phase 2 Sta. Lucia Town Square Consolacion, Cebu 6001 Philippines',
                                      style: TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 1.0, overflow: TextOverflow.visible,),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/backgrounds/mapcebu.png"), fit: BoxFit.fill),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                            },
                          ),
                        ),

                        //EMAIL ME
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0),
                            padding: EdgeInsets.only(top: 5.0),
                            child: TextButton.icon(
                              onPressed: (){
                                final toEmail  = 'pearlguevarra.enyecontrols@gmail.com';
                                final url = 'mailto:$toEmail';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.mail, size: 25,),
                              label: Text('pearlguevarra.enyecontrols@gmail.com',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,),
                              ),
                            ),
                          ),
                        ),

                        //Contact
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0),
                            child: TextButton.icon(
                              onPressed: (){
                                final phoneNumber  = '(+032)4231759';
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: 25,),
                              label: const Text('(+032) 423-1759',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  //LAGUNA OFFICE DATA
                  Container(
                    child: Column(
                      children: [

                        //OFFICE LOCATED
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'LAGUNA Office',
                              style: TextStyle(fontSize: 32, color: Colors.white),
                            ),
                          ),
                        ),

                        //MAPS LOCATION OF OFFICE
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 30.0, left: 20.0),
                            child: TextButton(
                              child: const Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.location_on, size: 30, )),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Lofice 3, Lot 6, Blk 17, Pacita Ave Pacita Complex, San Vicente San Pedro, Laguna 4023 Philippines',
                                      style: TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 1.0, overflow: TextOverflow.visible,),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/backgrounds/mapcebu.png"), fit: BoxFit.fill),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                            },
                          ),
                        ),

                        //EMAIL ME
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0),
                            padding: EdgeInsets.only(top: 5.0),
                            child: TextButton.icon(
                              onPressed: (){
                                final toEmail  = 'janice.capinpin@enyecontrols.com';
                                final url = 'mailto:$toEmail';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.mail, size: 25,),
                              label: Text('janice.capinpin@enyecontrols.com',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,),
                              ),
                            ),
                          ),
                        ),

                        //Contact
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0),
                            child: TextButton.icon(
                              onPressed: (){
                                final phoneNumber  = '+639171387049';
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: 25,),
                              label: const Text('(+63) 917 138-7049',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              //dot controller of pageview
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: ExpandingDotsEffect(dotColor: Colors.orange, activeDotColor: Colors.deepOrange),
                        onDotClicked: (index) => _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.bounceOut,),
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

