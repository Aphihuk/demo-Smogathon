import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/pm25_data.dart';
import '../services/pm25_api.dart';
import '../utils/aqi_helpers.dart';
import 'map_picker_screen.dart';
import '../widgets/aqi_card.dart';
import '../widgets/attribution_bar.dart';
import '../widgets/forecast_chart.dart';
import '../widgets/health_tip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Pm25Api _api = Pm25Api();
  
  bool _isLoading = true;
  String _error = '';
  String _locationName = 'Locating...';
  
  Pm25Detail? _data;

  double? _targetLat;
  double? _targetLon;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      double lat = 17.96; // Vientiane default
      double lon = 102.61;

      if (_targetLat != null && _targetLon != null) {
        lat = _targetLat!;
        lon = _targetLon!;
        
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
          if (placemarks.isNotEmpty) {
            _locationName = '${placemarks.first.locality ?? placemarks.first.subAdministrativeArea}, ${placemarks.first.country}';
          }
        } catch (_) {
          _locationName = 'Searched Location';
        }
      } else {
        // Try to get location permission
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low);
          lat = position.latitude;
          lon = position.longitude;

          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
            if (placemarks.isNotEmpty) {
              _locationName = '${placemarks.first.locality ?? placemarks.first.subAdministrativeArea}, ${placemarks.first.country}';
            }
          } catch (_) {
            _locationName = 'Current Location';
          }
        } else {
          _locationName = 'Vientiane, Laos (Default)';
        }
      }

      final data = await _api.fetchDetail(lat, lon);
      
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> bgGradient = [Colors.blue.shade900, Colors.black87];
    if (_data != null) {
      bgGradient = getAqiGradient(_data!.aqiUs);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _fetchData,
                color: Colors.white,
                backgroundColor: Colors.white24,
                child: _buildBody(),
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.white),
                      onPressed: () {
                        _targetLat = null;
                        _targetLon = null;
                        _fetchData();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _showSearchDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() async {
    // Current fallback coords
    double currentLat = _targetLat ?? 17.96;
    double currentLon = _targetLon ?? 102.61;

    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLat: currentLat,
          initialLon: currentLon,
        ),
      ),
    );

    if (selectedLocation != null) {
      // It returns a LatLng object, but home_screen doesn't import latlong2 by default.
      // We can just access .latitude and .longitude if we import latlong2, or cast to dynamic.
      // We will import it at the top.
      setState(() {
        _targetLat = selectedLocation.latitude;
        _targetLon = selectedLocation.longitude;
      });
      await _fetchData();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_error.isNotEmpty) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Icon(Icons.error_outline, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            'Failed to load data',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
              ),
              onPressed: _fetchData,
              child: const Text('Try Again'),
            ),
          ),
        ],
      );
    }

    if (_data == null) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      children: [
        // Header (Apple Weather style)
        Text(
          _locationName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_data!.aqiUs}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            height: 1.0,
            shadows: [Shadow(color: Colors.black26, blurRadius: 15)],
          ),
        ),
        Text(
          '${_data!.aqiCategory}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black26, blurRadius: 5)],
          ),
        ),
        const SizedBox(height: 48),
        
        // Modules
        AqiCard(
          aqi: _data!.aqiUs,
          pm25: _data!.pm25Value,
          category: _data!.aqiCategory,
          confidence: _data!.pm25Confidence,
        ),
        const SizedBox(height: 16),
        HealthTip(
          aqi: _data!.aqiUs,
          category: _data!.aqiCategory,
        ),
        const SizedBox(height: 16),
        ForecastChart(
          forecast: _data!.forecastHourly,
        ),
        const SizedBox(height: 16),
        AttributionBar(
          attribution: _data!.attribution,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
