import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXExtraSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((screenWidth + screenHeight) / 90),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: fontXExtraSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8
              ),
            ),
          ),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXExtraSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((screenWidth + screenHeight) / 90),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: fontXExtraSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8
              ),
            ),
          ),
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
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXExtraSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((screenWidth + screenHeight) / 90),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontExtraSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
                color: Colors.white
            ),
          ),),
        ),
      ),
    );
  }
}

