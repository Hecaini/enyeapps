import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.0),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
    );
  }
}

class addButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const addButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
    );
  }
}

class editButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const editButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
    );
  }
}

class delButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const delButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
    );
  }
}

