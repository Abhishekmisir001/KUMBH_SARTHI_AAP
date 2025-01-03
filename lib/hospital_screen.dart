import 'package:flutter/material.dart';
import 'package:kumbh_sarthi/Map_Hospital.dart';
import 'package:kumbh_sarthi/nearbyservices.dart';

void main() {
  runApp(const MaterialApp(home: NearestHospitalScreen()));
}

class NearestHospitalScreen extends StatelessWidget {
  const NearestHospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Nearest Hospital',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Section
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MapWithHospitals(),

              // Popular Hospitals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Hospitals',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    // List of hospital images
                    final hospitalImages = [
                      'assets/h1.jpeg',
                      'assets/h2.jpeg',
                      'assets/h3.jpeg',
                      'assets/h4.jpeg',
                    ];

                    return Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          hospitalImages[index],
                          fit: BoxFit
                              .cover, // Adjust the image to fill the container
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Nearest Hospitals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearest Hospitals',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // Number of hospital images
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    // Image paths corresponding to hospitals
                    final hospitalImages = [
                      'assets/h5.jpeg',
                      'assets/h6.jpeg',
                      'assets/h7.jpeg',
                      'assets/h8.jpeg',
                    ];

                    // Screens corresponding to hospitals
                    final hospitalScreens = [
                      //  HospitalScreen1(), // Replace with actual screen widgets
                      //HospitalScreen2(),
                      // HospitalScreen3(),
                      //HospitalScreen4(),
                    ];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the respective screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => hospitalScreens[index]),
                        );
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            hospitalImages[index], // Load image directly here
                            fit: BoxFit
                                .cover, // Fit image properly in the container
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
