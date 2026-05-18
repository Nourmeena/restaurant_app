import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';
import 'products_screen.dart';
import 'search_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = _apiService.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search by product',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Restaurant>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading nearby restaurants...'),
                ],
              ),
            );
          }

          // error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final restaurants = snapshot.data!;

          if (restaurants.isEmpty) {
            return const Center(
              child: Text('No restaurants found in this area.'),
            );
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final r = restaurants[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  // icon colored by cuisine type
                  leading: CircleAvatar(
                    backgroundColor: _cuisineColor(r.cuisine),
                    child: const Icon(Icons.restaurant, color: Colors.white),
                  ),
                  title: Text(
                    r.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    r.cuisine.isNotEmpty ? r.cuisine : 'Restaurant',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductsScreen(restaurant: r),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // give each cuisine a distinct color for the avatar
  Color _cuisineColor(String cuisine) {
    final c = cuisine.toLowerCase();
    if (c.contains('pizza')) return Colors.orange;
    if (c.contains('burger')) return Colors.red;
    if (c.contains('chicken') || c.contains('shawarma')) return Colors.amber;
    if (c.contains('seafood') || c.contains('fish')) return Colors.blue;
    if (c.contains('egyptian')) return Colors.green;
    if (c.contains('sushi')) return Colors.pink;
    if (c.contains('coffee') || c.contains('cafe')) return Colors.brown;
    if (c.contains('kebab') || c.contains('steak')) return Colors.deepOrange;
    return Colors.teal;
  }
}