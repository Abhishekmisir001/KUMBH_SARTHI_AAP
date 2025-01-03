// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Dummy data for nearby police stations and emergency contacts
class PoliceStation {
  final String name;
  final String address;
  final String contact;
  final String imageUrl;
  final double rating;

  PoliceStation({
    required this.name,
    required this.address,
    required this.contact,
    required this.imageUrl,
    required this.rating,
  });
}

class PoliceServiceScreen extends StatelessWidget {
  final List<PoliceStation> policeStations = [
    PoliceStation(
      name: 'Central Police Station',
      address: '456 Police St, City Center',
      contact: '100',
      imageUrl: 'assets/police1.jpg', // Use your image assets
      rating: 4.7,
    ),
    PoliceStation(
      name: 'Westside Police Station',
      address: '789 West Ave, Uptown',
      contact: '101',
      imageUrl: 'assets/police2.png', // Use your image assets
      rating: 4.5,
    ),
    PoliceStation(
      name: 'East Police Station',
      address: '123 East St, Old Town',
      contact: '102',
      imageUrl: 'assets/police3.png', // Use your image assets
      rating: 4.8,
    ),
    // Add more police stations as needed
  ];

   PoliceServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Services'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Hero Section: Emergency Contacts & Police News
          HeroSection(),

          // Nearby Police Stations
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Nearby Police Stations',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: policeStations.length,
            itemBuilder: (context, index) {
              final station = policeStations[index];
              return PoliceStationCard(station: station);
            },
          ),

          // File Complaint Section
          ComplaintSection(),

          // Safety Tips
          SafetyTips(),

          // Emergency Numbers Section
          EmergencyNumbers(),

          // Legal Assistance
          LegalAssistance(),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        image: DecorationImage(
          image: AssetImage('assets/police_hero.jpg'), // Hero Image
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Stay Safe, Stay Protected!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PoliceStationCard extends StatelessWidget {
  final PoliceStation station;

  const PoliceStationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              station.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            // Info Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      station.address,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          station.contact,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          station.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Rating Animation
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedOpacity(
                opacity: station.rating >= 4.5 ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Colors.orange,
                  child: const Text(
                    'Top Rated',
                    style: TextStyle(color: Colors.white),
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

class ComplaintSection extends StatelessWidget {
  const ComplaintSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File a Complaint',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Report any issues or incidents. You can file a complaint here for various reasons.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  const url =
                      'https://cctnsup.gov.in/eFIR/login.aspx'; // Example URL, replace with the actual complaint URL
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('File Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SafetyTips extends StatelessWidget {
  const SafetyTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety Tips',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                '• Always stay aware of your surroundings.\n• Keep your phone charged and ready.\n• Use emergency contacts when in danger.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyNumbers extends StatelessWidget {
  const EmergencyNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency Numbers',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Police: 100',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Ambulance: 101',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegalAssistance extends StatelessWidget {
  const LegalAssistance({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legal Assistance',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Need legal help? Reach out to our trusted partners for legal advice and assistance.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  const url =
                      'https://uppolice.gov.in/article/en/act-rules'; // Replace with the actual legal help URL
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('Get Legal Help'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
