import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userContactController = TextEditingController();
  final TextEditingController _userLocationController = TextEditingController();

  // Flag to control whether to show the form or emergency type selection
  bool _isEmergencyDetailsScreen = false;
  String? _selectedEmergencyType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEmergencyDetailsScreen
            ? Text("$_selectedEmergencyType Details")
            : const Text("Emergency Assistance"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If on emergency type selection screen
            if (!_isEmergencyDetailsScreen) ...[
              const Text(
                "Select Emergency Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildEmergencyOption(
                      context,
                      icon: Icons.local_hospital,
                      label: "Medical Emergency",
                      onTap: () {
                        _navigateToDetails("Medical Emergency");
                      },
                    ),
                    _buildEmergencyOption(
                      context,
                      icon: Icons.security,
                      label: "Theft",
                      onTap: () {
                        _navigateToDetails("Theft");
                      },
                    ),
                    _buildEmergencyOption(
                      context,
                      icon: Icons.people,
                      label: "Brawl/Fight",
                      onTap: () {
                        _navigateToDetails("Brawl/Fight");
                      },
                    ),
                    _buildEmergencyOption(
                      context,
                      icon: Icons.person_search,
                      label: "Lost Person",
                      onTap: () {
                        _navigateToDetails("Lost Person");
                      },
                    ),
                    _buildEmergencyOption(
                      context,
                      icon: Icons.local_fire_department,
                      label: "Fire",
                      onTap: () {
                        _navigateToDetails("Fire");
                      },
                    ),
                    _buildEmergencyOption(
                      context,
                      icon: Icons.error,
                      label: "Other Emergency",
                      onTap: () {
                        _navigateToDetails("Other Emergency");
                      },
                    ),
                  ],
                ),
              ),
            ]
            // If on emergency details form
            else ...[
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                ),
              ),
              TextField(
                controller: _userContactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _userLocationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveEmergencyDetails(
                    _selectedEmergencyType!,
                    _userNameController.text,
                    _userContactController.text,
                    _userLocationController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyOption(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }

  void _navigateToDetails(String emergencyType) {
    setState(() {
      _selectedEmergencyType = emergencyType;
      _isEmergencyDetailsScreen = true;
    });
  }

  Future<void> _saveEmergencyDetails(String emergencyType, String userName,
      String userContact, String userLocation) async {
    try {
      // Add data to Firestore
      await FirebaseFirestore.instance.collection('emergencies').add({
        'emergencyType': emergencyType,
        'userName': userName,
        'userContact': userContact,
        'userLocation': userLocation,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving emergency details: $e");
    }
  }
}
