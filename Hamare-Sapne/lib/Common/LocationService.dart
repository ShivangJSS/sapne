import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Get current location with permission handling
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await _showGpsDialog(context);
      return null;
    }

    try {
      return await _getGeoLocation();
    } catch (e) {
      debugPrint("Error fetching location: $e");
      return null;
    }
  }

  /// Stream for continuous location updates
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    );
  }

  /// Internal: Check & request permission
  static Future<Position> _getGeoLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Internal: GPS Dialog
  static Future<void> _showGpsDialog(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Text(
                "GPS Required",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            "Please enable GPS to use this feature.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();

                  bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
                  while (!gpsEnabled) {
                    await Future.delayed(const Duration(seconds: 1));
                    gpsEnabled = await Geolocator.isLocationServiceEnabled();
                  }
                },
                child: const Text("Open Settings"),
              ),
            ),
          ],
        );
      },
    );
  }
}
