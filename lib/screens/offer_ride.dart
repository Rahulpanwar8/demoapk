import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferRide extends StatefulWidget {
  @override
  _OfferRideState createState() => _OfferRideState();
}

class _OfferRideState extends State<OfferRide> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection('rides');

  final _leaving = TextEditingController();
  final _going = TextEditingController();

  Future<void> _createRide() async {
    if (_leaving.text.isEmpty || _going.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all fields!')));
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not authenticated!')));
      return;
    }

    final uid = user.uid;

    try {
      final rideRef = _db.doc(); // Generates unique ride ID

      await rideRef.set({
        'rideId': rideRef.id,
        'userId': uid,
        'leavingFrom': _leaving.text.toLowerCase(),
        'goingTo': _going.text.toLowerCase(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ride created successfully!')));
      _leaving.clear();
      _going.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create ride: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offer Ride"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Offer a Ride", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 20),
            _inputField(_leaving, 'Leaving From', TextInputType.text),
            SizedBox(height: 20),
            _inputField(_going, 'Going To', TextInputType.text),
            SizedBox(height: 30),
            ElevatedButton(onPressed: _createRide, child: Text('Offer Ride'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController? controller, String label, TextInputType inputType) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
    );
  }
}
