import 'dart:math';

import '../services/service_mng.dart';

class Artist {
  late int _id;
  late String _name;
  String? _description;
  late String _picture;

  static String getUrlImg(String picture, int id) {
    return "${ServiceManager.imgUrl}artist/${id}_$picture.png";
  }

  static List<String> getFields() {
    return ['id', 'name', 'description', 'picture'];
  }

  Artist(
      {required int id,
      required String name,
      required String description,
      required String picture}) {
    _id = id;
    _name = name;
    _description = description;
    _picture = picture;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Artist && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  @override
  String toString() {
    return 'Artist{_id: $_id, _name: $_name, _description: $_description, _picture: $_picture}';
  } // Factory constructor để tạo một instance từ một map (ví dụ từ JSON)

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
    );
  }

  //
  // Phương thức để chuyển đổi một Artist thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'picture': picture,
    };
  }
}
