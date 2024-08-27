class History {
  late int _id;
  late DateTime _time;
  late String _user_email;
  late int _song_id;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  DateTime get time => _time;

  int get song_id => _song_id;

  set song_id(int value) {
    _song_id = value;
  }

  String get user_email => _user_email;

  set user_email(String value) {
    _user_email = value;
  }

  set time(DateTime value) {
    _time = value;
  }

  History(this._id, this._time, this._user_email, this._song_id);

  @override
  String toString() {
    return 'History{_id: $_id, _time: $_time, _user_email: $_user_email, _song_id: $_song_id}';
  }

  // Factory constructor để tạo một instance từ một map (ví dụ từ JSON)
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      json['id'],
      DateTime.parse(json['time']),
      json['user_email'],
      json['song_id'],
    );
  }

  // Phương thức để chuyển đổi một History thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'user_email': user_email,
      'song_id': song_id,
    };
  }
}
