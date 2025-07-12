import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Screen'),
      ),
      body: const Center(
        child: Text('This is the Help screen'),
      ),
    );
  }
}
