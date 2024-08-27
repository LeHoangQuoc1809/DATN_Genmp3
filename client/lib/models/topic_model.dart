import 'dart:math';

class Topic {
  late int _id;
  late String _name;
  String? _description;

  @override
  String toString() {
    return 'Topic{_id: $_id, _name: $_name, _description: $_description}';
  }


  Topic({required int id, required String name, required String description}) {
    _id = id;
    _name = name;
    _description = description;
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

  // Factory constructor để tạo một instance từ một map (ví dụ từ JSON)
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] != null ? json['id'] : 0,
      name: json['name'] != null && json['name'] is String ? json['name'] : '',
      description: json['description'] != null && json['description'] is String ? json['description'] : '',
    );
  }

  //
  // Phương thức để chuyển đổi một Topic thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
