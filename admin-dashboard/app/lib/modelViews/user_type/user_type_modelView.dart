import 'package:app/models/user.dart';
import 'package:app/models/user_type.dart';

import '../../services/service_mng.dart';

class UserTypeModelview {
  UserTypeModelview();

  Future<UserType?> getUserTypeById(int id) async {
    UserType? userType;
    final data = await ServiceManager.userTypeService.getUserTypeById(id);
    if (data['message'] == "OK") {
      userType = UserType.fromJson(data['data']);
    } else {
      print(data);
    }
    return userType;
  }
}
