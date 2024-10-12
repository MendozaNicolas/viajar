import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<bool> handleLocationPermission(
      ScaffoldMessengerState scaffoldMessenger) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentPosition(
      ScaffoldMessengerState scaffoldMessenger) async {
    // final hasPermission = await handleLocationPermission(scaffoldMessenger);
    Position? currentPosition;
    // if (!hasPermission) return null;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      return null;
    });
    print(currentPosition);
    return currentPosition;
  }
}
