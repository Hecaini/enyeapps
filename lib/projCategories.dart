import 'package:flutter/material.dart';

class projCategories extends StatelessWidget {
  final String iconShow;

  projCategories({required this.iconShow});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange[100]),
        child: Image(image: AssetImage(iconShow), color: Colors.orange[800],),
      ),
    );
  }
}
