import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class VerifyService {
  String frontUrl;
  final String _otpResendForCreateUserUrl = 'verifys/otp-resend-for-create-user/';
  final String _otpResendForForgotPasswordUrl = 'verifys/otp-resend-for-forgot-password/';

  VerifyService(this.frontUrl);

  Future<dynamic> otpResendForCreateUser({
    required User user,
    required String otp,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_otpResendForCreateUserUrl');
      final Map<String, dynamic> userData = {
        'email': user.email,
        'name': user.name,
        'birthdate': user.birthdate.toString(),
        'phone': user.phone,
        'password': user.password,
        'picture': user.picture,
        'user_type_id': user.user_type_id,
      };
      userData["picture_base64"] = '';
      userData["otp"] = otp;
      print('jsonEncode(userData): ${jsonEncode(userData)}');
      // Gọi API để gửi lại OTP
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Create user thành công');
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Create user thất bại: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<bool> otpResendForForgotPassword({
    required User user,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse('$frontUrl$_otpResendForForgotPasswordUrl');
      final Map<String, dynamic> userData = {
        'email': user.email,
        'name': user.name,
        'birthdate': user.birthdate.toString(),
        'phone': user.phone,
        'password': user.password,
        'picture': user.picture,
        'user_type_id': user.user_type_id,
      };
      userData["picture_base64"] = '';
      userData["otp"] = otp;
      print('jsonEncode(userData): ${jsonEncode(userData)}');
      // Gọi API để gửi lại OTP
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        print('otpResendForForgotPassword thành công');
        return true;
      } else {
        print('otpResendForForgotPassword thất bại: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('otpResendForForgotPassword thất bại: ${e}');
      return false;
    }
  }
}
