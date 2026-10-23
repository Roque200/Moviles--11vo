import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moviles/models/popular_model.dart';

class ApiPopular {
  Uri link = Uri.parse(
    "https://api.themoviedb.org/3/movie/popular?api_key=c3223508ab5f509c706ccafb4e250755&language=es-MX&page=1",
  );
  Future<List<PopularModel>?> getAllPopular() async {
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)["results"] as List;
      return jsonResult.map((e) => PopularModel.fromMap(e as Map<String, dynamic>)).toList();
    }
    return null;
  }
}
