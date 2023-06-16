import 'package:flutter/material.dart';

class SocialmediaPage extends StatelessWidget {
  const SocialmediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text("Social Media"),
        ),

        Center(
          child: Text(
            "Company Profile Page",
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}