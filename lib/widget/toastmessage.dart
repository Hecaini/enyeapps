import 'package:flutter/material.dart';

class successToast extends StatelessWidget {

  const successToast({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Row(
        children: [
          Icon(Icons.check, color: Colors.green,),
          Text("Sample Message"),
        ],
      ),
    );
  }
}