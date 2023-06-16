import 'package:flutter/material.dart';

import 'about.dart';

class CompProfilePage extends StatelessWidget {
  CompProfilePage({super.key});

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _compNavigatorKey,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Company Profile"),
        ),

        const Center(
          child: Text(
            "Company Profile Page",
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        TextButton(
          child: const Text("Go to about page"),
          onPressed: () => Navigator.pushNamed(context, '/about'),
        ),
      ],
    );
  }
}

class _companyNavigator extends StatefulWidget {
  const _companyNavigator();

  @override
  _compNavigatorState createState() => _compNavigatorState();
}

GlobalKey<NavigatorState> _compNavigatorKey = GlobalKey<NavigatorState>();

class _compNavigatorState extends State<_companyNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _compNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/about") {
                return const AboutPage();
              } else {
                return CompProfilePage();
              }
            });
      },
    );
  }
}