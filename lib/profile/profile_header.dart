import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String userName = 'Rahul Panwar';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();  // Load saved profile on app startup
  }

  // Load saved username and profile image from SharedPreferences
  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Rahul Panwar'; // Default name
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);  // Load the saved profile image
      }
    });
  }

  // Save the updated profile name and image to SharedPreferences
  void _saveProfile({bool isName = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isName) {
      prefs.setString('userName', userName); // Save the updated name
    } else {
      prefs.setString('profileImage', profileImage?.path ?? ''); // Save the profile image path
    }
  }

  // Function to handle name or profile image update
  void updateProfile({bool isName = false}) async {
    if (isName) {
      final TextEditingController nameController = TextEditingController(text: userName);
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Enter your name')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () {
              setState(() => userName = nameController.text);
              _saveProfile(isName: true);  // Save name to SharedPreferences
              Navigator.pop(context);
            }, child: const Text('Save')),
          ],
        ),
      );
    } else {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
          _saveProfile();  // Save the profile image path to SharedPreferences
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => updateProfile(), // Trigger profile image update
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueAccent,
            backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
            child: profileImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => updateProfile(isName: true)),
          ],
        ),
      ],
    );
  }
}
