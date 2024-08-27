import 'package:client/models/song_model.dart';

import '../configs/date_format_config.dart';
import '../services/service_mng.dart';

class Playlist {
  int _id;
  String _name;
  String _description;
  String _modifyDate;
  String _picture;
  bool _isAdmin;
  List<Song> _songs;

  Playlist({
    required int id,
    required String name,
    required String description,
    required String modifyDate,
    required String picture,
    required bool isAdmin,
    List<Song> songs = const [],
  })  : _id = id,
        _name = name,
        _description = description,
        _modifyDate = modifyDate,
        _picture = picture,
        _isAdmin = isAdmin,
        _songs = songs;

  // Factory constructor to create an instance from a map (e.g., from JSON)
  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<Song> songs = [];
    if (json.containsKey('songs') && json['songs'] is List) {
      var listJson = json['songs'] as List;
      songs = listJson.map((song) => Song.fromJson(song)).toList();
    }

    return Playlist(
      id: json['id'] != null ? json['id'] : 0,
      name: json['name'] != null && json['name'] is String ? json['name'] : '',
      description: json['description'] != null && json['description'] is String ? json['description'] : '',
      modifyDate: json['modify_date'] != null && json['modify_date'] is String
          ? DateFormatConfig.DateFormatForDisplay(json['modify_date'])
          : '',
      picture: json['picture'] != null && json['picture'] is String ? json['picture'] : '',
      isAdmin: json['is_admin'] != null && json['is_admin'] is bool ? json['is_admin'] : false,
      songs: songs,
    );
  }

  // Method to convert a Playlist instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'modify_date': _modifyDate,
      'picture': _picture,
      'is_admin': _isAdmin,
      'songs': _songs.map((song) => song.toJson()).toList(),
    };
  }

  int get id => _id;

  set id(int value) => _id = value;

  String get name => _name;

  set name(String value) => _name = value;

  String get description => _description;

  set description(String value) => _description = value;

  String get modifyDate => _modifyDate;

  set modifyDate(String value) => _modifyDate = value;

  String get picture => _picture;

  set picture(String value) => _picture = value;

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) => _isAdmin = value;

  List<Song> get songs => _songs;

  set songs(List<Song> value) => _songs = value;

  void addSong(Song song) {
    _songs.add(song);
  }

  void removeSong(Song song) {
    _songs.remove(song);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Playlist && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() {
    return 'Playlist{id: $_id, name: $_name, description: $_description, modifyDate: $_modifyDate, picture: $_picture, isAdmin: $_isAdmin, songs: $_songs}';
  }

  static String getUrlImg(String picture, int id) {
    return "${ServiceManager.imgUrl}playlist/${id}_$picture.png";
  }
}
