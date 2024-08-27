import 'dart:ffi';

import '../../services/service_mng.dart';
import '../models/user_model.dart';

class VerifyModelview {
  VerifyModelview();

  Future<User?> otpResendForCreateUser({
    required User user,
    required String otp,
  }) async {
    User? userResponse;
    final data = await ServiceManager.verifyService.otpResendForCreateUser(user: user, otp: otp);
    if (data['message'] == "OK") {
      userResponse = User.fromJson(data['data']);
    } else {
      print(data);
    }
    return userResponse;
  }

  Future<bool> otpResendForForgotPassword({
    required User user,
    required String otp,
  }) async {
    final data = await ServiceManager.verifyService.otpResendForForgotPassword(user: user, otp: otp);
    if (data) {
      return true;
    } else {
      return false;
    }
  }
}
