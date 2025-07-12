import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inbox')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Inbox Messages Will Appear Here',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // You can add a list of messages or notifications here
          ],
        ),
      ),
    );
  }
}
