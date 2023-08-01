import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String imagePath;


  const CustomAppBar({
    super.key,
    required this.title,
  required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle;

    if (imagePath.isNotEmpty) {
      appBarTitle = Image.asset(imagePath);
    } else {
      appBarTitle = Text(title, style: TextStyle(color: Colors.white));
    }

    return AppBar(

      backgroundColor: Colors.deepOrange,
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        /*IconButton(onPressed: () {}, icon: Icon(Icons.favorite))*/
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}