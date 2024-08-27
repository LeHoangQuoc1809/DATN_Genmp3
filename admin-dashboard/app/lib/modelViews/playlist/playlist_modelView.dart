import 'package:app/models/artist.dart';
import 'package:app/models/playlist.dart';
import 'package:app/models/song.dart';

import '../../models/song.dart';
import '../../models/topic.dart';
import '../../services/service_mng.dart';

class PlaylistModelview {
  PlaylistModelview();

  Future<List<Playlist>> getAllPlaylists() async {
    List<Playlist> playlists = [];
    final data = await ServiceManager.playlistService.getAllPlaylists();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      playlists = list.map((i) => Playlist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return playlists;
  }

  Future<Playlist?> createPlaylist(
      {required String pictureBase64,
      required String name,
      required String picture,
      required String description,
      required List<int> song_ids}) async {
    Playlist? playlist;
    final data = await ServiceManager.playlistService.createPlaylist(
      pictureBase64: pictureBase64,
      name: name,
      picture: picture,
      description: description,
      song_ids: song_ids,
    );
    if (data['message'] == "OK") {
      playlist = Playlist.fromJson(data['data']);
    } else {
      print(data);
    }
    return playlist;
  }
}
