import 'dart:convert';

import 'package:http/http.dart' as http;

class TopicService {
  String frontUrl;
  final String _getAllTopicsUrl = 'topics/get-all-topics-for-client';
  final String _getTop3TopicsUrl = 'topics/get-top-3-topics';

  TopicService(this.frontUrl);

  Future<dynamic> getAllTopics() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllTopicsUrl');
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

  Future<dynamic> getTop3Topics() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop3TopicsUrl');
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
