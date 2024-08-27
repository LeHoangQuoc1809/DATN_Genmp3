import 'dart:convert';

import 'package:http/http.dart' as http;

class UserTypeService {
  String frontUrl;

  UserTypeService(this.frontUrl);

  Future<dynamic> getUserTypeById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}user_types/get-user-type-by-id/$id');
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
