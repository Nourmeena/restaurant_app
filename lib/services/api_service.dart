import '../models/restaurant.dart';
import '../models/product.dart';

class ApiService {
  // ── menus per cuisine type ────────────────────────────────────────────────
  static const Map<String, List<String>> _menus = {
    'pizza':    ['Margherita Pizza', 'Pepperoni Pizza', 'BBQ Chicken Pizza', 'Calzone', 'Garlic Bread'],
    'burger':   ['Classic Burger', 'Cheese Burger', 'Double Smash Burger', 'Crispy Chicken Burger', 'Veggie Burger'],
    'chicken':  ['Grilled Chicken', 'Fried Chicken', 'Chicken Shawarma', 'Chicken Wings', 'Chicken Strips'],
    'shawarma': ['Chicken Shawarma', 'Meat Shawarma', 'Mix Shawarma', 'Shawarma Plate', 'Grilled Kofta'],
    'seafood':  ['Grilled Fish', 'Fried Shrimp', 'Calamari', 'Fish & Chips', 'Seafood Platter'],
    'egyptian': ['Koshary', 'Ful Medames', "Ta'meya", 'Molokhia', 'Hawawshi', 'Feteer'],
    'sushi':    ['California Roll', 'Salmon Sashimi', 'Dragon Roll', 'Miso Soup', 'Edamame'],
    'sandwich': ['Club Sandwich', 'BLT', 'Tuna Sandwich', 'Grilled Cheese', 'Falafel Wrap'],
    'kebab':    ['Chicken Kebab', 'Kofta', 'Mixed Grill', 'Lamb Chops', 'Kebab Plate'],
    'pasta':    ['Spaghetti Bolognese', 'Fettuccine Alfredo', 'Penne Arrabbiata', 'Lasagna', 'Carbonara'],
    'indian':   ['Butter Chicken', 'Chicken Biryani', 'Garlic Naan', 'Dal Makhani', 'Samosa'],
    'coffee':   ['Espresso', 'Cappuccino', 'Latte', 'Iced Coffee', 'Cheesecake Slice'],
    'steak':    ['Ribeye Steak', 'Sirloin Steak', 'Grilled Lamb', 'Fillet Steak', 'Mixed Grill'],
    'fast food':['Classic Burger', 'Fried Chicken', 'French Fries', 'Onion Rings', 'Milkshake'],
  };

  static const List<String> _defaultMenu = [
    'House Special', 'Grilled Chicken', 'Mixed Salad', 'Soup of the Day', "Chef's Pasta",
  ];

  static List<String> _getMenu(String cuisine) {
    final c = cuisine.toLowerCase();
    for (final key in _menus.keys) {
      if (c.contains(key)) return _menus[key]!;
    }
    return _defaultMenu;
  }

  // ── Cairo restaurants with real GPS coordinates ───────────────────────────
  static final List<Restaurant> _restaurants = [
    Restaurant(id: '1',  name: 'KFC Tahrir',            cuisine: 'chicken',  lat: 30.0444, lng: 31.2357),
    Restaurant(id: '2',  name: "McDonald's Zamalek",    cuisine: 'burger',   lat: 30.0626, lng: 31.2198),
    Restaurant(id: '3',  name: 'Pizza Hut Mohandeseen', cuisine: 'pizza',    lat: 30.0596, lng: 31.2022),
    Restaurant(id: '4',  name: "Hardee's Heliopolis",   cuisine: 'burger',   lat: 30.0884, lng: 31.3219),
    Restaurant(id: '5',  name: 'Koshary El Tahrir',     cuisine: 'egyptian', lat: 30.0451, lng: 31.2371),
    Restaurant(id: '6',  name: 'Sushiway Cairo',        cuisine: 'sushi',    lat: 30.0701, lng: 31.3462),
    Restaurant(id: '7',  name: 'Burger King Downtown',  cuisine: 'burger',   lat: 30.0510, lng: 31.2380),
    Restaurant(id: '8',  name: 'Shawarmer Nasr City',   cuisine: 'shawarma', lat: 30.0600, lng: 31.3300),
    Restaurant(id: '9',  name: 'Fish & Chips Giza',     cuisine: 'seafood',  lat: 30.0130, lng: 31.2085),
    Restaurant(id: '10', name: 'Cilantro Cafe Zamalek', cuisine: 'coffee',   lat: 30.0571, lng: 31.2168),
    Restaurant(id: '11', name: 'Roadhouse Grill',       cuisine: 'steak',    lat: 30.0596, lng: 31.2234),
    Restaurant(id: '12', name: 'Maharaja Indian',       cuisine: 'indian',   lat: 30.0560, lng: 31.2150),
    Restaurant(id: '13', name: 'Kebabgy Mohandeseen',   cuisine: 'kebab',    lat: 30.0580, lng: 31.2000),
  ];

  // ── 1. get all restaurants ────────────────────────────────────────────────
  Future<List<Restaurant>> getRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _restaurants;
  }

  // ── 2. get products for a restaurant ─────────────────────────────────────
  Future<List<Product>> getProducts(String restaurantId, String cuisine) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final menuItems = _getMenu(cuisine);
    return menuItems.asMap().entries.map((entry) {
      return Product(id: '${restaurantId}_${entry.key}', name: entry.value);
    }).toList();
  }

  // ── 3. search restaurants by product name ─────────────────────────────────
  Future<List<Restaurant>> searchRestaurantsByProduct(String productName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final query = productName.toLowerCase().trim();
    return _restaurants.where((r) {
      return _getMenu(r.cuisine).any((item) => item.toLowerCase().contains(query));
    }).toList();
  }
}
