import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:viajar/components/card.dart';
import 'package:viajar/models/stop.dart';
import 'package:viajar/providers/stops_provider.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  Position? _currentPosition = Position(
    latitude: -34.92087386557177,
    longitude: -57.954484763445954,
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    timestamp: DateTime.now(),
    altitudeAccuracy: 0.0,
  );

  @override
  void initState() {
    _initializeLocation();
    super.initState();
  }

  void _initializeLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    LocationPermission permission = await Geolocator.requestPermission();
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _currentPosition = position;
    });
  }

  Future<List<Stop>> _fetchStops() async {
    final stops = await getStops();

    if (_currentPosition != null) {
      stops.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          a.stopLat,
          a.stopLon,
        );
        final distanceB = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          b.stopLat,
          b.stopLon,
        );
        return distanceA.compareTo(distanceB);
      });
    }

    return stops;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _initializeLocation();
        });
      },
      child: FutureBuilder<List<Stop>>(
        future: _fetchStops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stops available'));
          } else {
            final stops = snapshot.data!;
            return GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: stops
                  .asMap()
                  .entries
                  .map((entry) => StopCard(entry.key,
                      id: entry.value.stopId, title: entry.value.stopName))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
