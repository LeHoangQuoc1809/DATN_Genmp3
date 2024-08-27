import 'package:client/models/song_model.dart';

import '../services/service_mng.dart';
import 'artist_model.dart';

class Album {
  int _id;
  String _name;
  String _releaseDate;
  String _picture;
  int _artistId;
  String? _description;

  Artist? _artist;

  List<Song> _songs = [];

  factory Album.fromJson(Map<String, dynamic> json) {
    //
    // if (json['id'] == null ||
    //     json['name'] == null ||
    //     json['release_date'] == null ||
    //     json['picture'] == null ||
    //     json['artist_id'] == null) {
    //   throw ArgumentError('Missing required fields in JSON');
    // }
    //
    List<Song> songs = [];
    if (json.containsKey('songs') && json['songs'] is List) {
      var listJson = json['songs'] as List;
      songs = listJson.map((song) => Song.fromJson(song)).toList();
    }
    return Album(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      releaseDate: json['release_date'] ?? "",
      picture: json['picture'] ?? "",
      artistId: json['artist_id'] ?? 1,
      description: json['description'] ?? "",
      songs: songs,
    );
  }

  //
  // Phương thức để chuyển đổi một Artist thành JSON
  // Convert Album instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'release_date': _releaseDate,
      'picture': _picture,
      'artist_id': _artistId,
      'description': _description,
      'songs': _songs.map((song) => song.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Album{_id: $_id, _name: $_name, _releaseDate: $_releaseDate, _picture: $_picture, _artistId: $_artistId, _description: $_description}';
  }

  static String getUrlImg(String picture, int id) {
    return "${ServiceManager.imgUrl}album/${id}_$picture.png";
  }

  static List<String> getFields() {
    return ['id', 'name', 'artist', 'picture'];
  }

  Album({
    required int id,
    required String name,
    required String releaseDate,
    required String picture,
    required int artistId,
    required String description,
    List<Song> songs = const [],
    Artist? artist,
  })  : _id = id,
        _name = name,
        _releaseDate = releaseDate,
        _picture = picture,
        _artistId = artistId,
        _description = description,
        _songs = songs,
        _artist = artist;

  int get id => _id;

  set id(int value) => _id = value;

  String get name => _name;

  set name(String value) => _name = value;

  String get releaseDate => _releaseDate;

  set releaseDate(String value) => _releaseDate = value;

  String get picture => _picture;

  set picture(String value) => _picture = value;

  int get artistId => _artistId;

  set artistId(int value) => _artistId = value;

  String? get description => _description;

  set description(String? value) => _description = value;

  Artist? get artist => _artist;

  set artist(Artist? value) => _artist = value;

  List<Song> get songs => _songs;

  set songs(List<Song> value) => _songs = value;
}
