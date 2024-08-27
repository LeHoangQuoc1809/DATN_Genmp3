import 'package:client/models/song_model.dart';
import 'package:client/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaticData {
  static User? currentlyUser;

  static Future<String> loadBase64StringLyric({required int songId}) async {
    String base64 = "";
    String url = Song.getUrlLyric(songId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
      print("base64:$base64");
    } else {
      throw Exception('Failed to load Lyric');
    }
    return base64;
  }

  static Future<String> loadBase64StringMp3({required int songId}) async {
    String base64 = "";
    String url = Song.getUrlMp3(songId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
    } else {
      throw Exception('Failed to load mp3');
    }
    return base64;
  }

  static Future<String> loadBase64StringPicture({required int songId, required String picture}) async {
    String base64 = "";
    String url = Song.getUrlImg(picture, songId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
    return base64;
  }
}
