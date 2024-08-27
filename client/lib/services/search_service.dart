import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  String frontUrl;

  SearchService(this.frontUrl);

  Future<dynamic> getTop5Search(String query) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}searchs/search/$query');
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

  Future<dynamic> get50SongsForSearch(String query) async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('${frontUrl}songs/get-top-50-songs-for-search/${query}');
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
}
