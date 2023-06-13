import 'package:flutter/material.dart';

class SystemsPage extends StatefulWidget {
  const SystemsPage({super.key});

  @override
  State<SystemsPage> createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Systems Page'),
      ),
    );
  }
}

