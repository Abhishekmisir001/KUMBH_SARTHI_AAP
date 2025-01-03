import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final Function(int) onTabSelected; // Callback for tab selection
  const NavigationBar({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200, // Background color for the bottom bar
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCustomBottomNavItem(
              'assets/home.png', 'Home', () => onTabSelected(0)),
          _buildCustomBottomNavItem(
              'assets/profile.png', 'Profile', () => onTabSelected(1),
              height: 32, width: 32), // Larger profile icon
          _buildCustomBottomNavItem(
              'assets/settings.png', 'Settings', () => onTabSelected(2)),
          _buildCustomBottomNavItem(
              'assets/rate_us.png', 'Rate Us', () => onTabSelected(3)),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavItem(
    String imagePath,
    String label,
    VoidCallback onTap, {
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
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
