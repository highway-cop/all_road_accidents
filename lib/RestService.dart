import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/Accident.dart';

const API_URL = 'highway-cop-api.herokuapp.com';

class RestService {
  RestService._();

  static Future<List<Accident>> getByCity(String name) async {
    final response = await http.get(
      Uri.https(API_URL, '/api/accidents/city', {
        'name': name,
      }),
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
    final response = await http.get(
      Uri.https(API_URL, '/api/accidents/near', {
        'lng': lng.toString(),
        'lat': lat.toString(),
        'range': range.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Accident.fromJson(e))
          .toList();
    }

    throw Exception('Erro ao buscar acidentes próximos');
  }
}
