import 'dart:convert';

import 'package:http/http.dart' as http;

class TopicService {
  String frontUrl;

  TopicService(this.frontUrl);

  Future<dynamic> getAllTopics() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}topics/get-all-topics-for-admin-dashboard');
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
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> getTopicById(int topic_id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}topics/get-topic-by-id/$topic_id');
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
      //return response;
    } catch (e) {
      jsonResponse = {
        "message": "Failed",
        "data": e,
      };
    }
    return jsonResponse;
  }

  Future<dynamic> createTopic({required String name, required String description}) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('${frontUrl}topics/create-topic/');
      final Map<String, dynamic> topicData = {
        "name": name,
        "description": description,
      };
      //
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(topicData),
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

  Future<dynamic> updateTopic({
    required int id,
    required String name,
    required String description,
  }) async {
    dynamic jsonResponse;
    try {
      final uri = Uri.parse('${frontUrl}topics/update-topic-by-id/$id');
      final Map<String, dynamic> topicData = {
        "name": name,
        "description": description,
      };
      //
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(topicData),
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

  Future<dynamic> deleteTopicById(int id) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}topics/delete-topic-by-id/$id');
      http.Response response = await http.delete(url);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));
        jsonResponse = {
          "message": "OK",
          "data": true,
        };
      } else {
        jsonResponse = {
          "message": "Failed",
          "data": false,
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
