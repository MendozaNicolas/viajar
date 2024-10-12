import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viajar/providers/stops_provider.dart';
import 'package:viajar/providers/tile_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter:
                const LatLng(-34.92087386557177, -57.954484763445954),
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
          ],
        ),
      ],
    );
  }
}
