import 'package:client/modelViews/history_modelView.dart';
import 'package:client/modelViews/playlist_modelView.dart';
import 'package:client/modelViews/search_modelView.dart';
import 'package:client/modelViews/song_modelView.dart';
import 'package:client/modelViews/topic_modelView.dart';
import 'package:client/modelViews/user_modelView.dart';
import 'package:client/modelViews/verify_modelView.dart';

import 'album_modelView.dart';
import 'artist_modelView.dart';
import 'genre_modelView.dart';

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
  static final VerifyModelview _verifyModelview = VerifyModelview();
  static final HistoryModelview _historyModelview = HistoryModelview();
  static final SearchModelview _searchModelview = SearchModelview();

  static final PlaylistModelview _playlistModelview = PlaylistModelview();

  static PlaylistModelview get playlistModelview => _playlistModelview;

  static UserModelview get userModelview => _userModelview;

  static VerifyModelview get verifyModelview => _verifyModelview;

  static HistoryModelview get historyModelview => _historyModelview;

  static SearchModelview get searchModelview => _searchModelview;

  static AlbumModelview get albumModelview => _albumModelview;

  static GenreModelview get genreModelview => _genreModelview;

  static ArtistModelview get artistModelview => _artistModelview;

  static SongModelviews get songModelviews => _songModelviews;

  static TopicModelviews get topicModelviews => _topicModelviews;
}
