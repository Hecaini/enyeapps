import 'package:enye_app/navbar/navbar.dart';
import 'package:enye_app/pages/home.dart';
import 'package:enye_app/sample_form/systemsform.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavBarStay extends StatefulWidget {
  const NavBarStay({super.key});

  @override
  State<NavBarStay> createState() => NavBarStays();
}

class NavBarStays extends State<NavBarStay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
          SliverAppBar(
           leading: GestureDetector(
             onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
             },
             child: Icon(Icons.arrow_back),
           ),

          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child:
                          Image.asset('images/images_1/pix1.png', fit: BoxFit.cover),
                    ),
                  ),

            ),
          ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"   -This system is specifically designed to control temperature by controlling the volume of chilled water inside the pipe. It maintains the temperature based from set point by calculating the output position based on the proven PI control algorithms. For monitoring purposes, displays both for the temperature reading and set point are provided."',
                style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System2 extends StatelessWidget {
  const System2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                    Image.asset('images/images_1/pix2.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -Intelligent VAV System (I-VAV) is a systematic approach to the existing system that will enhance functionality and efficiency. The intention is to synchronize the mechanical portion (AHU, VAV, etc...) and the controls portion (temperature, pressure, airflow, etc...) to produce one stand-alone system that is BMS ready and deliver (a) comfort (b) efficiency (c) savings."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System3 extends StatelessWidget {
  const System3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix3.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"     -The ENYE Water By-pass system is specifically designed to control & monitor differential pressure between the supply and the return in a close circuit water system. Thru the PID system, the intelligent stand-alone controller measures the differential pressure then modulates the motorized valve in order to meet the user set point. Differential pressure readings and user set point values can be seen in the LCD display of the controller for monitoring and recording purposes."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System4 extends StatelessWidget {
  const System4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix4.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"     -The ENYE Temperature and Humidity Control and Monitoring System are specifically designed to control temperature by controlling the volume of chilled water or cold air and at the same time controls the room humidity by controlling the duct heaters or the volume of hot water. The system maintains the temperature and control algorithms. For monitoring purposes, displays both for the temperature and humidity setpoints are provided. Supported by Multi-Function technology, It allows the parameters to be programmed, tailor-fitted to the designers choice of system. Parameters such as control signals, cascade controls, proportional band(heating/cooling), application even user interface capabilities can be adjusted."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System5 extends StatelessWidget {
  const System5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix5.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The Enye Intelligent Fan Coil Control and Monitoring System is designed to control and monitor fan coil system with up to three fan speeds. The fan speeds may be controlled to run manually or in automatic mode, wherein the fan speed will automatically change according to the temperature difference of room temperature and setpoint. For monitoring purposes, displays both for the temperature reading and setpoint are provided. Supported by Multi-Function Technology, it allows the user and control parameters to be programmed, tailor-fitted to the designer’s choice of system."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System6 extends StatelessWidget {
  const System6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix6.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The ENYE Fire & Smoke Protection system is specifically designed to prevent fire & smoke passing thru the building’s air duct on which will endanger life and properties as well. During fire mode, the system move the fire & smoke dampers to a safety position as per designed - either close or open position."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System66 extends StatelessWidget {
  const System66({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix6.2.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The ENYE Stairwell Pressurization system is pecifically designed to control & monitor differential pressure between the stairway and inside the building. This is to ensure positive pressure in the stairway thus assuring safe passage of the building tenants during fire emergency. The intelligent stand-alone controller measures the differential pressure then controls (on/off or via VFD interface ) the stairwell pressurization fan in order to meet the required set point. Differential pressure readings and set point values can be seen in the LCD display of the controller for monitoring and recording purposes. Our technology emphasizes on flexibility allowing our system to adapt to the design and user requirement. Programs for the control’s parameters and user’s interface can only be accessed by authorized personnel."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System666 extends StatelessWidget {
  const System666({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix6.3.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The ENYE Smoke Extraction System is pecifically designed to extract large quantities of smoke and poisonous fumes in order for building tenants and fire rescuers to have clear access thru the escape routes. During fire mode, the system move the smoke extraction dampers to a safety position as per designed - either close or open position, and simultaneously turning on the smoke extraction fans."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System7 extends StatelessWidget {
  const System7({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix7.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"     -The Enye’s Carbon Dioxide Control and Monitoring System is specially designed to monitor carbon dioxide in a given area. Today, most of the building owners and designers are aware on the green building design on HVAC. One of the requirements of the green building is having a carbon dioxide control and monitoring system. According to ASHREA ADDENDA (Ventilation for Acceptable Indoor Air Quality) the enforceable to OSHA (Occupational Safety and Health Administration) the allowable carbon dioxide for indoor application is 5,000 ppm. Enye provides CO and Temperature Control & Monitoring System to protect the building tenants/public from being expose to CO since Carbon Monoxide is colorless, odorless gas it cannot be easily detect. Nevertheless, it also monitors Temperature on each zone to minimized high temperature reading for comfort."',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System8 extends StatelessWidget {
  const System8({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix8.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The Enye Water Leak Detection System is designed to detect and notify building engineers or administrators on water leak alarm in a specific area. The installation of water leak detection systems is install more common place in most new commercial office construction schemes along with the more obvious targets of main frames, Servers, Control Room, Data Center and Computer Rooms."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System9 extends StatelessWidget {
  const System9({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix9.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -The ENYE Intelligent Stand-alone Direct Digital Controller is specifically designed for standalone application on which can be networked into full Building Management system. Equipped with multifunction technology that allows a controller or any active/passive HVAC equipment to be programmed to adapt to the actual requirement. This allows the end-user to tailor-fit the system to the actual site/project condition by continually re-programming thus offering more flexibility."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System10 extends StatelessWidget {
  const System10({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix10.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -Safety is the number one concern of most companies involved in handling fuels.So if your business involves diesel fuel day tanks, fuel storage tanks, etc. which are potential sources of fuel leaks, you need to consider the possibility of a leak. Enyecontrols Fuel Leak Detection and Alarm System is designed for indoor and outdoor use wherever diesel fuel or other hydrocarbon based liquids are stored or pumped. There are no special tools needed for installation and the system is designed for immediate and simple operation & maintenance by the user."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class System11 extends StatelessWidget {
  const System11({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemsForm(),));
            },
            child: Icon(Icons.arrow_back),
          ),
          // title: Image.asset("images/logo/enyecontrols.png", height: 30),
          backgroundColor: Colors.deepOrange,
          expandedHeight: 100,
          floating: true,
          pinned: true,
          flexibleSpace: const FlexibleSpaceBar(
            //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
            //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
            title: Text(
              'SYSTEMS OF ENYECONTROLS',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                decorationColor: Colors.red,
                decorationThickness: 5.0,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(15.0),
                child:
                Image.asset('images/images_1/pix11.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 400,
                color: Colors.transparent,
                margin: EdgeInsets.all(15.0),
                child: const Text(
                  '"    -Enyecontrols Seismic Monitoring and Alarm System package is specially designed to monitor seismic activity in the building. The system is composed of highly precised, servo balance accelerometers and multifunction networkable stand-alone controller. It monitors seismic activities 24/7. Unlike other accelerometers, Enyecontrols-Althen operates as a closed-loop torque balance servo system. A mass acts like a pendulum that develops a torque proposal to the product of its mass unbalance and the applied acceleration."',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}



