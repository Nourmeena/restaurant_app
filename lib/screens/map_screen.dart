import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../logic/map_bloc.dart';

class MapScreen extends StatefulWidget {
  final double resLat;
  final double resLng;
  final String restaurantName;

  const MapScreen({
    super.key,
    required this.resLat,
    required this.resLng,
    required this.restaurantName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapBloc _mapBloc = MapBloc();

  @override
  void initState() {
    super.initState();
    // initialize logic when screen opens
    _mapBloc.calculateDistanceToRestaurant(widget.resLat, widget.resLng);
  }

  @override
  void dispose() {
    _mapBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("directions to ${widget.restaurantName}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // the map background layer
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.resLat, widget.resLng),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.restaurant_app',
              ),

              // stream builder for the route line (blue line)
              StreamBuilder<List<LatLng>>(
                stream: _mapBloc.routePointsStream,
                builder: (context, snapshot) {
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: snapshot.data ?? [],
                        strokeWidth: 6.0,
                        color: Colors.blueAccent,
                      ),
                    ],
                  );
                },
              ),

              // markers for user and restaurant locations
              StreamBuilder<LatLng>(
                stream: _mapBloc.userLocationStream,
                builder: (context, snapshot) {
                  List<Marker> markers = [
                    Marker(
                      point: LatLng(widget.resLat, widget.resLng),
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ];

                  if (snapshot.hasData) {
                    markers.add(
                      Marker(
                        point: snapshot.data!,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    );
                  }
                  return MarkerLayer(markers: markers);
                },
              ),
            ],
          ),

          // top instructions banner - handles null by showing loading
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: StreamBuilder<List<String>>(
              stream: _mapBloc.instructionsStream,
              builder: (context, snapshot) {
                // handle null or empty state gracefully
                String instruction = "calculating route...";
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  instruction = snapshot.data!.first;
                }

                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      const BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.navigation_rounded, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 100,
            left: 15,
            right: 15,
            child: StreamBuilder<String?>(
              stream: _mapBloc.errorStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // bottom distance information card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<String>(
                  stream: _mapBloc.distanceStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("error: ${snapshot.error}");
                    }

                    String distanceText = snapshot.data ?? "-- KM";

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "total distance",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          distanceText,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
