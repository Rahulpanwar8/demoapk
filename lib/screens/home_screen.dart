import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'find_ride.dart'; // Rider screen
import 'offer_ride.dart'; // Driver screen
import 'your_rides_screen.dart'; // Your Ride screen
import 'inbox_screen.dart'; // Inbox screen
import '../profile/profile_screen.dart'; // Profile screen

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> buttons = [
    {'icon': Icons.person, 'label': 'Find Ride', 'color': Colors.blue, 'screen': FindRide()},
    {'icon': Icons.add_circle_outline, 'label': 'Offer Ride', 'color': Colors.green, 'screen': OfferRide()},
    {'icon': Icons.directions_car, 'label': 'Your Rides', 'color': Colors.orange, 'screen': YourRideScreen()},
    {'icon': Icons.inbox, 'label': 'Inbox', 'color': Colors.purple, 'screen': InboxScreen()},
    {'icon': Icons.account_circle, 'label': 'Profile', 'color': Colors.teal, 'screen': ProfileScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Please login first"));
          }

          final user = snapshot.data;

          if (user != null && !user.emailVerified) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please verify your email first.", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verification email sent!')),
                      );
                    },
                    child: Text("Resend Verification Email"),
                  ),
                ],
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Welcome, ${user?.email ?? 'User'}!",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text("Choose your option", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                height: 90,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buttons.map((button) {
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => button['screen'])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIcon(button),
                          SizedBox(height: 5),
                          Text(button['label'], style: TextStyle(color: button['color'], fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIcon(Map<String, dynamic> button) {
    return Icon(button['icon'], size: 35, color: button['color']);
  }
}
