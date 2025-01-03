// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:kumbh_sarthi/login.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_manager.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kumbh_sarthi/firebase_options.dart';
import 'package:kumbh_sarthi/chat.dart';
import 'package:kumbh_sarthi/map.dart';
import 'package:kumbh_sarthi/nearbyservices.dart';
import 'package:kumbh_sarthi/profile.dart';
import 'package:kumbh_sarthi/rate.dart';
import 'package:kumbh_sarthi/realtime.dart';
import 'package:kumbh_sarthi/report.dart';
import 'package:kumbh_sarthi/setting.dart';
import 'package:kumbh_sarthi/sos.dart';

import 'firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // bindings  initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(), //  ThemeManager instance
      child: const KumbhSarthiApp(),
    ),
  );
}

class KumbhSarthiApp extends StatelessWidget {
  const KumbhSarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      title: 'Kumbh Sarthi',
      theme: ThemeData.light(), 
      darkTheme: ThemeData.dark(), 
      themeMode: themeManager.themeMode, 
      home: const WelcomeScreen(), 
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> checkLoginStatus(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Retrieve user details from SharedPreferences
      final String userName = prefs.getString('userName') ?? 'Guest';
      final String userEmail =
          prefs.getString('userEmail') ?? 'guest@example.com';
      final String phone = prefs.getString('phone') ?? '0000000000';

      // Navigate to MainScreen with user details
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            userName: userName,
            userEmail: userEmail,
            userPhone: phone,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check login status on widget load
    checkLoginStatus(context);

    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/logo3.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Kumbh Sarthi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    // handle user sign-up and Firestore data storage
    void signupUser(
        String name, String email, String password, String phone) async {
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fields')),
        );
        return;
      }

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password must be at least 6 characters long')),
        );
        return;
      }

      try {
      
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the user ID (UID) after successful sign-up
        String uid = userCredential.user!.uid;

        // Saving additional data (name, phone, email) in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Saving login status and user details in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userName', name);
        await prefs.setString('userEmail', email);
        await prefs.setString('phone', phone);

        // Navigate to the MainScreen and pass the user's data
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    userName: name,
                    userEmail: email,
                    userPhone: phone,
                  )),
          (Route<dynamic> route) => false, // Clear all routes from the stack
        );

        // Showing success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error during signup: $e");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sign2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Signup Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/logo3.jpg'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Join Kumbh Sarthi!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    signupUser(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      phoneController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class MainScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  const MainScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String userName = widget.userName;
  late String userEmail = widget.userEmail;
  late String userPhone = widget.userPhone;
  int _selectedIndex = 0;

  // List of images and labels for your bottom nav items
  final List<Map<String, String>> navItems = [
    {'icon': 'assets/live-chat.png', 'label': 'Chat'},
    {'icon': 'assets/profile.png', 'label': 'Profile'},
    {'icon': 'assets/cogwheel.png', 'label': 'Settings'},
    {'icon': 'assets/feedback.png', 'label': 'Rate Us'},
  ];
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to the home screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: 'currentUserId',
              recipientId: 'recipientUserId',
            ),
          ),
        );
        break;

      case 1:
        // Navigate to the profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              name: userName, 
              email: userEmail, 
              phone: userPhone, 
              profilePictureUrl: null, userId: '', 
            ),
          ),
        );
        break;

      case 2:
        // Navigate to the setting screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;

      case 3:
        // Navigate to the rate screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const RateScreen(), 
          ),
        );
        break;

      default:
      
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumbh Sarthi'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Existing content (image, buttons, etc.)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset(
                  'assets/logo3.jpg',
                  height: 150, 
                ),
              ),
              // Buttons
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KumbhMapScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.navigation, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Navigation'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmergencyScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 236, 86, 75),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.warning, color: Colors.white),
                            SizedBox(width: 10),
                            Text('SOS'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NearbyServices(
                                userName: userName,
                                userEmail: userEmail,
                                userPhone: userPhone,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Nearby Services'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RealTimeUpdatesScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 160, 215, 105),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.update, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Real-time Updates'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 95, 188, 231),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.person_search, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Report'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom navigation row
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                return _buildCustomBottomNavItem(
                  navItems[index]['icon']!,
                  navItems[index]['label']!,
                  () => _onNavItemTapped(index),
                  isSelected: _selectedIndex == index,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Custom bottom navigation item builder
  Widget _buildCustomBottomNavItem(
    String imagePath,
    String label,
    VoidCallback onTap, {
    bool isSelected = false,
    double height = 24,
    double width = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: height,
            width: width,
            color: isSelected ? Colors.orange : null,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
