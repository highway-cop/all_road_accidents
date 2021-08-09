import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

Future<Position> getUserPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('O serviço de localização está desativado');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('É necessário permitir o acesso à localização!');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('O acesso à localização está bloqueado!');
  }

  return await Geolocator.getCurrentPosition();
}

void showLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(),
          Text("Carregando"),
        ],
      ),
    ),
  );
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
