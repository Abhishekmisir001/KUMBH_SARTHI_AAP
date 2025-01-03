import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class KumbhMapScreen extends StatefulWidget {
  const KumbhMapScreen({super.key});

  @override
  _KumbhMapScreenState createState() => _KumbhMapScreenState();
}

class _KumbhMapScreenState extends State<KumbhMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumbh Mela Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(25.4358, 81.8463), // Coordinates for Kumbh Mela
          zoom: 15,
          minZoom: 13, // You can set a minimum zoom level
        ),
        children: [
          // TileLayer with OpenStreetMap tiles
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          // MarkerLayer for adding different markers
          MarkerLayer(
            markers: [
              // Kumbh Mela main location
              Marker(
                point: LatLng(
                    25.4358, 81.8463), // Example: Kumbh Mela central location
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              // Example Hospital Marker
              Marker(
                point: LatLng(25.4362, 81.8469), // Example hospital location
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.local_hospital,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              // Example Police Station Marker
              Marker(
                point:
                    LatLng(25.4370, 81.8475), // Example police station location
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.local_police,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              // Example Lost and Found Booth Marker
              Marker(
                point: LatLng(25.4340, 81.8450), // Example lost and found booth
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.people,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
              // More markers can be added here for other services
            ],
          ),
        ],
      ),
    );
  }
}
