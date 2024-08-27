import '../../models/artist_model.dart';
import '../../models/playlist_model.dart';
import '../../models/song_model.dart';

import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../services/service_mng.dart';

class PlaylistModelview {
  PlaylistModelview();

  Future<List<Playlist>> get50PlaylistsForSearch(String query) async {
    List<Playlist> playlists = [];
    final data = await ServiceManager.playlistService.get50PlaylistsForSearch(query);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      playlists = list.map((i) => Playlist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return playlists;
  }

  Future<Playlist?> createPlaylistForClient({
    required String user_email,
    required String name,
  }) async {
    Playlist? playlist;
    final data = await ServiceManager.playlistService.createPlaylistForClient(
      user_email: user_email,
      name: name,
    );
    if (data['message'] == "OK") {
      playlist = Playlist.fromJson(data['data']);
    } else {
      print(data);
    }
    return playlist;
  }

  Future<List<Playlist>> getAllPlaylistsByUserEmail({
    required String user_email,
  }) async {
    List<Playlist> playlists = [];
    final data = await ServiceManager.playlistService.getAllPlaylistsByUserEmail(user_email: user_email);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      playlists = list.map((i) => Playlist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return playlists;
  }
}
