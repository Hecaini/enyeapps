import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class CompletedPage extends StatelessWidget {
  static const String routeName = '/quotation';

  const CompletedPage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const CompletedPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Completed', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Center(
        child: (Text(
          "Completed Page",
          style: TextStyle(
              fontSize: 40,
              color: Colors.grey
          ),
        )),
      ),
    );
  }
}

