import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/product.dart';
import '../models/restaurant.dart';

/// Talks to the custom Node.js API in `/server`.
class ApiService {
  static const Duration _timeout = Duration(seconds: 15);

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse(kApiBaseUrl).replace(path: path, queryParameters: query);
  }

  Never _failNetwork(Object error) {
    throw Exception(
      'Cannot reach API at $kApiBaseUrl. '
      'In another terminal run: cd server && npm install && npm start. '
      '(Error: $error)',
    );
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http
          .get(_uri('/api/restaurants'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load restaurants (${response.statusCode}): ${response.body}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['restaurants'] as List<dynamic>;
      return list
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception(
        'Request timed out connecting to $kApiBaseUrl. Is `npm start` running?',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      _failNetwork(e);
    }
  }

  Future<List<Product>> getProducts(String restaurantId, String _) async {
    try {
      final response = await http
          .get(_uri('/api/restaurants/$restaurantId/products'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load products (${response.statusCode}): ${response.body}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['products'] as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception(
        'Request timed out connecting to $kApiBaseUrl. Is `npm start` running?',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      _failNetwork(e);
    }
  }

  Future<List<Restaurant>> searchRestaurantsByProduct(
    String productName,
  ) async {
    try {
      final response = await http
          .get(_uri('/api/search', {'product': productName}))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Search failed (${response.statusCode}): ${response.body}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['restaurants'] as List<dynamic>? ?? [];
      return list
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception(
        'Request timed out connecting to $kApiBaseUrl. Is `npm start` running?',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      _failNetwork(e);
    }
  }
}
