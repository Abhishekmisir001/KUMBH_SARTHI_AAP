import 'package:flutter/material.dart';
import 'package:kumbh_sarthi/privacysetting.dart';
import 'package:provider/provider.dart'; // Import provider for theme management
import 'theme_manager.dart'; // Make sure ThemeManager is properly imported
import 'main.dart'; // Import the SignupScreen widget

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.orange.withOpacity(0.2),
                hoverColor: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.dark_mode, color: Colors.orange),
                      const SizedBox(width: 10),
                      const Text(
                        'Dark Mode',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Switch(
                        value: themeManager.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          // Toggle the theme mode
                          themeManager.toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Language Preferences Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.blue.withOpacity(0.2),
                hoverColor: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.blue),
                      const SizedBox(width: 10),
                      const Text(
                        'Language',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                        items: languages
                            .map<DropdownMenuItem<String>>(
                                (String language) => DropdownMenuItem<String>(
                                      value: language,
                                      child: Text(language),
                                    ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Privacy Settings Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  // Navigate to Privacy Settings Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacySettingsScreen()),
                  );
                },
                splashColor: Colors.green.withOpacity(0.2),
                hoverColor: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        'Privacy Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SignupScreen()), // Navigate to SignupScreen
                              (route) => false, // Remove all routes
                            );
                          },
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  );
                },
                splashColor: Colors.red.withOpacity(0.2),
                hoverColor: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
