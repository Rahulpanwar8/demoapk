import 'package:flutter/material.dart';

void showEditProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ..._buildTextFields(['Name', 'Email']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    ),
  );
}

List<Widget> _buildTextFields(List<String> labels) {
  return labels.map((label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }).toList();
}
