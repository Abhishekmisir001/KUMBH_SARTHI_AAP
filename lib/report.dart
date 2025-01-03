import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  XFile? _pickedImage;

  String _currentReportType = "Lost"; // Toggle between "Lost" and "Found"

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image;
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      await storageRef.putFile(File(image.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (_pickedImage != null) {
        imageUrl = await _uploadImage(_pickedImage!);
      }

      final report = {
        'name': _nameController.text.trim(),
        'location': _locationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'image': imageUrl,
        'type': _currentReportType,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final collection = FirebaseFirestore.instance.collection(_currentReportType.toLowerCase());
      await collection.add(report);

      setState(() {
        _nameController.clear();
        _locationController.clear();
        _phoneController.clear();
        _pickedImage = null;
      });

      if (_currentReportType == "Found") {
        _checkAndMoveReport(report);
      }
    }
  }

  Future<void> _checkAndMoveReport(Map<String, dynamic> foundReport) async {
    final lostCollection = FirebaseFirestore.instance.collection('lost');
    final querySnapshot = await lostCollection.where('name', isEqualTo: foundReport['name']).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete(); // Remove from lost
      await FirebaseFirestore.instance.collection('found').add(foundReport); // Add to found
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchReports(String type) {
    return FirebaseFirestore.instance
        .collection(type.toLowerCase())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found Reporting'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle between Lost and Found forms
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Lost'),
                  selected: _currentReportType == "Lost",
                  onSelected: (selected) {
                    setState(() {
                      _currentReportType = "Lost";
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Found'),
                  selected: _currentReportType == "Found",
                  onSelected: (selected) {
                    setState(() {
                      _currentReportType = "Found";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name/Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name or description.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: _currentReportType == "Lost" ? 'Last Seen Location' : 'Found Location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Your Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number.';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text('Attach Image'),
                  ),
                  if (_pickedImage != null) ...[
                    const SizedBox(height: 16),
                    Image.file(
                      File(_pickedImage!.path),
                      height: 150,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Submit $_currentReportType Report'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reports List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _fetchReports(_currentReportType),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading reports.'));
                  }

                  final reports = snapshot.data ?? [];
                  if (reports.isEmpty) {
                    return const Center(child: Text('No reports found.'));
                  }

                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: report['image'] != null
                              ? Image.network(report['image'], width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.person),
                          title: Text(report['name'] ?? 'No Name'),
                          subtitle: Text('Location: ${report['location']}'),
                          trailing: Text('Phone: ${report['phone']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
