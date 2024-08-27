import 'package:client/configs/ip_config.dart';
import 'package:client/models/album_model.dart';
import 'package:client/services/history_service.dart';
import 'package:client/services/playlist_service.dart';
import 'package:client/services/search_service.dart';
import 'package:client/services/song_service.dart';
import 'package:client/services/topic_service.dart';
import 'package:client/services/verify_service.dart';

import 'album_service.dart';
import 'artist_service.dart';
import 'genre_service.dart';
import 'user_service.dart';

class ServiceManager {
  static String imgUrl = "${IpConfig.ip}/static/images/";

  static String mp3Url = "${IpConfig.ip}/static/mp3/";

  static String lyricUrl = "${IpConfig.ip}/static/lyric/";

  static final UserService _userService = UserService(IpConfig.frontUrl);
  static final VerifyService _verifyService = VerifyService(IpConfig.frontUrl);
  static final TopicService _topicService = TopicService(IpConfig.frontUrl);
  static final GenreService _genreService = GenreService(IpConfig.frontUrl);
  static final ArtistService _artistService = ArtistService(IpConfig.frontUrl);
  static final SongService _songService = SongService(IpConfig.frontUrl);
  static final HistoryService _historyService = HistoryService(IpConfig.frontUrl);
  static final SearchService _searchService = SearchService(IpConfig.frontUrl);
  static final PlaylistService _playlistService = PlaylistService(IpConfig.frontUrl);
  static final AlbumService _albumService = AlbumService(IpConfig.frontUrl);

  static SongService get songService => _songService;

  static ArtistService get artistService => _artistService;

  static TopicService get topicService => _topicService;

  static UserService get userService => _userService;

  static VerifyService get verifyService => _verifyService;

  static GenreService get genreService => _genreService;

  static HistoryService get historyService => _historyService;

  static SearchService get searchService => _searchService;

  static PlaylistService get playlistService => _playlistService;

  static AlbumService get albumService => _albumService;
}
