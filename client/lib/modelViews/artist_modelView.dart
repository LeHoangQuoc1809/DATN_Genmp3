import '../../models/artist_model.dart';

import '../../services/service_mng.dart';
import 'dart:async';

class ArtistModelview {
  ArtistModelview();

  Future<List<Artist>> get50ArtistsForSearch(String query) async {
    List<Artist> artists = [];
    final data = await ServiceManager.artistService.get50ArtistsForSearch(query);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      artists = list.map((i) => Artist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return artists;
  }

  Future<List<Artist>> getTop5SimilarArtist(int id) async {
    List<Artist> artists = [];
    final data = await ServiceManager.artistService.getTop5SimilarArtist(id);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      artists = list.map((i) => Artist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return artists;
  }

  Future<List<Artist>> getAllArtists() async {
    List<Artist> artists = [];
    final data = await ServiceManager.artistService.getAllArtists();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      artists = list.map((i) => Artist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return artists;
  }

  Future<Artist?> getArtistById(int id) async {
    Artist? artist;
    final data = await ServiceManager.artistService.getArtistById(id);
    if (data['message'] == "OK") {
      artist = Artist.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return artist;
  }

  Future<Artist?> createArtist({
    required String pictureBase64,
    required String name,
    required String picture,
    required String description,
  }) async {
    Artist? artist;
    final data = await ServiceManager.artistService.createArtist(
      pictureBase64: pictureBase64,
      name: name,
      picture: picture,
      description: description,
    );
    if (data["message"] == "OK") {
      artist = Artist.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return artist;
  }

  Future<dynamic> updateArtist({
    required int id,
    required String pictureBase64,
    required String name,
    required String picture,
    required String description,
  }) async {
    Artist? artist;
    final data = await ServiceManager.artistService.updateArtist(
      id: id,
      pictureBase64: pictureBase64,
      name: name,
      picture: picture,
      description: description,
    );
    if (data["message"] == "OK") {
      artist = Artist.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return artist;
  }

  Future<bool> deleteArtistById(int id) async {
    bool result = false;
    final data = await ServiceManager.artistService.deleteArtistById(id);
    if (data['message'] == "OK") {
      result = true;
    } else {
      print(data['message']);
    }
    return result;
  }
}
