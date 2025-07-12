import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import


import 'package:demoapk/screens/login_screen.dart';
import 'package:demoapk/screens/home_screen.dart'; // Home screen import
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with error handling
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully with Firestore.");

  } catch (e) {
    print("Error initializing Firebase: $e");
    // Handle Firebase initialization failure (e.g., show error screen or exit)
  }

  // Request notification permission
  await requestNotificationPermission();

  runApp(MyApp());
}

// Request notification permission
Future<void> requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;
  if (!status.isGranted) {
    // Request notification permission if not granted
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Initial route
      routes: {
        '/': (context) => LoginScreen(), // Login screen as initial
        '/home': (context) => HomeScreen(), // Home screen after login
      },
    );
  }
}
