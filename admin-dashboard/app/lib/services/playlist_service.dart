import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistService {
  String frontUrl;

  PlaylistService(this.frontUrl);

  Future<dynamic> getAllPlaylists() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}playlists/');
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

  Future<dynamic> createPlaylist(
      {required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required List<int> song_ids}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}playlists/create-playlist/'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "name": name,
        "description": description,
        "modify_date": DateTime.now().toString(),
        "picture": picture,
        "song_ids": song_ids,
        "picture_base64": pictureBase64,
        "song_ids": song_ids,
      };
      //
      //
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(songData),
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
}
