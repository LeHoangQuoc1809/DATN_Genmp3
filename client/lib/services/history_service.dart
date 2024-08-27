import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryService {
  String frontUrl;
  final String _getHistorysByUserEmailUrl = 'historys/get-historys-by-user-email/';

  HistoryService(this.frontUrl);

  Future<dynamic> getHistorysByUserEmail({
    required String email,
  }) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getHistorysByUserEmailUrl$email');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {"message": "OK", "data": responseData};
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": response.statusCode,
        };
      }
      //return response;
    } catch (e) {
      jsonResponse = {"message": e};
    }
    return jsonResponse;
  }
}
