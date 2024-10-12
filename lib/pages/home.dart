import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viajar/providers/stops_provider.dart';
import 'package:viajar/providers/tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _mapController = MapController();

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void _moveToCurrentPosition() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        13.0,
      );
      setState(() {
        _currentMarker = Marker(
          point:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40.0,
          ),
        );
      });
    }
  }

  void _initializeLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    LocationPermission permission = await Geolocator.requestPermission();
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _onLocationChanged(position);
    });
  }

  void _onLocationChanged(Position position) {
    developer.log('Location changed: $position',
        name: 'viajar.location.changed');
    _updateCurrentMarker(position);
  }

  void _updateCurrentMarker(Position position) {
    setState(() {
      _currentPosition = position;
      _currentMarker = Marker(
        point: LatLng(position.latitude, position.longitude),
        child: const Icon(
          Icons.circle,
          color: Color.fromARGB(255, 35, 45, 79),
          size: 25.0,
        ),
      );
    });
    _mapController.move(
      LatLng(position.latitude, position.longitude),
      13.0,
    );
  }

  Marker? _currentMarker;

  // void _initializeLocation() async {
  //   final LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   Geolocator.getCurrentPosition(locationSettings: locationSettings)
  //       .then((Position position) {
  //     developer.log('userCurrentPosition $position',
  //         name: 'viajar.location.current_position');
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moveToCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
                _currentPosition?.latitude ?? -34.92087386557177,
                _currentPosition?.longitude ?? -57.954484763445954),
            initialZoom: 13,
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(-90, -180),
                const LatLng(90, 180),
              ),
            ),
          ),
          children: [
            openStreetMapTileLayer,
            RichAttributionWidget(
              popupInitialDisplayDuration: const Duration(seconds: 5),
              animationConfig: const ScaleRAWA(),
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () async => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
                const TextSourceAttribution(
                  'This attribution is the same throughout this app, except '
                  'where otherwise specified',
                  prependCopyright: false,
                ),
              ],
            ),
            MarkerLayer(
              markers: _currentMarker != null ? [_currentMarker!] : const [],
            ),
            FutureBuilder(
              future: getStops(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final stops = snapshot.data ?? [];
                  return MarkerLayer(
                    markers: stops.map((stop) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(stop.stopLat, stop.stopLon),
                        child: const Icon(
                          FontAwesomeIcons.bus,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
