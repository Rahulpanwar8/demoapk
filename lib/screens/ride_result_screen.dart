import 'package:flutter/material.dart';

class RideResultScreen extends StatelessWidget {
  final String rideResult;
  final List<Map<String, dynamic>> rides;

  RideResultScreen({required this.rideResult, required   this.rides});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ride Results")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              rideResult,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 20),
            if (rides.isNotEmpty)
              DataTable(
                columns: [
                  DataColumn(label: Text('Leaving')),
                  DataColumn(label: Text('Going')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Seats')),
                ],
                rows: rides.map((ride) {
                  return DataRow(cells: [
                    DataCell(Text(ride['leaving'])),
                    DataCell(Text(ride['going'])),
                    DataCell(Text(ride['date'])),
                    DataCell(Text(ride['totalPeople'].toString())),
                  ]);
                }).toList(),
              ),
            // If no rides, show a message
            if (rides.isEmpty) Text('No rides found.'),
          ],
        ),
      ),
    );
  }
}
