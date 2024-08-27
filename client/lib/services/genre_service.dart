import 'dart:convert';
import 'package:http/http.dart' as http;

class GenreService {
  String frontUrl;
  final String _getAllGenresUrl = 'genres/get-all-genres-for-client';
  final String _getTop3GenresUrl = 'genres/get-top-3-genres';

  GenreService(this.frontUrl);

  Future<dynamic> getAllGenres() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getAllGenresUrl');
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

  Future<dynamic> getTop3Genres() async {
    dynamic jsonResponse;
    try {
      var url = Uri.parse('$frontUrl$_getTop3GenresUrl');
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
