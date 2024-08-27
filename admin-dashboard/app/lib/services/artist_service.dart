import 'dart:convert';

import 'package:http/http.dart' as http;

class ArtistService {
  String frontUrl;

  ArtistService(this.frontUrl);

  Future<dynamic> getAllArtists() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}artists/');
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

  Future<dynamic> getArtistById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}artists/get-artist-by-id/${id}');
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
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> createArtist({
    required String pictureBase64,
    required String name,
    required String picture,
    required String description,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}artists/create-artist/'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "name": name,
        "description": description,
        "picture": picture,
        "picture_base64": pictureBase64,
      };
      //
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(songData),
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

  Future<dynamic> updateArtist({
    required int id,
    required String pictureBase64,
    required String name,
    required String picture,
    required String description,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}artists/update-artist-by-id/$id'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "name": name,
        "description": description,
        "picture": picture,
        "picture_base64": pictureBase64,
      };
      //
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(songData),
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

  Future<dynamic> deleteArtistById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}artists/delete-artist-by-id/${id}');
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
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }
}
