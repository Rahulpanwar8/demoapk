import 'package:flutter/material.dart';

class YourRideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Ride')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Ride Information Goes Here',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Add more widgets for ride-related details if necessary
          ],
        ),
      ),
    );
  }
}
