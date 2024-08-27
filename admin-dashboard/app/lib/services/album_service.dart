import 'dart:convert';

import 'package:http/http.dart' as http;

class AlbumService {
  String frontUrl;

  AlbumService(this.frontUrl);

  Future<dynamic> getAllAlbum() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}albums/');
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

  Future<dynamic> getAlbumById(int album_id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}albums/get-album-by-id/$album_id');
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

  Future<dynamic> getSongsByAlbumId(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/get-songs-by-album-id/$id');
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

  Future<dynamic> getAlbumsByArtistId(int artist_id) async {
    dynamic jsonResponse;
    try {
      var url =
          Uri.parse('${frontUrl}albums/get-albums-by-artist-id/${artist_id}');
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

  Future<dynamic> createAlbum(
      {required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required int artistId,
      required String releaseDate}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}albums/create-album/'); // Thay đổi URL của bạn ở đây

      final Map<String, dynamic> songData = {
        "name": name,
        "description": description,
        "picture": picture,
        "picture_base64": pictureBase64,
        "release_date": releaseDate,
        "artist_id": artistId,
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

  Future<dynamic> updateAlbumById(
      {required int id,
      required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required int artistId,
      required String releaseDate}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}albums/update-album-by-id/$id'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "id": id,
        "name": name,
        "description": description,
        "picture": picture,
        "picture_base64": pictureBase64,
        "release_date": releaseDate,
        "artist_id": artistId,
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

  Future<dynamic> deleteAlbumById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}albums/delete-album-by-id/$id');
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
