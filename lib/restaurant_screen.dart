

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Dummy data for restaurants
class Restaurant {
  final String name;
  final String address;
  final String contact;
  final String imageUrl;
  final double rating;
  final String websiteUrl; 

  Restaurant({
    required this.name,
    required this.address,
    required this.contact,
    required this.imageUrl,
    required this.rating,
    required this.websiteUrl,
  });
}

class RestaurantsScreen extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(
      name: 'The Green Plate',
      address: '123 Main St, City Center',
      contact: '898674978',
      imageUrl: 'assets/restaurant1.jpg',
      rating: 4.5,
      websiteUrl: 'https://www.thegreenplate.com', 
    ),
    Restaurant(
      name: 'Spice Junction',
      address: '456 Spicy Ave, Food Street',
      contact: '8795869098',
      imageUrl: 'assets/restaurant5.jpg',
      rating: 4.2,
      websiteUrl: 'https://www.spicejunction.com',
    ),
    Restaurant(
      name: 'Ocean Breeze',
      address: '789 Beach Rd, Seaside',
      contact: '8769409876',
      imageUrl: 'assets/restaurant4.jpg',
      rating: 4.8,
      websiteUrl: 'https://www.oceanbreeze.com', 
    ),
    Restaurant(
      name: 'Misthi Pan Bhandaar',
      address: 'Cotton Mill,Naini',
      contact: '9919887770',
      imageUrl: 'assets/r1.png',
      rating: 4.8,
      websiteUrl:
          'https://www.zomato.com/allahabad/misthi-bites-naini',
    ),
    Restaurant(
      name: 'El Chico Plastic',
      address: 'Mahatma Gandu Marg Prayagraj',
      contact: '9415128975',
      imageUrl: 'assets/r2.jpg',
      rating: 4.8,
      websiteUrl: 'https://elchico.in/', 
    ),
  
  ];

   RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(restaurant: restaurant);
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  // launch the URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(restaurant.websiteUrl); // Open the restaurant's website
      },
      child: Card(
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
                restaurant.imageUrl,
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
                        restaurant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        restaurant.address,
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
                            restaurant.contact,
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
                            restaurant.rating.toString(),
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
              
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedOpacity(
                  opacity: restaurant.rating >= 4.5 ? 1.0 : 0.0,
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
      ),
    );
  }
}
