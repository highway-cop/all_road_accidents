import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Utils.dart';
import 'RestService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();

  double _range = 10;
  final cidadeController = TextEditingController();

  void _getByCity() async {
    Navigator.of(context).pop();
    showLoadingOverlay(context);

    setState(() {
      markers = {};
    });

    try {
      final results = await RestService.getByCity(cidadeController.text);

      final map = results.asMap().map((key, value) {
        MarkerId markerId = MarkerId(key.toString());

        Marker marker = Marker(markerId: markerId, position: value.location);

        return MapEntry(markerId, marker);
      });

      setState(() {
        markers.addAll(map);
      });
    } finally {
      Navigator.of(context).pop();
      cidadeController.clear();
    }
  }

  void _getNearBy() async {
    Navigator.of(context).pop();
    showLoadingOverlay(context);

    setState(() {
      markers = {};
    });

    try {
      final position = await getUserPosition();

      final results = await RestService.getNearBy(
          position.longitude, position.latitude, _range);

      final map = results.asMap().map((key, value) {
        MarkerId markerId = MarkerId(key.toString());

        Marker marker = Marker(markerId: markerId, position: value.location);

        return MapEntry(markerId, marker);
      });

      setState(() {
        markers.addAll(map);
      });
    } catch (error) {
      showError(context, '$error');
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      throw ('Usuário não autenticado');
    }

    User user = auth.currentUser as User;

    String photoURL = user.photoURL ??
        "https://cdn.iconscout.com/icon/free/png-256/account-avatar-profile-human-man-user-30448.png";

    return Scaffold(
      appBar: AppBar(
        title: Text('Acidentes'),
        actions: [
          IconButton(
            icon: Icon(Icons.near_me_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text("Acidentes Próximos"),
                  contentPadding: EdgeInsets.all(24.0),
                  children: [
                    StatefulBuilder(
                      builder: (context, state) => Slider(
                        min: 10,
                        max: 80,
                        divisions: 7,
                        value: _range,
                        label: _range.round().toString(),
                        onChanged: (value) {
                          state(() => _range = value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Buscar'),
                          onPressed: _getNearBy,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Acidentes por Cidade"),
                  content: Stack(
                    children: [
                      TextField(
                        controller: cidadeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cidade',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Buscar'),
                      onPressed: _getByCity,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? ""),
              accountEmail: Text(user.email ?? ""),
              currentAccountPicture: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(photoURL),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.of(markers.values),
        initialCameraPosition: CameraPosition(
          zoom: 8,
          target: LatLng(-25, -50),
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
