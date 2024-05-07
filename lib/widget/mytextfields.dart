import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

class NormalTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const NormalTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: TextFormField(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: fontNormalSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2
          ),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          }
          return null;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontNormalSize,
                color: Colors.grey.shade400,
                letterSpacing: 1.2
            ),
          ),
        ),
      ),
    ) ;
  }
}

class PasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const PasswordTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: TextFormField(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: fontNormalSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2
          ),
        ),
        readOnly: widget.disabling,
        onEditingComplete: (){},
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (value.length < 6) {
            return 'Contains at least 6 characters !';
          } else {
            return null;
          }
        },
        controller: widget.controller,
        obscureText: passToggle,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: InkWell(
            onTap: (){
              setState((){
                passToggle = !passToggle;
              });
            },
            child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontNormalSize,
                color: Colors.grey.shade400,
                letterSpacing: 1.2
            ),
          ),
        ),
      ),
    ) ;
  }
}

class EmailTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const EmailTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: TextFormField(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: fontNormalSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2
          ),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (EmailValidator.validate(value) == false) {
            return 'Please enter valid email';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
            fillColor: Colors.deepOrange.shade50,
            filled: true,
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: fontNormalSize,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.2
              ),
            ),
        ),
      ),
    ) ;
  }
}

class PersonNameTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const PersonNameTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: TextFormField(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: fontNormalSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2
          ),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontNormalSize,
                color: Colors.grey.shade400,
                letterSpacing: 1.2
            ),
          ),
        ),
      ),
    ) ;
  }
}

class ContactTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const ContactTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {
    String patttern = r'(^(?:[+0]9)?[0-9]{11,12}$)';
    RegExp regExp = new RegExp(patttern);

    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: TextFormField(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: fontNormalSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2
          ),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (!regExp.hasMatch(value)) {
            return 'Please enter valid mobile number';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.call),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontNormalSize,
                color: Colors.grey.shade400,
                letterSpacing: 1.2
            ),
          ),
        ),
      ),
    ) ;
  }
}
