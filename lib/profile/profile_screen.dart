import 'package:flutter/material.dart';
import 'profile_details_screen.dart'; // Import ProfileDetailsScreen
import 'rating_screen.dart';
import 'password_screen.dart';
import 'help_screen.dart';
import 'logout.dart';
import 'profile_header.dart';

class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Profile', 'icon': Icons.person},
    {'title': 'Rating', 'icon': Icons.star},
    {'title': 'Password', 'icon': Icons.lock},
    {'title': 'Help', 'icon': Icons.help},
    {'title': 'Logout', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ProfileHeader(), // Profile Header Widget
            const SizedBox(height: 20),
            Expanded(child: _buildMenuList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          leading: Icon(item['icon'], color: Colors.blueAccent),
          title: Text(
            item['title'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            if (item['title'] == 'Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileDetailsScreen()),
              );
            } else if (item['title'] == 'Logout') {
              logout(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  switch (item['title']) {
                    case 'Rating':
                      return RatingScreen();
                    case 'Password':
                      return PasswordScreen();
                    case 'Help':
                      return HelpScreen();
                    default:
                      return Container(); // Fallback screen
                  }
                }),
              );
            }
          },
        );
      },
    );
  }
}
