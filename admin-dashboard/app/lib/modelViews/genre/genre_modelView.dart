import 'package:app/models/genre.dart';

import '../../models/song.dart';
import '../../services/service_mng.dart';

class GenreModelview {
  GenreModelview();

  Future<List<Genre>> getAllGenres() async {
    List<Genre> genres = [];
    final data = await ServiceManager.genreService.getAllGenres();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      genres = list.map((i) => Genre.fromJson(i)).toList();
    } else {
      print(data);
    }
    return genres;
  }

  Future<List<Song>> getSongsByGenreId(int genre_id) async {
    List<Song> songs = [];
    final data = await ServiceManager.genreService.getGenreById(genre_id);
    if (data['message'] == "OK") {
      var list = data['data']['songs'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data);
    }
    return songs;
  }

  Future<Genre?> createGenre({
    required String name,
    required String description,
  }) async {
    final data = await ServiceManager.genreService
        .createGenre(name: name, description: description);
    Genre? newGenre;
    if (data['message'] == "OK") {
      newGenre = Genre.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return newGenre;
  }

  Future<Genre?> updateGenre({
    required int id,
    required String name,
    required String description,
  }) async {
    final data = await ServiceManager.genreService
        .updateGenreById(id: id, name: name, description: description);
    Genre? newGenre;
    if (data['message'] == "OK") {
      newGenre = Genre.fromJson(data['data']);
    } else {
      print(data['message']);
    }
    return newGenre;
  }

  Future<bool> deleteGenreById({required int id}) async {
    bool isDeleted = false;
    final data = await ServiceManager.genreService.deleteGenreById(id);
    if (data['message'] == "OK") {
      isDeleted = true;
    } else {
      print(data['message']);
    }
    return isDeleted;
  }
}
