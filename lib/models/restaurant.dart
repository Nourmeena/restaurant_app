class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double lat;
  final double lng;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.lat,
    required this.lng,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      cuisine: json['cuisine']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }
}
