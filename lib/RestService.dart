import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/Accident.dart';

const API_URL = 'highway-cop-api.herokuapp.com/api';

class RestService {
  RestService._();

  static Future<Accident> getByCity(String name) async {
    final response = await http.get(
      Uri.https(API_URL, '/accidents/city', {
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return Accident.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao buscar cidades');
  }

  static Future<Accident> getNearBy(
      double lng, double lat, double range) async {
    final response = await http.get(
      Uri.https(API_URL, '/accidents/near', {
        'lng': lng.toString(),
        'lat': lat.toString(),
        'range': range.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return Accident.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao buscar acidentes próximos');
  }
}
