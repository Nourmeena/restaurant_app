import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      
      initialRoute: '/',
      
      routes: {
        '/': (context) => const SignupScreen(),
        
        '/login': (context) => const LoginScreen(),
        
        '/map': (context) => const MapScreen(
              resLat: 30.0444,
              resLng: 31.2357,
              restaurantName: "مطعم التجربة",
            ),
      },
    );
  }
}