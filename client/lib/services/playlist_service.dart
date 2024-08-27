import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistService {
  String frontUrl;
  final String _createPlaylistForClientUrl = 'playlists/create-playlist-for-client/';
  final String _getAllPlaylistsByUserEmailUrl = 'playlists/get-all-playlists-by-user-email/';

  PlaylistService(this.frontUrl);

  Future<dynamic> get50PlaylistsForSearch(String query) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}playlists/get-top-50-playlists-for-search/${query}');
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

  Future<dynamic> createPlaylistForClient({
    required String user_email,
    required String name,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_createPlaylistForClientUrl');
      final Map<String, dynamic> playlistData = {
        "user_email": user_email,
        "name": name,
        "description": null,
        "modify_date": DateTime.now().toString(),
        "picture": null,
        "is_admin": 0,
      };
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(playlistData),
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
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

  Future<dynamic> getAllPlaylistsByUserEmail({
    required String user_email,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllPlaylistsByUserEmailUrl$user_email');
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
}
