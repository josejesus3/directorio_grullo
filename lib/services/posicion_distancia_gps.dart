import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<double> calculateDistance(double startLatitude, double startLongitude,
    double endLatitude, double endLongitude) async {
  try {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters;
  } catch (e) {
    Exception(e);
    return 0;
  }
}

Future<double> askGpsAccess(
    BuildContext context, double endLatitude, double endLongitude) async {
  final status = await Permission.location.request();
  switch (status) {
    case PermissionStatus.granted:
      // para saber posicion de mi dispositivo
      Position position = await Geolocator.getCurrentPosition();
      // ignore: use_build_context_synchronously

      double distance = await calculateDistance(
        position.latitude,
        position.longitude,
        endLatitude,
        endLongitude,
      );

      return distance;

    case PermissionStatus.denied:
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:
    case PermissionStatus.provisional:
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black45,
          content: const Text(
            'Es necesario conceder el permiso de ubicación.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          action: SnackBarAction(
            label: 'Configuración',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return 0;
  }
}
