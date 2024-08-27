import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../services/service_mng.dart';

class SongModelviews {
  SongModelviews();

  Future<List<Song>> getAllSongs() async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getAllSongs();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> getTop12RecentSongs() async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getTop12RecentSongs();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> getTop5SongsListenCountMax() async {
    List<Song> songs = [];
    try {
      final data = await ServiceManager.songService.getTop5SongsListenCountMax();
      if (data['message'] == "OK") {
        var list = data['data'] as List;
        songs = list.map((i) => Song.fromJson(i)).toList();
      } else {
        print(data['message']);
      }
    } catch (e) {
      print('e: $e');
    }
    return songs;
  }

  Future<List<Song>> getTop100SongsListenCountMax() async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getTop100SongsListenCountMax();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> getTop100SongsListenCountMaxByGenreId({
    required int genreId,
  }) async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getTop100SongsListenCountMaxByGenreId(genreId: genreId);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> getTop100SongsListenCountMaxByTopicId({
    required int topicId,
  }) async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getTop100SongsListenCountMaxByTopicId(topicId: topicId);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> get50SongsForSearch(String query) async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.get50SongsForSearch(query);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }

  Future<List<Song>> getAllSongsByPlaylistId({
    required int playlist_id,
  }) async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getAllSongsByPlaylistId(playlist_id: playlist_id);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return songs;
  }
}
