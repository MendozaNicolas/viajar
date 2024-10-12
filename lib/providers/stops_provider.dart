import 'package:viajar/models/stop.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Stop>> getStops() async {
  final file = await rootBundle.loadString("assets/stops.csv");

  final lines = file.split('\n');
  final stops = <Stop>[];

  for (var line in lines.skip(1)) {
    // Skip header line
    final values = line.split(',');
    if (values.length == 5) {
      final stop = Stop(
        stopId: values[0],
        stopCode: values[1],
        stopName: values[2],
        stopLat: double.parse(values[3]),
        stopLon: double.parse(values[4]),
      );
      stops.add(stop);
    }
  }

  return stops;
}
