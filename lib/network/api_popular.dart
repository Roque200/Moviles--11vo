import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviles/models/popular_model.dart';

class ApiPopular {
  final String? apiKey = dotenv.env['api_key'];
  late Uri link;

  ApiPopular() {
    link = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=es-MX&page=1",
    );
  }

  Future<List<PopularModel>?> getAllPopular() async {
    if (apiKey == null || apiKey!.isEmpty) {
      throw Exception(
        'No se encontró api_key en el archivo .env. '
        'Revisa que exista en la raíz del proyecto y vuelve a correr la app.',
      );
    }

    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)["results"] as List;
      return jsonResult
          .map((e) => PopularModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    String mensaje = response.body;
    try {
      mensaje = jsonDecode(response.body)['status_message'] ?? response.body;
    } catch (_) {}
    throw Exception('TMDB respondió ${response.statusCode}: $mensaje');
  }
}
