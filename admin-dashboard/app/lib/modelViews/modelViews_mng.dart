import 'package:app/modelViews/album/album_modelView.dart';
import 'package:app/modelViews/playlist/playlist_modelView.dart';
import 'package:app/modelViews/song/song_modelView.dart';
import 'package:app/modelViews/topic/topic_modelView.dart';
import 'package:app/modelViews/user/user_modelView.dart';
import 'package:app/modelViews/user_type/user_type_modelView.dart';
import 'package:app/models/album.dart';
import 'package:app/services/album_service.dart';
import 'package:app/services/song_service.dart';
import 'package:app/services/topic_service.dart';

import 'artist/artist_modelView.dart';
import 'genre/genre_modelView.dart';

//frontUrl
//String ip = "http://192.168.88.105:8000";
//String ip = "http://192.168.0.107:8000";
String ip = "http://127.0.0.1:8000";
String frontUrl = "${ip}/api/v0/";

class ModelviewsManager {
  static String imgUrl = "${ip}/static/images/";

  static String mp3Url = "${ip}/static/mp3/";

  static final TopicModelviews _topicModelviews = TopicModelviews();

  static final SongModelviews _songModelviews = SongModelviews();

  static final ArtistModelview _artistModelview = ArtistModelview();

  static final GenreModelview _genreModelview = GenreModelview();

  static final AlbumModelview _albumModelview = AlbumModelview();

  static final UserModelview _userModelview = UserModelview();

  static final PlaylistModelview _playlistModelview = PlaylistModelview();

  static final UserTypeModelview _userTypeModelview = UserTypeModelview();

  static UserTypeModelview get userTypeModelview => _userTypeModelview;

  static PlaylistModelview get playlistModelview => _playlistModelview;

  static UserModelview get userModelview => _userModelview;

  static AlbumModelview get albumModelview => _albumModelview;

  static GenreModelview get genreModelview => _genreModelview;

  static ArtistModelview get artistModelview => _artistModelview;

  static SongModelviews get songModelviews => _songModelviews;

  static TopicModelviews get topicModelviews => _topicModelviews;
}
