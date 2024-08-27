import 'package:app/models/album.dart';
import 'package:app/models/artist.dart';
import 'package:app/models/song.dart';

import '../../models/song.dart';
import '../../models/topic.dart';
import '../../services/service_mng.dart';

class AlbumModelview {
  AlbumModelview();

  Future<List<Album>> getAllAlbums() async {
    List<Album> albums = [];
    final data = await ServiceManager.albumService.getAllAlbum();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      albums = list.map((i) => Album.fromJson(i)).toList();
    } else {
      print(data);
    }
    return albums;
  }

  Future<List<Song>> getSongsByAlbumId(int id) async {
    List<Song> songs = [];
    final data = await ServiceManager.albumService.getSongsByAlbumId(id);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data);
    }
    return songs;
  }

  Future<List<Album>> getAlbumsByArtistId(int artist_id) async {
    List<Album> albums = [];
    final data =
        await ServiceManager.albumService.getAlbumsByArtistId(artist_id);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      albums = list.map((i) => Album.fromJson(i)).toList();
    } else {
      print(data);
    }
    return albums;
  }

  Future<Album?> createAlbum(
      {required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required int artistId,
      required String releaseDate}) async {
    Album? album;
    final data = await ServiceManager.albumService.createAlbum(
      pictureBase64: pictureBase64,
      name: name,
      picture: picture,
      description: description,
      artistId: artistId,
      releaseDate: releaseDate,
    );
    if (data['message'] == "OK") {
      album = Album.fromJson(data['data']);
    } else {
      print(data);
    }
    return album;
  }

  Future<Album?> updateAlbum(
      {required int id,
      required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required int artistId,
      required String releaseDate}) async {
    Album? album;
    final data = await ServiceManager.albumService.updateAlbumById(
      id: id,
      pictureBase64: pictureBase64,
      name: name,
      picture: picture,
      description: description,
      artistId: artistId,
      releaseDate: releaseDate,
    );
    if (data['message'] == "OK") {
      album = Album.fromJson(data['data']);
    } else {
      print(data);
    }
    return album;
  }

  Future<bool> deleteAlbumById(int id) async {
    bool result = false;
    final data = await ServiceManager.albumService.deleteAlbumById(id);
    if (data['message'] == "OK") {
      result = true;
    } else {
      print(data);
    }
    return result;
  }
}
