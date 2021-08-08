import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';
import 'LoginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().then((v) => runApp(_App()));
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acidentes rodoviários',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: _DefaultHome(),
    );
  }
}

class _DefaultHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );

        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });

    return Scaffold();
  }
}
