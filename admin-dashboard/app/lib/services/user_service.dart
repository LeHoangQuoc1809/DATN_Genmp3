import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  String frontUrl;

  UserService(this.frontUrl);

  Future<dynamic> getAllUsers() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}users/');
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
}
