import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demoapk/screens/login_screen.dart';

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // सभी स्टोर किए गए डेटा को क्लियर करें
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),  // 'const' हटा दिया गया
        (route) => false, // सभी पिछले रूट्स को हटा दें
  );
}
