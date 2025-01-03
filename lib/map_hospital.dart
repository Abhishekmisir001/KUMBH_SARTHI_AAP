import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWithHospitals extends StatelessWidget {
  const MapWithHospitals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: FlutterMap(
        options: MapOptions(
          center:
              LatLng(27.2046, 77.4977), // Replace with your desired location
          zoom: 13.0,
          maxZoom: 18.0, // Optional: You can define a max zoom level
          minZoom: 5.0, // Optional: You can define a min zoom level
        ),
        children: [
          // TileLayer: Map tiles
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),

          // MarkerLayer: Adding hospital markers
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(27.2046, 77.4977), // Hospital Location 1
                builder: (ctx) =>
                    Icon(Icons.local_hospital, color: Colors.red, size: 30),
              ),
              Marker(
                point: LatLng(27.2146, 77.4877), // Hospital Location 2
                builder: (ctx) =>
                    Icon(Icons.local_hospital, color: Colors.red, size: 30),
              ),
              Marker(
                point: LatLng(27.2246, 77.5077), // Hospital Location 3
                builder: (ctx) =>
                    Icon(Icons.local_hospital, color: Colors.red, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
