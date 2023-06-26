import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => HomePage()
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final List<String> imgList = [
    'assets/homepage/pix1.png',
    'assets/homepage/pix2.png',
    'assets/homepage/pix3.png',
    'assets/homepage/pix4.png',
    'assets/homepage/pix5.png',
    'assets/homepage/pix6.png',
    'assets/homepage/pix6.2.png',
    'assets/homepage/pix6.3.png',
    'assets/homepage/pix7.png',
    'assets/homepage/pix8.png',
    'assets/homepage/pix9.png',
    'assets/homepage/pix10.png',
    'assets/homepage/pix11.png',
  ];

  double getRadiansFromDegree (double degree){
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  late AnimationController animationController;
  late Animation degOneTranslationAnimation;
  late Animation rotationAnimation;

  void initState(){
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
        /*drawer: CustomDrawer(),*/
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Stack(
            children: [
              CarouselSlider(
                items: imgList.map((item) => Container(
                  margin: const EdgeInsets.all(.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      item,
                      fit: BoxFit.fill,
                    ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: 470,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
              ),

              Positioned(
                  right: 10,
                  bottom: 5,
                  child: Stack(
                    children: <Widget> [

                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(180), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: (){},
                            icon: Image.asset("assets/icons/facebook-v2.png",),
                            iconSize: 43,
                            enableFeedback: true,
                          ),
                        ),
                      ),

                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(210), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: (){},
                            icon: Image.asset("assets/icons/instagram.png"),
                            iconSize: 43,
                            enableFeedback: true,
                          ),
                        ),
                      ),

                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(240), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () async {
                              _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                            },
                            icon: Image.asset("assets/icons/twitter.png"),
                            iconSize: 43,
                            enableFeedback: true,
                          ),
                        ),
                      ),

                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: (){},
                            icon: Image.asset("assets/icons/youtube-round-2.png"),
                            iconSize: 43,
                            enableFeedback: true,
                          ),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(color: Colors.deepOrange.shade100, shape: BoxShape.circle),
                        width: 60,
                        height: 60,
                        child: IconButton(
                          icon: ImageIcon(AssetImage("assets/icons/social-media.png"), color: Colors.deepOrange, size: 50,),
                          enableFeedback: true,
                          onPressed: (){
                            if(animationController.isCompleted){
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                          },
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }
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