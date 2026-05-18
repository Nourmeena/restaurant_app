import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class MapBloc {
  final _locationService = LocationService();

  // subjects for reactive data management
  final _distanceSubject = BehaviorSubject<String>();
  final _userLocationSubject = BehaviorSubject<LatLng>();
  final _routePointsSubject = BehaviorSubject<List<LatLng>>();
  final _instructionsSubject = BehaviorSubject<List<String>>();
  final _errorSubject = BehaviorSubject<String?>();

  // public streams for the ui to listen to
  Stream<String> get distanceStream => _distanceSubject.stream;
  Stream<LatLng> get userLocationStream => _userLocationSubject.stream;
  Stream<List<LatLng>> get routePointsStream => _routePointsSubject.stream;
  Stream<List<String>> get instructionsStream => _instructionsSubject.stream;
  Stream<String?> get errorStream => _errorSubject.stream;

  Future<void> calculateDistanceToRestaurant(
    double destLat,
    double destLng,
  ) async {
    try {
      // 1. fetch user current location
      Position position = await _locationService.getCurrentLocation();
      LatLng userLatLng = LatLng(position.latitude, position.longitude);
      _userLocationSubject.add(userLatLng);

      // 2. calculate direct distance
      double distanceInMeters = Geolocator.distanceBetween(
        userLatLng.latitude,
        userLatLng.longitude,
        destLat,
        destLng,
      );

      String formattedDistance = (distanceInMeters / 1000).toStringAsFixed(2);
      _distanceSubject.add("$formattedDistance KM");

      // 3. fetch road path and directions from api
      await getDirections(userLatLng, destLat, destLng);
    } catch (e) {
      _distanceSubject.addError("location error: $e");
      _errorSubject.add(
        'Unable to get your location. تأكّد من تفعيل الإنترنت و صلاحيات الموقع.',
      );
    }
  }

  Future<void> getDirections(LatLng start, double dLat, double dLng) async {
    try {
      // open source routing machine api with steps enabled
      final url =
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};$dLng,$dLat?overview=full&geometries=geojson&steps=true';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          // extract polyline points for the map
          final List coords = data['routes'][0]['geometry']['coordinates'];
          List<LatLng> points = coords.map((c) => LatLng(c[1], c[0])).toList();
          _routePointsSubject.add(points);

          // extract navigation instructions
          final List steps = data['routes'][0]['legs'][0]['steps'];
          List<String> instructions = steps
              .map(
                (s) =>
                    s['maneuver']['instruction']?.toString() ??
                    "proceed to destination",
              )
              .toList();

          _instructionsSubject.add(instructions);
          _errorSubject.add(null);
        }
      } else {
        throw Exception('Directions service returned ${response.statusCode}');
      }
    } catch (e) {
      String message =
          'Unable to load directions. تأكّد من اتصال الإنترنت وحاول مرة أخرى.';
      if (e is SocketException) {
        message = 'لا يوجد اتصال بالإنترنت. الرجاء التحقق من الشبكة.';
      }

      _errorSubject.add(message);
      print("api error: $e");
      _instructionsSubject.add(["unable to load directions"]);
    }
  }

  void dispose() {
    _distanceSubject.close();
    _userLocationSubject.close();
    _routePointsSubject.close();
    _instructionsSubject.close();
    _errorSubject.close();
  }
}
