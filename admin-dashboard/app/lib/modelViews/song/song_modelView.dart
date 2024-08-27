import 'package:app/models/genre.dart';
import 'package:app/models/song.dart';

import '../../models/song.dart';
import '../../models/topic.dart';
import '../../services/service_mng.dart';

class SongModelviews {
  SongModelviews();

  Future<List<Song>> getAllSongs() async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getAllSongs();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<Song?> createSong({
    required String pictureBase64,
    required String mp3Base64,
    required String lyricBase64,
    required String name,
    required String picture,
    required String duration,
    required String lyric,
    required int album_id,
    required List<int> artist_ids,
    required List<int> genreIds,
    required List<int> topicIds,
  }) async {
    Song? song;
    final data = await ServiceManager.songService.createSong(
      pictureBase64: pictureBase64,
      mp3Base64: mp3Base64,
      name: name,
      picture: picture,
      duration: duration,
      lyric: lyric,
      lyricBase64: lyricBase64,
      genre_ids: genreIds,
      topic_ids: topicIds,
      album_id: album_id,
      artist_ids: artist_ids,
    );
    if (data['message'] == "OK") {
      song = Song.fromJson(data['data']);
      print(song.toString());
    } else {
      print(data);
    }
    return song;
  }

  Future<dynamic> updateSong(
      {required int id,
      required String pictureBase64,
      required String mp3Base64,
      required String name,
      required String picture,
      required String duration,
      required String lyric,
      required String lyricBase64,
      required List<int> topicIds,
      required List<int> genreIds,
      required int album_id,
      required List<int> artist_ids}) async {
    Song? song;
    final data = await ServiceManager.songService.updateSong(
      id: id,
      pictureBase64: pictureBase64,
      mp3Base64: mp3Base64,
      lyricBase64: lyricBase64,
      name: name,
      picture: picture,
      duration: duration,
      lyric: lyric,
      genreIds: genreIds,
      topicIds: topicIds,
      album_id: album_id,
      artist_ids: artist_ids,
    );
    if (data['message'] == "OK") {
      song = Song.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return song;
  }

  Future<bool> deleteSongById(int id) async {
    bool isDeleted = false;
    final data = await ServiceManager.songService.deleteSongById(id);
    if (data['message'] == "OK") {
      isDeleted = true;
    } else {
      print(data['message']);
    }
    return isDeleted;
  }

  Future<List<Map<String, dynamic>>> predictTopic(String base64String) async {
    List<Map<String, dynamic>> topicData = [];
    final data = await ServiceManager.songService.predictTopic(base64String);

    if (data['message'] == "OK") {
      List<dynamic> list = data['data']["topic_probabilities"] as List;
      topicData = list.map((item) {
        Map<String, dynamic> rs = {item[0]: "${((item[1]) * 100).ceil()}"};
        return rs;
      }).toList();
    } else {
      print(data['message']);
    }
    return topicData;
  }

  Future<List<Map<String, dynamic>>> predictGenre(String base64String) async {
    List<Map<String, dynamic>> genreData = [];
    final data = await ServiceManager.songService.predictGenre(base64String);

    if (data['message'] == "OK") {
      List<dynamic> list = data['data']["genre_probabilities"] as List;
      genreData = list.map((item) {
        Map<String, dynamic> rs = {item[0]: "${((item[1]) * 100).ceil()}"};
        return rs;
      }).toList();
    } else {
      print(data['message']);
    }
    return genreData;
  }
}
