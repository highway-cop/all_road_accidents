import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';

import 'model/Accident.dart';

const API_URL = 'highway-cop-api.herokuapp.com';

class RestService {
  RestService._();

  static Future<List<Accident>> getByCity(String name) async {
    User user = FirebaseAuth.instance.currentUser as User;

    final String token = await user.getIdToken();

    final response = await http.get(
      Uri.https(API_URL, '/api/accidents/city', {
        'name': name,
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Accident.fromJson(e))
          .toList();
    }

    throw Exception('Erro ao buscar cidades');
  }

  static Future<List<Accident>> getNearBy(
      double lng, double lat, double range) async {
    User user = FirebaseAuth.instance.currentUser as User;

    final String token = await user.getIdToken();

    final response = await http.get(
      Uri.https(API_URL, '/api/accidents/near', {
        'lng': lng.toString(),
        'lat': lat.toString(),
        'range': (range * 1000).toString(),
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Accident.fromJson(e))
          .toList();
    }

    throw Exception('Erro ao buscar acidentes próximos');
  }
}
