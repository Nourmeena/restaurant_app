import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const ProductsScreen({super.key, required this.restaurant});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // pass both id and cuisine so the service can pick the right menu
    _productsFuture = _apiService.getProducts(
      widget.restaurant.id,
      widget.restaurant.cuisine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),

      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.fastfood)),
                  title: Text(product.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
