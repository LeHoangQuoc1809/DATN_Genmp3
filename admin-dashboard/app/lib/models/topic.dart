import 'dart:math';

class Topic {
  late int _id;
  late String _name;
  String? _description;

  @override
  String toString() {
    // Formatting each property on a new line with a table-like structure.
    return 'ID                    : $id\n'
        'Name             : $name\n'
        'Description   : ${description ?? 'N/A'}';
  }

  static List<String> getFields() {
    return ['id', 'name', 'description'];
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

  factory Topic.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError('The provided JSON map is null.');
    }

    return Topic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

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
