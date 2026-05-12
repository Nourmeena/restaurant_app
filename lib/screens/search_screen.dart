import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();

  List<Restaurant> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await _apiService.searchRestaurantsByProduct(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Product')),

      body: Column(
        children: [
          // ── search bar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'e.g. pizza, koshary, burger',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // ── results ──────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : !_hasSearched
                    ? const Center(
                        child: Text(
                          'Type a product name to find\nrestaurants that serve it',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : _results.isEmpty
                        ? const Center(
                            child: Text('No restaurants found for this product'),
                          )
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final r = _results[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.restaurant),
                                  ),
                                  title: Text(
                                    r.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    r.cuisine.isNotEmpty
                                        ? r.cuisine
                                        : 'Restaurant',
                                  ),
                                  trailing: const Icon(
                                    Icons.map,
                                    color: Colors.blue,
                                  ),
                                  // tap → open map with the restaurant's real coordinates
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MapScreen(
                                          resLat: r.lat,
                                          resLng: r.lng,
                                          restaurantName: r.name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
