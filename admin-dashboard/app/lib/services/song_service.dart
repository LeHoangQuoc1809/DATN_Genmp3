import 'dart:html';
import 'dart:typed_data';
import 'dart:async';
import 'package:app/models/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SongService {
  String frontUrl;

  SongService(this.frontUrl);

  Future<dynamic> predictGenre(String base64String) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}ais/predict-genre/');
      final Map<String, dynamic> data = {
        "mp3_base64": base64String,
      };
      //
      final response = await http.post(
        url,
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
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> predictTopic(String base64String) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}ais/predict-topic/');
      final Map<String, dynamic> songData = {
        "txt_base64": base64String,
      };
      //
      final response = await http.post(
        url,
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
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getArtistSongBySongId(int song_id) async {
    dynamic jsonResponse;
    print("song_id:${song_id}");
    try {
      var url = Uri.parse(
          '${frontUrl}artist_songs/get-artist-songs-by-song-id/${song_id}');
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

  Future<dynamic> getSongsByAlbumId(int album_id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/get-songs-by-album-id/${album_id}');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
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

  Future<dynamic> getAllSongs() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/');
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

  Future<dynamic> createSong(
      {required String pictureBase64,
      required String mp3Base64,
      required String lyricBase64,
      required String name,
      required String picture,
      required String duration,
      required String lyric,
      required int album_id,
      required List<int> genre_ids,
      required List<int> topic_ids,
      required List<int> artist_ids}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}songs/create-song/'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "name": name,
        "duration": duration,
        "picture": picture,
        "lyric": lyric,
        "album_id": album_id,
        "topic_ids": topic_ids,
        "genre_ids": genre_ids,
      };
      //
      songData['mp3_base64'] = mp3Base64;
      songData['picture_base64'] = pictureBase64;
      songData['artist_ids'] = artist_ids;
      songData['lyric_base64'] = lyricBase64;
      print(songData["duration"]);
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

  Future<dynamic> updateSong(
      {required int id,
      required String pictureBase64,
      required String mp3Base64,
      required String name,
      required String picture,
      required String duration,
      required String lyricBase64,
      required List<int> topicIds,
      required List<int> genreIds,
      required String lyric,
      required int album_id,
      required List<int> artist_ids}) async {
    print(
        "${id}\n${name}\n${duration}\n${album_id}\n${artist_ids}\n${pictureBase64}");
    dynamic jsonResponse;
    try {
      final uri = Uri.parse(
          '${frontUrl}songs/update-song-by-id/${id}'); // Thay đổi URL của bạn ở đây
      final Map<String, dynamic> songData = {
        "id": id,
        "name": name,
        "duration": duration,
        "picture": picture,
        "lyric": lyric,
        "album_id": album_id,
        "topic_ids": topicIds,
        "genre_ids": genreIds,
      };
      //
      songData['mp3_base64'] = mp3Base64;
      songData['picture_base64'] = pictureBase64;
      songData['artist_ids'] = artist_ids;
      songData['lyric_base64'] = lyricBase64;
      print(songData["duration"]);
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

  Future<dynamic> deleteSongById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/delete-song-by-id/$id');
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
