import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kumbh_sarthi/main.dart';
import 'hospital_screen.dart';
import 'police_station_screen.dart';
import 'restaurant_screen.dart';
import 'atm_screen.dart';
import 'gas_station_screen.dart';

class NearbyServices extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  const NearbyServices({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to MainScreen when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    userName: userName,
                    userEmail: userEmail,
                    userPhone: userPhone,
                  )),
          (Route<dynamic> route) => false, // Clear all routes from the stack
        );
        return false; // Prevent the default pop action
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Services'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List of services
              Expanded(
                child: ListView(
                  children: [
                    _buildServiceItem(context, 'Hospital',
                        'assets/hospital.png', const NearestHospitalScreen()),
                    _buildServiceItem(context, 'Police Station',
                        'assets/help-desk.png',  PoliceServiceScreen()),
                    _buildServiceItem(context, 'Restaurant',
                        'assets/restaurant.png', RestaurantsScreen()),
                    _buildServiceItem(context, 'ATM', 'assets/atm-machine.png',
                        const AtmFinderScreen()),
                    _buildServiceItem(context, 'Gas Station',
                        'assets/hotel.png', NearestPetrolStationScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, String iconPath,
      Widget destinationScreen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(
          iconPath,
          height: 40,
          width: 40,
        ),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
          if (kDebugMode) {
            print('$title tapped');
          }
        },
      ),
    );
  }
}
