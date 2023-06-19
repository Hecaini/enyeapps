import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const Center(child: Text("About Page",
        style: TextStyle(fontSize: 24.0, color: Colors.deepOrange, fontWeight: FontWeight.bold),),),
    );
  }
}

