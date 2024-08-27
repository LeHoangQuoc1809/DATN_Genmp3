import '../../services/service_mng.dart';
import '../models/user_model.dart';

class UserModelview {
  UserModelview();

  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    final data = await ServiceManager.userService.getAllUsers();
    if (data["data"] == "OK") {
      var list = data["data"] as List;
      users = list.map((i) => User.fromJson(i)).toList();
    } else {
      print(data);
    }
    return users;
  }

  Future<User?> getUserForLoginWithPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    final data = await ServiceManager.userService.getUserForLoginWithPassword(email: email, password: password);
    if (data['message'] == "OK") {
      user = User.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return user;
  }

  Future<User?> getUserByEmail({
    required String email,
  }) async {
    User? user;
    final data = await ServiceManager.userService.getUserByEmail(email: email);
    if (data['message'] == "OK") {
      user = User.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return user;
  }

  Future<User?> getUserByPhone({
    required String phone,
  }) async {
    User? user;
    final data = await ServiceManager.userService.getUserByPhone(phone: phone);
    if (data['message'] == "OK") {
      user = User.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return user;
  }

  Future<String?> getPasswordByEmail({
    required String email,
  }) async {
    String? password;
    final data = await ServiceManager.userService.getPasswordByEmail(email: email);
    if (data['message'] == "OK") {
      password = data['data'];
    } else {
      print(data['message']);
    }
    return password;
  }

  Future<bool> validateUserForClient({
    required String pictureBase64,
    required User user,
  }) async {
    final data = await ServiceManager.userService.validateUserForClient(
      pictureBase64: pictureBase64,
      user: user,
    );
    if (data) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendEmailForForgotPassword({
    required User user,
  }) async {
    final data = await ServiceManager.userService.sendEmailForForgotPassword(
      user: user,
    );
    if (data) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> createUserForLoginWithGoogle({
    required String pictureBase64,
    required User user,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.createUserForLoginWithGoogle(
      pictureBase64: pictureBase64,
      user: user,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<User?> updateUserPictureByEmail({
    required String email,
    required String newPictureBase64,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.updateUserPictureByEmail(
      email: email,
      newPictureBase64: newPictureBase64,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<User?> updateUserByName({
    required String email,
    required String newName,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.updateUserNameByEmail(
      email: email,
      newName: newName,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<User?> updateUserPhoneByEmail({
    required String email,
    required String? newPhone,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.updateUserPhoneByEmail(
      email: email,
      phone: newPhone,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<User?> updateUserBirthdateByEmail({
    required String email,
    required DateTime newBirthdate,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.updateUserBirthdateByEmail(
      email: email,
      birthdate: newBirthdate,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<User?> updateUserPasswordByEmail({
    required String email,
    required String newPassword,
  }) async {
    User? userResponse;
    final data = await ServiceManager.userService.updateUserPasswordByEmail(
      email: email,
      newPassword: newPassword,
    );
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<String?> loginWithPassword({
    required String email,
    required String password,
  }) async {
    String? sessionId;
    final data = await ServiceManager.userService.loginWithPassword(
      email: email,
      password: password,
    );
    if (data['message'] == "OK") {
      sessionId = data['data']['session_id'];
    } else {
      print(data);
    }
    return sessionId;
  }
}
