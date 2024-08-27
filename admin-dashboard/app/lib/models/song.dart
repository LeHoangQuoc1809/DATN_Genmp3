import 'dart:math';

import 'package:app/models/genre.dart';
import 'package:app/models/topic.dart';

import '../services/service_mng.dart';
import 'artist.dart';

class Song {
  late int _id;
  late String _name;
  late Duration _duration;
  late String _picture;
  int _listenCount = 0;
  late String _lyric;

  //late List<int> _artist_ids;
  late List<Topic> _topics;
  late List<Genre> _genres;
  late int _album_id;

  //List artist
  List<Artist> _artists = [];

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Song({
    required int id,
    required String name,
    required Duration duration,
    required String picture,
    required int listenCount,
    required String lyric,
    required List<Topic> topics,
    required List<Genre> genres,
    required int album_id,
    required List<Artist> artists,
  }) {
    _id = id;
    _name = name;
    _duration = duration;
    _picture = picture;
    _listenCount = listenCount;
    _lyric = lyric;
    _topics = topics;
    _album_id = album_id;
    _genres = genres;
    _artists = artists;
  }

  List<Artist> get artists => _artists;

  set artists(List<Artist> value) {
    _artists = value;
  }

  static Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  // Factory constructor để tạo một instance từ một map (ví dụ từ JSON)
  factory Song.fromJson(Map<String, dynamic> json) {
    List<Artist> artists = [];
    List<Topic> topics = [];
    List<Genre> genres = [];
    if (json.containsKey('artists') && json['artists'] is List) {
      var listJson = json['artists'] as List;
      artists = listJson.map((artist) => Artist.fromJson(artist)).toList();
    }
    if (json.containsKey('topics') && json['topics'] is List) {
      var listJson = json['topics'] as List;
      topics = listJson.map((topic) => Topic.fromJson(topic)).toList();
    }
    if (json.containsKey('genres') && json['genres'] is List) {
      var listJson = json['genres'] as List;
      genres = listJson.map((genre) => Genre.fromJson(genre)).toList();
    }
    print("json:${json}");
    return Song(
      id: json['id'],
      name: json['name'],
      duration: _parseDuration(json['duration']),
      listenCount: json['listen_count'],
      lyric: json['lyric'] != null ? json['lyric'] : "",
      picture: json['picture'],
      album_id: json['album_id'],
      topics: topics,
      genres: genres,
      artists: artists,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'duration': _duration
          .toString()
          .split('.')
          .first, // Chuyển đổi thành chuỗi hh:mm:ss
      'picture': _picture,
      'lyric': _lyric,
      'listen_count': _listenCount,
      'genres': _genres,
      'topics': _topics,
      'album_id': _album_id,
      'artists': _artists,
    };
  }

  static String getUrlLyric(int id) {
    return "${ServiceManager.lyricUrl}${id}.txt";
  }

  static String getUrlImg(String picture, int id) {
    return "${ServiceManager.imgUrl}song/${id}_$picture.png";
  }

  static String getUrlMp3(int id) {
    return "${ServiceManager.mp3Url}song/${id}.mp3";
  }

  static List<String> getFields() {
    return ["picture", "id", "name", "artists", "LC"];
  }

  @override
  String toString() {
    return 'Song{_id: $_id, _name: $_name, _duration: $_duration, _picture: $_picture, _listenCount: $_listenCount, _lyric: $_lyric, _topics: ${_topics.toString()}, _genres: ${_genres.toString()}, _album_id: $_album_id, _artists: $_artists}';
  }

  static List<String> getDetailFields() {
    return [
      "picture",
      "id",
      "name",
      "duration",
      "lyric",
      "topics",
      "album",
      "genres",
      "artists",
      "listen Count"
    ];
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Duration get duration => _duration;

  set duration(Duration value) {
    _duration = value;
  }

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  int get listenCount => _listenCount;

  set listenCount(int value) {
    _listenCount = value;
  }

  String get lyric => _lyric;

  set lyric(String value) {
    _lyric = value;
  }

  List<Topic> get topics => _topics;

  set topics(List<Topic> value) {
    _topics = value;
  }

  List<Genre> get genres => _genres;

  set genres(List<Genre> value) {
    _genres = value;
  }

  int get album_id => _album_id;

  set album_id(int value) {
    _album_id = value;
  }
}
