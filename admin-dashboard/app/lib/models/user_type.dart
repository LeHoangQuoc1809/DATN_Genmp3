class UserType {
  int _id;
  String _name;
  String _description;

  // Constructor
  UserType({
    required int id,
    required String name,
    required String description,
  })  : _id = id,
        _name = name,
        _description = description;

  // Factory constructor to create an instance from a map (e.g., from JSON)
  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Method to convert an instance to a map (e.g., to JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
    };
  }

  // Getters
  int get id => _id;

  String get name => _name;

  String get description => _description;

  // Setters
  set id(int id) {
    _id = id;
  }

  set name(String name) {
    _name = name;
  }

  set description(String description) {
    _description = description;
  }
}
