import 'package:app/models/album.dart';
import 'package:app/services/album_service.dart';
import 'package:app/services/playlist_service.dart';
import 'package:app/services/song_service.dart';
import 'package:app/services/topic_service.dart';
import 'package:app/services/user_type_service.dart';

import 'artist_service.dart';
import 'genre_service.dart';
import 'user_service.dart';

//frontUrl
//String ip = "http://192.168.88.105:8000";
//String ip = "http://192.168.0.107:8000";
String ip = "http://192.168.0.106:8000";
//String ip = "http://127.0.0.1:8000";
//String ip = "http://192.168.200.41:8000";
String frontUrl = "${ip}/api/v0/";

//
class ServiceManager {
  static String imgUrl = "${ip}/static/images/";

  static String mp3Url = "${ip}/static/mp3/";

  static String lyricUrl = "${ip}/static/lyrics/";

  static final UserService _userService = UserService(frontUrl);

  static final TopicService _topicService = TopicService(frontUrl);

  static final GenreService _genreService = GenreService(frontUrl);

  static final ArtistService _artistService = ArtistService(frontUrl);

  static final SongService _songService = SongService(frontUrl);

  static final AlbumService _albumService = AlbumService(frontUrl);

  static final PlaylistService _playlistService = PlaylistService(frontUrl);

  static final UserTypeService _userTypeService = UserTypeService(frontUrl);

  static UserTypeService get userTypeService => _userTypeService;

  static PlaylistService get playlistService => _playlistService;

  static AlbumService get albumService => _albumService;

  static SongService get songService => _songService;

  static ArtistService get artistService => _artistService;

  static TopicService get topicService => _topicService;

  static UserService get userService => _userService;

  static GenreService get genreService => _genreService;
}
