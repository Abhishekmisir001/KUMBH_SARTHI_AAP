import 'package:flutter/material.dart';
import 'package:kumbh_sarthi/map.dart';

class NearestPetrolStationScreen extends StatelessWidget {
  const NearestPetrolStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Adding margin around the entire screen
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for the image
            image: DecorationImage(
              image: AssetImage(
                  'assets/petrol.jpg'), // Ensure this image is in your assets folder and added to pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Content overlay
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Find the nearest petrol station',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Add navigation to directions here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KumbhMapScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: Text(
                          'Get Direction',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Add location functionality here
                        },
                        child: Text(
                          'Use my location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NearestPetrolStationScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
