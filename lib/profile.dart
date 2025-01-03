import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String? profilePictureUrl;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePictureUrl, required String userId,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String email;
  late String phone;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    phone = widget.phone;
    profilePictureUrl = widget.profilePictureUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Pops the current screen and navigates back
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Profile Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl!)
                        : const AssetImage('assets/placeholder.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                // Name and Welcome
                Text(
                  "Hello, $name!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.orange),
                              const SizedBox(width: 10),
                              Text(email, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.orange),
                              const SizedBox(width: 10),
                              Text(phone, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Change Picture Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {
                          setState(() {
                            profilePictureUrl = image.path;
                          });
                          // Optionally upload to Firebase Storage
                          print('New image path: ${image.path}');
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Change Picture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Edit Profile Button
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            // Controllers to pre-fill user data
                            final nameController =
                                TextEditingController(text: name);
                            final emailController =
                                TextEditingController(text: email);
                            final phoneController =
                                TextEditingController(text: phone);

                            return AlertDialog(
                              title: const Text('Edit Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context), // Cancel
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Update state
                                    setState(() {
                                      name = nameController.text.trim();
                                      email = emailController.text.trim();
                                      phone = phoneController.text.trim();
                                    });

                                    Navigator.pop(context); // Close dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Profile updated successfully!'),
                                      ),
                                    );
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
