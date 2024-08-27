import 'dart:convert';

import 'package:http/http.dart' as http;

class GenreService {
  String frontUrl;

  GenreService(this.frontUrl);

  Future<dynamic> getAllGenres() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}genres/get-all-genres-for-admin-dashboard');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getGenreById(int genre_id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}genres/get-genre-by-id/$genre_id');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> createGenre({required String name, required String description}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('${frontUrl}genres/create-genre/');
      final Map<String, dynamic> data = {
        "name": name,
        "description": description,
      };
      //
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> updateGenreById({
    required int id,
    required String name,
    required String description,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('${frontUrl}genres/update-genre-by-id/$id');
      final Map<String, dynamic> data = {
        "name": name,
        "description": description,
      };
      //
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> deleteGenreById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}genres/delete-genre-by-id/$id');
      http.Response response = await http.delete(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }
}
