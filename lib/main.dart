import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AvgAirApp());
}

class AvgAirApp extends StatelessWidget {
  const AvgAirApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVG Air Quality',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2D5E), // Dark blue primary
          primary: const Color(0xFF0A2D5E),
          secondary: const Color(0xFFC8302D), // Red accent
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2D5E),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
