import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindRide extends StatefulWidget {
  @override
  _FindRideState createState() => _FindRideState();
}

class _FindRideState extends State<FindRide> {
  final _leavingController = TextEditingController();
  final _goingController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _rideList = [];

  // Function to search for rides based on user input
  Future<void> _searchRide() async {
    setState(() => _isLoading = true);  // Set loading state to true
    final firestore = FirebaseFirestore.instance;

    try {
      // Capture input values and clean them (trim spaces and lowercase)
      String leavingFromInput = _normalizeText(_leavingController.text);
      String goingToInput = _normalizeText(_goingController.text);

      QuerySnapshot querySnapshot;

      // Perform query based on input or fetch all rides if fields are empty
      if (leavingFromInput.isNotEmpty && goingToInput.isNotEmpty) {
        querySnapshot = await firestore
            .collection('rides')
            .get(); // Fetch all rides since Firestore does not support fuzzy search
      } else {
        // If no inputs, fetch all rides
        querySnapshot = await firestore.collection('rides').get();
      }

      _rideList.clear();

      // Parse the query result and filter if needed
      for (var document in querySnapshot.docs) {
        final ride = document.data();
        if (ride != null && ride is Map<String, dynamic>) {
          String leavingFrom = _normalizeText(ride['leavingFrom'] ?? '');
          String goingTo = _normalizeText(ride['goingTo'] ?? '');
          String rideId = ride['rideId'] ?? '';  // Ensure the 'rideId' field is available
          
          // Check for partial match with a tolerance for typos and spaces
          if (_isPartialMatch(leavingFrom, leavingFromInput) &&
              _isPartialMatch(goingTo, goingToInput)) {
            _rideList.add({
              'leavingFrom': ride['leavingFrom'],
              'goingTo': ride['goingTo'],
              'rideId': ride['rideId'],
              'userId': ride['userId'],
            });
          }
        }
      }

      print("Rides Found: ${_rideList.length}");
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() => _isLoading = false);  // Set loading state to false
    }
  }

  // Normalize text by trimming spaces and converting to lowercase
  String _normalizeText(String text) {
    return text.trim().toLowerCase();
  }

  // Function to check partial match with tolerance for typos and spaces
  bool _isPartialMatch(String data, String query) {
    return data.contains(query); // Basic substring matching
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Ride")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Leaving From input field
                _inputField(_leavingController, 'Leaving From'),
                SizedBox(height: 10),
                // Going To input field
                _inputField(_goingController, 'Going To'),
                SizedBox(height: 20),
                // Search button
                ElevatedButton(
                  onPressed: _searchRide,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Search Ride"),
                ),
              ],
            ),
          ),
          // Display search results in a list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _rideList.length,
              itemBuilder: (context, index) {
                final ride = _rideList[index];
                return ListTile(
                  title: Text('${ride['leavingFrom']} -> ${ride['goingTo']}'),
                  subtitle: Text('Ride ID: ${ride['rideId']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Input field widget with controller and label
  Widget _inputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
