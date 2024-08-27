import 'package:client/models/album_model.dart';

import '../../models/artist_model.dart';
import '../../models/playlist_model.dart';
import '../../models/song_model.dart';

import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../services/service_mng.dart';

class SearchModelview {
  SearchModelview();

  Future<dynamic> getTop5Search(String query) async {
    List<Playlist> playlists = [];
    List<Album> albums = [];
    List<Artist> artists = [];
    List<Song> songs = [];
    dynamic searchData;
    final data = await ServiceManager.searchService.getTop5Search(query);
    if (data['message'] == "OK") {
      print("data['data']:${data['data']}");
      var songsList = data['data']['songs'] as List;

      var albumsList = data['data']['albums'] as List;
      print("ok");
      var artistsList = data['data']['artists'] as List;
      var playlistsList = data['data']['playlists'] as List;
      songs = songsList.map((song) => Song.fromJson(song)).toList();
      artists = artistsList.map((artist) => Artist.fromJson(artist)).toList();
      albums = albumsList.map((album) => Album.fromJson(album)).toList();
      playlists = playlistsList.map((playlist) => Playlist.fromJson(playlist)).toList();
    } else {
      print(data['message']);
    }
    return {"songs": songs, "artists": artists, "albums": albums, "playlists": playlists};
  }
}
