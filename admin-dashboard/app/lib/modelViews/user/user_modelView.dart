import 'package:app/models/user.dart';

import '../../models/topic.dart';
import '../../services/service_mng.dart';

class UserModelview {
  UserModelview();

  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    final data = await ServiceManager.userService.getAllUsers();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      users = list.map((i) => User.fromJson(i)).toList();
    } else {
      print(data);
    }
    return users;
  }
}
