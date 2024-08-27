import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  String frontUrl;
  final String _getAllUsersUrl = 'users/';
  final String _getUserForLoginWithPasswordUrl = 'users/get-user-for-login-with-password/';
  final String _getUserByEmailUrl = 'users/get-user-by-email/';
  final String _getUserByPhoneUrl = 'users/get-user-by-phone/';
  final String _getPasswordByEmailUrl = 'users/get-password-by-email/';
  final String _validateUserForClientUrl = 'users/validate-user-for-client/';
  final String _sendEmailForForgotPasswordUrl = 'users/send-email-for-forgot-password/';
  final String _createUserForLoginWithGoogleUrl = 'users/create-user-for-login-with-google/';
  final String _updateUserPictureByEmailUrl = 'users/update-user-picture-by-email/';
  final String _updateUserNameByEmailUrl = 'users/update-user-name-by-email/';
  final String _updateUserPhoneByEmailUrl = 'users/update-user-phone-by-email/';
  final String _updateUserBirthdateByEmailUrl = 'users/update-user-birthdate-by-email/';
  final String _updateUserPasswordByEmailUrl = 'users/update-user-password-by-email/';
  final String _updateUserByEmailUrl = 'users/update-user-by-email/';
  final String _loginWithPasswordUrl = 'users/login-with-password/';

  UserService(this.frontUrl);

  Future<dynamic> getAllUsers() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllUsersUrl');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getUserForLoginWithPassword({
    required String email,
    required String password,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getUserForLoginWithPasswordUrl');
      // Dùng phương thức post để bảo mật dữ liệu, tránh việc gửi dữ liệu trên url
      http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getUserByEmail({
    required String email,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getUserByEmailUrl$email');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getUserByPhone({
    required String phone,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getUserByPhoneUrl$phone');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getPasswordByEmail({
    required String email,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getPasswordByEmailUrl$email');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": responseData,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<bool> validateUserForClient({
    required String pictureBase64,
    required User user,
  }) async {
    try {
      final uri = Uri.parse('$frontUrl$_validateUserForClientUrl');
      final Map<String, dynamic> userData = {
        "email": user.email,
        "name": user.name,
        "birthdate": user.birthdate.toString(),
        "phone": user.phone,
        "password": user.password,
        "picture": user.picture,
        "user_type_id": user.user_type_id,
      };
      userData["otp"] = '';
      userData["picture_base64"] = pictureBase64;
      print('jsonEncode(userData): ${jsonEncode(userData)}');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Validate user thất bại: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Validate user thất bại: ${e}');
      return false;
    }
  }

  Future<bool> sendEmailForForgotPassword({
    required User user,
  }) async {
    try {
      final uri = Uri.parse('$frontUrl$_sendEmailForForgotPasswordUrl');
      final Map<String, dynamic> userData = {
        "email": user.email,
        "name": user.name,
        "birthdate": user.birthdate.toString(),
        "phone": user.phone,
        "password": user.password,
        "picture": user.picture,
        "user_type_id": user.user_type_id,
      };
      print('jsonEncode(userData): ${jsonEncode(userData)}');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('send_email_for_forgot_password thất bại: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('send_email_for_forgot_password thất bại: ${e}');
      return false;
    }
  }

  Future<dynamic> createUserForLoginWithGoogle({
    required String pictureBase64,
    required User user,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_createUserForLoginWithGoogleUrl');
      final Map<String, dynamic> userData = {
        "email": user.email,
        "name": user.name,
        "birthdate": user.birthdate.toString(),
        "phone": user.phone,
        "password": user.password,
        "picture": user.picture,
        "user_type_id": user.user_type_id,
      };
      userData["otp"] = '';
      userData["picture_base64"] = pictureBase64;
      print('jsonEncode(userData): ${jsonEncode(userData)}');
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

  Future<dynamic> updateUserPictureByEmail({
    required String email,
    required String newPictureBase64,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_updateUserPictureByEmailUrl$email');
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_picture_base64': newPictureBase64,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Update user picture successful');
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update picture: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> updateUserNameByEmail({
    required String email,
    required String newName,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_updateUserNameByEmailUrl$email');
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_name': newName,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Update user name successful');
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update name: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> updateUserPhoneByEmail({
    required String email,
    required String? phone,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_updateUserPhoneByEmailUrl$email');
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'new_phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Update user phone successful');
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update phone: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> updateUserBirthdateByEmail({
    required String email,
    required DateTime birthdate,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_updateUserBirthdateByEmailUrl$email');
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_birthdate': birthdate.toIso8601String(), // Convert DateTime to String
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Update user birthdate successful');
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update birthdate: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> updateUserPasswordByEmail({
    required String email,
    required String newPassword,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_updateUserPasswordByEmailUrl$email');
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
        print('Update user password successful');
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update password: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> loginWithPassword({
    required String email,
    required String password,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('$frontUrl$_loginWithPasswordUrl');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu khi thành công
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
      } else {
        // Xử lý lỗi khi không thành công
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
        print('Failed to update password: ${response.statusCode}');
      }
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }
}
