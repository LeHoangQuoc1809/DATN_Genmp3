import 'package:app/models/user_type.dart';

import '../services/service_mng.dart';

class User {
  String _name;
  String _email;
  String _birthdate;
  String _password;
  String _picture;
  String _phone;
  int _user_type_id;
  UserType? _userType;

  int get user_type_id => _user_type_id;

  set user_type_id(int value) {
    _user_type_id = value;
  }

  User({
    required String name,
    required String email,
    required String birthdate,
    required String password,
    required String picture,
    required String phone,
    required int userTypeId,
  })  : _name = name,
        _email = email,
        _birthdate = birthdate,
        _password = password,
        _picture = picture,
        _phone = phone,
        _user_type_id = userTypeId;

  static String getUrlImg(String emal) {
    return "${ServiceManager.imgUrl}user/${emal}.png";
  }

  static List<String> getFields() {
    return [
      "picture",
      "email",
      "name",
      "birthdate",
      "phone",
      "type",
    ];
  }

  static List<String> getDetailFields() {
    return [
      "picture",
      "id",
      "name",
      "birthdate",
      "phone",
      "user_type_id",
    ];
  }

  // Factory constructor to create an instance from a map (e.g., from JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    // Validate JSON data
    validateJson(json);
    return User(
      name: json['name'],
      email: json['email'],
      birthdate: json['birthdate'],
      password: json['password'],
      picture: json['picture'],
      phone: json['phone'],
      userTypeId: json['user_type_id'],
    );
  }

  // Method to convert a user to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'email': _email,
      'birthdate': _birthdate,
      'password': _password,
      'picture': _picture,
      'phone': _phone,
      'user_type_id': _user_type_id,
    };
  }

  String get name => _name;

  set name(String value) => _name = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get birthdate => _birthdate;

  set birthdate(String value) => _birthdate = value;

  String get password => _password;

  set password(String value) => _password = value;

  String get picture => _picture;

  set picture(String value) => _picture = value;

  String get phone => _phone;

  set phone(String value) => _phone = value;

  int get userTypeId => _user_type_id;

  set userTypeId(int value) => _user_type_id = value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          _email == other._email;

  @override
  int get hashCode => _email.hashCode;

  @override
  String toString() {
    return 'User{_name: $_name, _email: $_email, _birthdate: $_birthdate, _password: $_password, _picture: $_picture, _phone: $_phone, _user_type_id: $_user_type_id}';
  }

  // Method to validate the JSON input
  static void validateJson(Map<String, dynamic> json) {
    if (!json.containsKey('name') || json['name'] == null) {
      throw Exception('Missing or null "name"');
    }
    if (!json.containsKey('email') || json['email'] == null) {
      throw Exception('Missing or null "email"');
    }
    if (!json.containsKey('birthdate') || json['birthdate'] == null) {
      throw Exception('Missing or null "birthdate"');
    }
    if (!json.containsKey('password') || json['password'] == null) {
      throw Exception('Missing or null "password"');
    }
    if (!json.containsKey('picture') || json['picture'] == null) {
      throw Exception('Missing or null "picture"');
    }
    if (!json.containsKey('phone') || json['phone'] == null) {
      json['phone'] = "";
    }
    if (!json.containsKey('user_type_id') || json['user_type_id'] == null) {
      throw Exception('Missing or null "user_type_id"');
    }

    // Add additional validation as needed, for example:
    if (json['email'] is! String || !json['email'].contains('@')) {
      throw Exception('Invalid "email" format');
    }
    if (json['user_type_id'] is! int) {
      throw Exception('"user_type_id" should be an integer');
    }
  }

  UserType? get userType => _userType;

  set userType(UserType? value) {
    _userType = value;
  }
}
