import 'dart:math';

import 'package:client/configs/date_format_config.dart';

import '../services/service_mng.dart';

class User {
  late String _email;
  late String _name;
  late DateTime _birthdate;
  String? _phone;
  late String _password;
  late String _picture;
  late int _user_type_id;

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get birthdate => _birthdate;

  set birthdate(DateTime value) {
    _birthdate = value;
  }

  String? get phone => _phone;

  set phone(String? value) {
    _phone = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  int get user_type_id => _user_type_id;

  set user_type_id(int value) {
    _user_type_id = value;
  }

  User({
    required String email,
    required String name,
    required DateTime birthdate,
    String? phone,
    required String password,
    required String picture,
    required int user_type_id,
  })  : _email = email,
        _name = name,
        _birthdate = birthdate,
        _phone = phone,
        _password = password,
        _picture = picture,
        _user_type_id = user_type_id;

  @override
  String toString() {
    return 'User{_email: $_email, _name: $_name, _birthdate: $_birthdate, _phone: $_phone, _password: $_password, _picture: $_picture, _user_type_id: $_user_type_id}';
  }

  // Factory constructor để tạo một instance từ một map (ví dụ từ JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      birthdate: DateFormatConfig.DateFormatForUserResponse(json['birthdate']),
      phone: json['phone'],
      password: json['password'] ?? '',
      picture: json['picture'] ?? '',
      user_type_id: json['user_type_id'] ?? 1,
    );
  }

  // Phương thức để chuyển đổi một user thành JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'phone': phone,
      'password': password,
      'picture': picture,
      'user_type_id': user_type_id,
    };
  }

  // Phương thức lấy hình ảnh của user từ server
  static String getUrlImg(String picture) {
    return "${ServiceManager.imgUrl}user/$picture.png";
  }
}
