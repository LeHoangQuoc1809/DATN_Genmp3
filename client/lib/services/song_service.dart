import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/song_model.dart';

class SongService {
  String frontUrl;
  final String _getAllSongsUrl = 'songs/';
  final String _getTop12RecentSongsUrl = 'songs/get-top-12-recent-songs';
  final String _getTop5SongsListenCountMaxUrl = 'songs/get-top-5-songs-listen-count-max';
  final String _getTop100SongsListenCountMaxUrl = 'songs/get-top-100-songs-listen-count-max';
  final String _getTop100SongsListenCountMaxByGenreIdUrl = 'songs/get-top-100-songs-listen-count-max-by-genre-id/';
  final String _getTop100SongsListenCountMaxByTopicIdUrl = 'songs/get-top-100-songs-listen-count-max-by-topic-id/';
  final String _getAllSongsByPlaylistIdUrl = 'songs/get-all-songs-by-playlist-id/';

  SongService(this.frontUrl);

  Future<dynamic> getAllSongs() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllSongsUrl');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> getTop12RecentSongs() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop12RecentSongsUrl');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> getTop5SongsListenCountMax() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop5SongsListenCountMaxUrl');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> getTop100SongsListenCountMax() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop100SongsListenCountMaxUrl');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> getTop100SongsListenCountMaxByGenreId({
    required int genreId,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop100SongsListenCountMaxByGenreIdUrl$genreId');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> getTop100SongsListenCountMaxByTopicId({
    required int topicId,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop100SongsListenCountMaxByTopicIdUrl$topicId');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }

  Future<dynamic> get50SongsForSearch(String query) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/get-top-50-songs-for-search/${query}');
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

  Future<dynamic> getAllSongsByPlaylistId({
    required int playlist_id,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllSongsByPlaylistIdUrl$playlist_id');
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
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }
}
