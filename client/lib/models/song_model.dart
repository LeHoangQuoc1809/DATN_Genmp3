import 'package:client/models/genre_model.dart';
import 'package:client/models/playlist_model.dart';
import 'package:client/models/topic_model.dart';
import 'package:client/models/user_model.dart';
import '../services/service_mng.dart';
import 'artist_model.dart';

class Song {
  late int _id;
  late String _name;
  late Duration _duration;
  late String _picture;
  late int _listenCount;
  late String _lyric;
  late int _album_id;
  DateTime? releaseDate;

  // List artist
  List<Artist> _artists = [];

  // List genre
  List<Genre> _genres = [];

  // List topic
  List<Topic> _topics = [];

  // List playlist
  List<Playlist> _playlists = [];

  // List user
  List<User> _users = [];

  int get id => _id;

  String get name => _name;

  Duration get duration => _duration;

  String get picture => _picture;

  int get listenCount => _listenCount;

  String get lyric => _lyric;

  int get album_id => _album_id;

  List<Artist> get artists => _artists;

  List<Genre> get genres => _genres;

  List<Topic> get topics => _topics;

  List<Playlist> get playlists => _playlists;

  List<User> get users => _users;

  set artists(List<Artist> value) {
    _artists = value;
  }

  set users(List<User> value) {
    _users = value;
  }

  set playlists(List<Playlist> value) {
    _playlists = value;
  }

  set topics(List<Topic> value) {
    _topics = value;
  }

  set genres(List<Genre> value) {
    _genres = value;
  }

  set album_id(int value) {
    _album_id = value;
  }

  set lyric(String value) {
    _lyric = value;
  }

  set listenCount(int value) {
    _listenCount = value;
  }

  set picture(String value) {
    _picture = value;
  }

  set duration(Duration value) {
    _duration = value;
  }

  set name(String value) {
    _name = value;
  }

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
    required int album_id,
    this.releaseDate,
    required List<Artist> artists,
    required List<Genre> genres,
    required List<Topic> topics,
  }) {
    _id = id;
    _name = name;
    _duration = duration;
    _picture = picture;
    _listenCount = listenCount;
    _lyric = lyric;
    _album_id = album_id;
    _artists = artists;
    _genres = genres;
    _topics = topics;
  }

  @override
  String toString() {
    return 'Song{_id: $_id, _name: $_name, _duration: $_duration, _picture: $_picture, _listenCount: $_listenCount, _lyric: $_lyric, _album_id: $_album_id, _artists: $_artists, _genres: $_genres, _topics: $_topics, _playlists: $_playlists, _users: $_users}';
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
    if (json.containsKey('artists') && json['artists'] is List) {
      var listJson = json['artists'] as List;
      artists = listJson.map((artist) => Artist.fromJson(artist)).toList();
    }
    List<Genre> genres = [];
    if (json.containsKey('genres') && json['genres'] is List) {
      var listJson = json['genres'] as List;
      genres = listJson.map((genre) => Genre.fromJson(genre)).toList();
    }
    List<Topic> topics = [];
    if (json.containsKey('topics') && json['topics'] is List) {
      var listJson = json['topics'] as List;
      topics = listJson.map((topic) => Topic.fromJson(topic)).toList();
    }
    // Kiểm tra duration trước khi gọi _parseDuration
    Duration parsedDuration;
    if (json['duration'] != null && json['duration'] is String) {
      parsedDuration = _parseDuration(json['duration']);
    } else {
      parsedDuration = Duration();
    }
    // Kiểm tra và lấy release_date của song dựa vào release_date của album
    DateTime? releaseDate;
    if (json.containsKey('album') && json['album'] is Map) {
      var album = json['album'] as Map<String, dynamic>;
      if (album.containsKey('release_date') && album['release_date'] is String) {
        releaseDate = DateTime.parse(album['release_date']);
      }
    }
    return Song(
      id: json['id'] != null ? json['id'] : 0,
      name: json['name'] != null && json['name'] is String ? json['name'] : '',
      duration: parsedDuration,
      listenCount: json['listen_count'] != null ? json['listen_count'] : 0,
      lyric: json['lyric'] != null && json['lyric'] is String ? json['lyric'] : '',
      picture: json['picture'] != null && json['picture'] is String ? json['picture'] : '',
      album_id: json['album_id'] != null ? json['album_id'] : 0,
      releaseDate: releaseDate,
      artists: artists,
      genres: genres,
      topics: topics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'duration': _duration.toString().split('.').first, // Chuyển đổi thành chuỗi hh:mm:ss
      'picture': _picture,
      'lyric': _lyric,
      'listen_count': _listenCount,
      'album_id': _album_id,
      'artists': _artists,
      // 'artists': _artists.map((artist) => artist.toJson()).toList(),
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

  String getArtistNamesString() {
    return artists.map((art) => art.name).join(', ');
  }
}
