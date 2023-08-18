import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const NormalTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400)
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
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
          prefixIcon: Icon(Icons.lock),
          suffixIcon: InkWell(
            onTap: (){
              setState((){
                passToggle = !passToggle;
              });
            },
            child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400)
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
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
          prefixIcon: Icon(Icons.email),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
            fillColor: Colors.deepOrange.shade50,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400)
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
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
            prefixIcon: Icon(Icons.person),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
            fillColor: Colors.deepOrange.shade50,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400)
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
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
            prefixIcon: Icon(Icons.call),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
            ),
            fillColor: Colors.deepOrange.shade50,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400)
        ),
      ),
    ) ;
  }
}
