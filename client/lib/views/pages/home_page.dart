import 'dart:convert';

import 'package:client/configs/date_format_config.dart';
import 'package:client/configs/device_size_config.dart';
import 'package:client/helpers/shared_preferences_helper.dart';
import 'package:client/models/history_model.dart';
import 'package:client/models/static_data_model.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/pages/profile_page.dart';
import 'package:client/views/pages/chart_page.dart';
import 'package:client/views/pages/top_genre_item_page.dart';
import 'package:client/views/pages/topic_genre_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../modelViews/modelViews_mng.dart';
import '../../models/genre_model.dart';
import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../../provider/GlobalPlaySongSate.dart';
import '../../services/service_mng.dart';
import '../components/components.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.isHomePage});

  int isHomePage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  bool isOverlayVisible = false;
  String img = '';
  Widget currentlyBody = Container();
  bool _isLoading = true;
  List<Song> songsTop12Recent = [];
  List<Song> songsTop5Genchart = [];
  List<Genre> genresTop3 = [];
  List<Topic> topicsTop3 = [];
  List<dynamic> genresAndTopics = [];
  List<History> historyByUserEmail = [];
  bool _isLongPressed = false;
  Set<int> _longPressedIndexes = {};
  bool isSwipingRight = false;
  String _typeForGenreTopic = '';
  String _startForGenreTopic = '';
  int _idForGenreTopic = 0;
  String _nameForGenreTopic = '';
  DateTime _dateTime = DateTime.now();

  List<List<Color>> colorsList = [
    [
      Colors.blue.shade200,
      Colors.blue.shade300,
      Colors.blue.shade400,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.blue.shade700,
      Colors.blue.shade800,
      Colors.blue.shade900,
    ],
    [
      Colors.purple.shade200,
      Colors.purple.shade300,
      Colors.purple.shade400,
      Colors.purple.shade500,
      Colors.purple.shade600,
      Colors.purple.shade700,
      Colors.purple.shade800,
      Colors.purple.shade900,
    ],
    [
      Colors.redAccent.shade100,
      Colors.redAccent.shade200,
      Colors.redAccent.shade400,
      Colors.redAccent.shade700,
    ],
    [
      Colors.green.shade200,
      Colors.green.shade300,
      Colors.green.shade400,
      Colors.green.shade500,
      Colors.green.shade600,
      Colors.green.shade700,
      Colors.green.shade800,
      Colors.green.shade900,
    ],
    [
      Colors.orange.shade200,
      Colors.orange.shade300,
      Colors.orange.shade400,
      Colors.orange.shade500,
      Colors.orange.shade600,
      Colors.orange.shade700,
      Colors.orange.shade800,
      Colors.orange.shade900,
    ],
    [
      Colors.teal.shade200,
      Colors.teal.shade300,
      Colors.teal.shade400,
      Colors.teal.shade500,
      Colors.teal.shade600,
      Colors.teal.shade700,
      Colors.teal.shade800,
      Colors.teal.shade900,
    ],
    [
      Colors.amber.shade200,
      Colors.amber.shade300,
      Colors.amber.shade400,
      Colors.amber.shade500,
      Colors.amber.shade600,
      Colors.amber.shade700,
      Colors.amber.shade800,
      Colors.amber.shade900,
    ],
    [
      Colors.deepPurple.shade200,
      Colors.deepPurple.shade300,
      Colors.deepPurple.shade400,
      Colors.deepPurple.shade500,
      Colors.deepPurple.shade600,
      Colors.deepPurple.shade700,
      Colors.deepPurple.shade800,
      Colors.deepPurple.shade900,
    ],
    [
      Colors.cyan.shade200,
      Colors.cyan.shade300,
      Colors.cyan.shade400,
      Colors.cyan.shade500,
      Colors.cyan.shade600,
      Colors.cyan.shade700,
      Colors.cyan.shade800,
      Colors.cyan.shade900,
    ],
    [
      Colors.indigo.shade200,
      Colors.indigo.shade300,
      Colors.indigo.shade400,
      Colors.indigo.shade500,
      Colors.indigo.shade600,
      Colors.indigo.shade700,
      Colors.indigo.shade800,
      Colors.indigo.shade900,
    ],
    [
      Colors.lime.shade200,
      Colors.lime.shade300,
      Colors.lime.shade400,
      Colors.lime.shade500,
      Colors.lime.shade600,
      Colors.lime.shade700,
      Colors.lime.shade800,
      Colors.lime.shade900,
    ],
    [
      Colors.deepOrange.shade200,
      Colors.deepOrange.shade300,
      Colors.deepOrange.shade400,
      Colors.deepOrange.shade500,
      Colors.deepOrange.shade600,
      Colors.deepOrange.shade700,
      Colors.deepOrange.shade800,
      Colors.deepOrange.shade900,
    ],
    [
      Colors.brown.shade200,
      Colors.brown.shade300,
      Colors.brown.shade400,
      Colors.brown.shade500,
      Colors.brown.shade600,
      Colors.brown.shade700,
      Colors.brown.shade800,
      Colors.brown.shade900,
    ],
    [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ],
    [
      Colors.blueGrey.shade200,
      Colors.blueGrey.shade300,
      Colors.blueGrey.shade400,
      Colors.blueGrey.shade500,
      Colors.blueGrey.shade600,
      Colors.blueGrey.shade700,
      Colors.blueGrey.shade800,
      Colors.blueGrey.shade900,
    ],
    [
      Colors.pink.shade200,
      Colors.pink.shade300,
      Colors.pink.shade400,
      Colors.pink.shade500,
      Colors.pink.shade600,
      Colors.pink.shade700,
      Colors.pink.shade800,
      Colors.pink.shade900,
    ],
    [
      Colors.lightBlue.shade200,
      Colors.lightBlue.shade300,
      Colors.lightBlue.shade400,
      Colors.lightBlue.shade500,
      Colors.lightBlue.shade600,
      Colors.lightBlue.shade700,
      Colors.lightBlue.shade800,
      Colors.lightBlue.shade900,
    ],
    [
      Colors.lightGreen.shade200,
      Colors.lightGreen.shade300,
      Colors.lightGreen.shade400,
      Colors.lightGreen.shade500,
      Colors.lightGreen.shade600,
      Colors.lightGreen.shade700,
      Colors.lightGreen.shade800,
      Colors.lightGreen.shade900,
    ],
    [
      Colors.deepPurpleAccent.shade100,
      Colors.deepPurpleAccent.shade200,
      Colors.deepPurpleAccent.shade400,
      Colors.deepPurpleAccent.shade700,
    ],
    [
      Colors.amberAccent.shade100,
      Colors.amberAccent.shade200,
      Colors.amberAccent.shade400,
      Colors.amberAccent.shade700,
    ],
    [
      Colors.blueAccent.shade100,
      Colors.blueAccent.shade200,
      Colors.blueAccent.shade400,
      Colors.blueAccent.shade700,
    ],
    [
      Colors.cyanAccent.shade100,
      Colors.cyanAccent.shade200,
      Colors.cyanAccent.shade400,
      Colors.cyanAccent.shade700,
    ],
    [
      Colors.deepOrangeAccent.shade100,
      Colors.deepOrangeAccent.shade200,
      Colors.deepOrangeAccent.shade400,
      Colors.deepOrangeAccent.shade700,
    ],
    [
      Colors.deepPurpleAccent.shade100,
      Colors.deepPurpleAccent.shade200,
      Colors.deepPurpleAccent.shade400,
      Colors.deepPurpleAccent.shade700,
    ],
    [
      Colors.greenAccent.shade100,
      Colors.greenAccent.shade200,
      Colors.greenAccent.shade400,
      Colors.greenAccent.shade700,
    ],
    [
      Colors.indigoAccent.shade100,
      Colors.indigoAccent.shade200,
      Colors.indigoAccent.shade400,
      Colors.indigoAccent.shade700,
    ],
    [
      Colors.lightBlueAccent.shade100,
      Colors.lightBlueAccent.shade200,
      Colors.lightBlueAccent.shade400,
      Colors.lightBlueAccent.shade700,
    ],
    [
      Colors.orangeAccent.shade100,
      Colors.orangeAccent.shade200,
      Colors.orangeAccent.shade400,
      Colors.orangeAccent.shade700,
    ],
    [
      Colors.pinkAccent.shade100,
      Colors.pinkAccent.shade200,
      Colors.pinkAccent.shade400,
      Colors.pinkAccent.shade700,
    ],
    [
      Colors.purpleAccent.shade100,
      Colors.purpleAccent.shade200,
      Colors.purpleAccent.shade400,
      Colors.purpleAccent.shade700,
    ],
  ];
  List<String> assetsIc = [
    'assets/images/ic-music.png',
    'assets/images/ic-star.png',
    'assets/images/ic-audio-wave.png',
    'assets/images/ic-music-record.png',
    'assets/images/ic-headphones.png',
    'assets/images/ic-sample-rate.png',
  ];

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> loadBase64StringPicture() async {
    // Xóa cache của hình ảnh cũ
    imageCache.clear();
    String base64 = "";
    String url = '${ServiceManager.imgUrl}user/${StaticData.currentlyUser?.picture}.png';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // base64 = "data:image/jpeg;base64,${base64Encode(response.bodyBytes)}";
      base64 = base64Encode(response.bodyBytes);
      print('--------------------------------Vừa get hình mới---------------------------------');
    } else {
      throw Exception('Failed to load image');
    }
    return base64;
  }

  String formatReleaseDate(DateTime releaseDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(releaseDate);
  }

  String calculateDaysSinceRelease(DateTime releaseDate) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(releaseDate);
    return '${difference.inDays} days ago';
  }

  Future<void> loadData() async {
    try {
      img = await loadBase64StringPicture();
      _dateTime = DateTime.now();
      genresAndTopics = [];
      List<Song> getTop12RecentSongs = await ModelviewsManager.songModelviews.getTop12RecentSongs();
      List<Song> getTop5SongsListenCountMax = await ModelviewsManager.songModelviews.getTop5SongsListenCountMax();
      List<Genre> getTop3Genres = await ModelviewsManager.genreModelview.getTop3Genres();
      List<Topic> getTop3Topics = await ModelviewsManager.topicModelviews.getTop3Topics();
      List<History> getHistorysByUserEmail =
          await ModelviewsManager.historyModelview.getHistorysByUserEmail(email: StaticData.currentlyUser!.email);
      setState(() {
        songsTop12Recent = getTop12RecentSongs;
        songsTop5Genchart = getTop5SongsListenCountMax;
        genresTop3 = getTop3Genres;
        topicsTop3 = getTop3Topics;
        genresAndTopics.addAll(genresTop3);
        genresAndTopics.addAll(topicsTop3);
        // print('getTop3Genres: ${getTop3Genres}');
        // print('getTop3Topics: ${getTop3Topics}');
        // print('genresAndTopics: ${genresAndTopics}');
        historyByUserEmail = getHistorysByUserEmail;
        // print('historyByUserEmail: ${historyByUserEmail}');
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    // Hàm này sẽ thực hiện việc load lại dữ liệu
    await loadData();
    print("--------------------------------Data refreshed-----------------------------------");
    // Sau khi dữ liệu được làm mới, cuộn ListView về đầu
    // Future.delayed(Duration(milliseconds: 100), () {
    //   _scrollController.animateTo(
    //     0,
    //     duration: Duration(milliseconds: 100),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }

  void handleProfile(BuildContext context) {
    print('-------------------------------------handleProfile----------------------------------');
    if (isOverlayVisible) {
      _removeOverlay();
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _removeOverlay();
                _loadImageAndBuilHomePage();
              },
              // onHorizontalDragUpdate: (details) {
              //   if (details.delta.dx < 0 &&
              //       !isSwipingRight &&
              //       details.globalPosition.dx > MediaQuery.of(context).size.width / 2) {
              //     // Vuốt từ phải sang trái
              //     _removeOverlay();
              //     _loadImageAndBuilHomePage();
              //     isSwipingRight = true; // Đánh dấu đã xử lý vuốt từ phải sang trái
              //   }
              // },
              // onHorizontalDragEnd: (details) {
              //   isSwipingRight = false; // Đặt lại biến đánh dấu khi kết thúc vuốt ngang
              // },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              left: 0,
              right: MediaQuery.of(context).size.width * 0.2,
              top: 0,
              bottom: 0,
              child: ProfilePage(
                onBack: () {
                  _removeOverlay();
                },
                onLogout: () {
                  _removeOverlay();
                },
                onNavigateToForgotPassword: () {
                  _removeOverlay();
                },
              ),
            ),
            Positioned(
              right: 65.6.w,
              top: 40.h,
              child: GestureDetector(
                onTap: () {
                  _removeOverlay();
                  _loadImageAndBuilHomePage();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Color.fromARGB(255, 41, 41, 42),
                  ),
                  width: 40.w,
                  height: 40.h,
                  child: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: 25.sp,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      isOverlayVisible = true;
    });
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        isOverlayVisible = false;
      });
    }
  }

  void _loadImageAndBuilHomePage() {
    loadBase64StringPicture().then((image) {
      setState(() {
        img = image;
        currentlyBody = buildHomePage(context);
      });
    });
  }

  void handleChart() {
    print('-------------------------------------handleChart----------------------------------');
    setState(() {
      widget.isHomePage = 2;
    });
  }

  void handleBell() {
    print('-------------------------------------handleBell----------------------------------');
  }

  void handleSetting() {
    print('-------------------------------------handleSetting----------------------------------');
  }

  void handleGetAllDanhSachNoiBat() {
    print('-------------------------------------handleGetAllDanhSachNoiBat----------------------------------');
  }

  void handleGetAllChuDe_TheLoai() {
    print('-------------------------------------handleGetAllChuDe_TheLoai----------------------------------');
    setState(() {
      widget.isHomePage = 3;
    });
  }

  void handleItemGenreTopic({required id}) {
    print('-------------------------------------handleItemGenreTopic----------------------------------');
    if (id <= 3) {
      // genre
      print('-------------------------------------handleItemGenre với id: $id----------------------------------');
      setState(() {
        _idForGenreTopic = id;
        _nameForGenreTopic = genresAndTopics[id - 1].name;
        _typeForGenreTopic = 'genre';
        _startForGenreTopic = 'HomePage';
        widget.isHomePage = 4;
      });
    } else {
      // topic
      int topicId = id - 3;
      print('-------------------------------------handleItemTopic với id: $topicId----------------------------------');
      setState(() {
        _idForGenreTopic = topicId;
        _nameForGenreTopic = genresAndTopics[id - 1].name;
        _typeForGenreTopic = 'topic';
        _startForGenreTopic = 'HomePage';
        widget.isHomePage = 4;
      });
    }
  }

  void handleGoToTopicGenreItemFromTopicGenrePage({
    required int id,
    required String name,
    required String type,
    required String start,
  }) {
    print('-------------------------------------handleItem${name} với id: $id----------------------------------');
    setState(() {
      _idForGenreTopic = id;
      _nameForGenreTopic = name;
      _typeForGenreTopic = type;
      _startForGenreTopic = start;
      widget.isHomePage = 4;
    });
  }

  void backHomePage() {
    setState(() {
      widget.isHomePage = 1;
    });
  }

  void backTopicGenrePage() {
    setState(() {
      widget.isHomePage = 3;
    });
  }

  List<Song> getQueueOfSong(Song song) {
    List<Song> songs = [song, song, song, song, song];
    return songs;
  }

  Future<void> handleOnTapItemSong({required Song song}) async {
    List<Song> queue = await getQueueOfSong(song);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var musicPlayState = Provider.of<MusicPlayState>(context, listen: false);
      musicPlayState.stop();
      musicPlayState.setCurrentSongsList(queue);
      musicPlayState.setCurrentSong(queue[0]);
      musicPlayState.play();
      musicPlayState.toggleRotation();
    });
  }

  Widget renderTitle({
    required double marginTop,
    required double marginBottom,
    required String title,
    required Function? function, // được phép null
  }) {
    return Container(
      // color: Colors.greenAccent,
      // width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        30.w,
        marginTop.h,
        0.w,
        marginBottom.h,
      ),
      child: GestureDetector(
        onTap: () {
          if (function != null) {
            function();
          }
        },
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'CenturyGothicRegular',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  Widget renderItemSongForRecent({
    required int index,
    required int id,
    required String picture,
    required String songName,
    required String artistName,
    required DateTime releaseDate,
  }) {
    // Construct the image URL
    String imageUrl = '${ServiceManager.imgUrl}song/${id}_$picture.png';
    // xử lý ngày
    String formattedReleaseDate = calculateDaysSinceRelease(releaseDate);
    //
    Song song = Song(
      id: id,
      name: songName,
      duration: Duration(),
      picture: picture,
      listenCount: 0,
      lyric: '',
      album_id: 1,
      artists: [],
      genres: [],
      topics: [],
    );
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.transparent,
      ),
      child: EffectTap(
        color: Colors.transparent,
        toColor: Colors.white,
        miliDuration: 300,
        radius: 10.r,
        onTap: () {
          handleOnTapItemSong(song: song);
        },
        child: Container(
          height: 65.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 65.w,
                height: 65.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                width: index != 3 ? 220.w : 250.w,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      songName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.70),
                      ),
                    ),
                    Text(
                      formattedReleaseDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  handleOnTapDetailSong(song, context);
                },
                child: Container(
                  height: double.infinity,
                  width: 20.w,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/ic-more.png',
                    color: Color.fromRGBO(255, 255, 255, 0.90),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderItemSongForGenchart({
    required int rank,
    required int id,
    required String picture,
    required String songName,
    required String artistName,
  }) {
    rank += 1; // 0 -> 1 -------- 4 -> 5
    // Construct the image URL
    String imageUrl = '${ServiceManager.imgUrl}song/${id}_$picture.png';
    //
    Song song = Song(
      id: id,
      name: songName,
      duration: Duration(),
      picture: picture,
      listenCount: 0,
      lyric: '',
      album_id: 1,
      artists: [],
      genres: [],
      topics: [],
    );
    return Container(
      height: 45.h,
      margin: EdgeInsets.fromLTRB(
        15.w,
        0.h,
        15.w,
        15.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.transparent,
      ),
      child: EffectTap(
        color: Colors.transparent,
        toColor: Colors.white,
        miliDuration: 300,
        radius: 10.r,
        onTap: () {
          handleOnTapItemSong(song: song);
        },
        child: Container(
          height: 45.h,
          margin: EdgeInsets.fromLTRB(
            0.w,
            0.h,
            0.w,
            0.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      rank.toString(),
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      '•',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                width: 230.w,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      songName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  handleOnTapDetailSong(song, context);
                },
                child: Container(
                  height: double.infinity,
                  width: 20.w,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/ic-more.png',
                    color: Color.fromRGBO(255, 255, 255, 0.90),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    loadBase64StringPicture().then((image) {
      setState(() {
        img = image;
        currentlyBody = buildHomePage(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHomePage == 1) {
      currentlyBody = buildHomePage(context);
    } else if (widget.isHomePage == 2) {
      currentlyBody = ChartPage(onBack: () {
        backHomePage();
      });
    } else if (widget.isHomePage == 3) {
      currentlyBody = TopicGenrePage(
        onBack: () {
          backHomePage();
        },
        onTapItem: (int id, String name, String type, String start) {
          handleGoToTopicGenreItemFromTopicGenrePage(id: id, name: name, type: type, start: start);
        },
      );
    } else if (widget.isHomePage == 4) {
      currentlyBody = TopGenreItemPage(
        onBack: () {
          if (_startForGenreTopic == 'HomePage') {
            backHomePage();
          } else if (_startForGenreTopic == 'TopicGenrePage') {
            backTopicGenrePage();
          }
        },
        id: _idForGenreTopic,
        name: _nameForGenreTopic,
        type: _typeForGenreTopic,
        start: _startForGenreTopic,
      );
    } else if (widget.isHomePage == 5) {
      currentlyBody = ChartPage(onBack: () {
        backHomePage();
      });
    }
    return currentlyBody;
  }

  Widget buildHomePage(BuildContext context) {
    print('--------------------------------Build HomePage-----------------------------------');
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 13, 72, 79),
              // Color.fromARGB(255, 16, 43, 45),
            ),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  // height: 34.h ,
                  margin: EdgeInsets.fromLTRB(
                    29.w,
                    55.h,
                    29.w,
                    34.h,
                  ),
                  // color: Colors.red,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          handleProfile(context);
                        },
                        child: Container(
                          width: 37.w,
                          height: 37.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                          ),
                          child: ClipOval(
                            child: img.isEmpty
                                ? CircularProgressIndicator(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  )
                                : Image.memory(
                                    base64Decode(img),
                                    fit: BoxFit.cover, // Đảm bảo hình ảnh được bao phủ toàn bộ hình tròn
                                  ),
                            // Image.network(
                            //   img,
                            //   // width: 37.w,
                            //   // height: 37.w,
                            //   color: StaticData.currentlyUser?.picture == 'av-none' ? Colors.white : null,
                            //   fit: BoxFit.cover, // Đảm bảo hình ảnh được bao phủ toàn bộ hình tròn
                            // ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _scrollToTop();
                        },
                        child: Container(
                          // width: 190.w,
                          width: 180.w,
                          height: 40.h,
                          // height: 34.h ,
                          margin: EdgeInsets.only(
                            left: 17.w,
                          ),
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Welcome back !',
                                style: TextStyle(
                                  fontFamily: 'CenturyGothicRegular',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text(
                                StaticData.currentlyUser!.name.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'CenturyGothicRegular',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 0.58),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      EffectTap(
                        onTap: () {
                          handleChart();
                        },
                        color: Colors.transparent,
                        toColor: Colors.grey,
                        radius: 25.r,
                        miliDuration: 500,
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          // color: Colors.blue,
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic-chart.png',
                              width: 20.w,
                              height: 20.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      EffectTap(
                        onTap: () {
                          handleBell();
                        },
                        color: Colors.transparent,
                        toColor: Colors.grey,
                        radius: 25.r,
                        miliDuration: 500,
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          // color: Colors.blue,
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic-bell.png',
                              width: 20.w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      EffectTap(
                        onTap: () {
                          handleSetting();
                        },
                        color: Colors.transparent,
                        toColor: Colors.grey,
                        radius: 25.r,
                        miliDuration: 500,
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          // color: Colors.blue,
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic-setting.png',
                              width: 20.w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: Color.fromARGB(255, 13, 72, 79),
                    // Màu của vòng tròn tải
                    backgroundColor: Colors.transparent,
                    // Màu nền phía sau vòng tròn tải
                    strokeWidth: 3.0,
                    // Độ dày của vòng tròn tải
                    onRefresh: _refreshData,
                    child: ListView(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                      children: [
                        renderTitle(
                          marginTop: 0,
                          marginBottom: 12,
                          title: 'Danh sách nổi bật   ❯',
                          function: handleGetAllDanhSachNoiBat,
                        ),
                        Container(
                          height: 150.h,
                          child: ListView(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal, // Đặt hướng cuộn là ngang
                            children: [
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.fromLTRB(
                                  29.w,
                                  0.h,
                                  15.w,
                                  0.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage('${ServiceManager.imgUrl}album/1_1_photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage('${ServiceManager.imgUrl}album/2_2_photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage('${ServiceManager.imgUrl}album/3_177_photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${ServiceManager.imgUrl}album/4_23_Anh-Dau-Muon-Thay-Em-Buon-Chau-Khai-Phong-ACV.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage('${ServiceManager.imgUrl}album/1_1_photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(
                                  right: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: NetworkImage('${ServiceManager.imgUrl}album/3_177_photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: handleGetAllDanhSachNoiBat,
                                child: Container(
                                  width: 150.w,
                                  height: 150.h,
                                  margin: EdgeInsets.only(
                                    right: 15.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic-circled-down-left-arrow.png',
                                        color: Color.fromRGBO(255, 255, 255, 0.90),
                                        width: 75.w,
                                        height: 75.h,
                                      ),
                                      Text(
                                        'Xem tất cả',
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicRegular',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(255, 255, 255, 0.90),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Thêm các widget khác nếu cần
                            ],
                          ),
                        ),
                        renderTitle(
                          marginTop: 35,
                          marginBottom: 12,
                          title: 'Mới phát hành',
                          function: null,
                        ),
                        Container(
                          height: 220.h,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            // Số lượng các page
                            controller: PageController(
                              viewportFraction:
                                  0.86, // Chỉ định phần trăm màn hình mà mỗi page sẽ chiếm (86% trong trường hợp này)
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(
                                  0.w,
                                  0.h,
                                  index != 3 ? 30.w : 0.w,
                                  0.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    renderItemSongForRecent(
                                      index: index,
                                      id: songsTop12Recent[index * 3].id,
                                      picture: songsTop12Recent[index * 3].picture,
                                      songName: songsTop12Recent[index * 3].name,
                                      artistName:
                                          songsTop12Recent[index * 3].artists.map((artist) => artist.name).join(', '),
                                      releaseDate: songsTop12Recent[index * 3].releaseDate!,
                                    ),
                                    renderItemSongForRecent(
                                      index: index,
                                      id: songsTop12Recent[index * 3 + 1].id,
                                      picture: songsTop12Recent[index * 3 + 1].picture,
                                      songName: songsTop12Recent[index * 3 + 1].name,
                                      artistName: songsTop12Recent[index * 3 + 1]
                                          .artists
                                          .map((artist) => artist.name)
                                          .join(', '),
                                      releaseDate: songsTop12Recent[index * 3 + 1].releaseDate!,
                                    ),
                                    renderItemSongForRecent(
                                      index: index,
                                      id: songsTop12Recent[index * 3 + 2].id,
                                      picture: songsTop12Recent[index * 3 + 2].picture,
                                      songName: songsTop12Recent[index * 3 + 2].name,
                                      artistName: songsTop12Recent[index * 3 + 2]
                                          .artists
                                          .map((artist) => artist.name)
                                          .join(', '),
                                      releaseDate: songsTop12Recent[index * 3 + 2].releaseDate!,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        renderTitle(
                          marginTop: 35,
                          marginBottom: 12,
                          title: 'Chủ đề & thể loại   ❯',
                          function: handleGetAllChuDe_TheLoai,
                        ),
                        Container(
                          height: 80.h,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal, // Đặt hướng cuộn là ngang
                            itemCount: genresAndTopics.length + 1, // Thêm 1 để hiển thị Xem tất cả
                            itemBuilder: (context, index) {
                              if (index != 6) {
                                return GestureDetector(
                                  onLongPressStart: (_) {
                                    setState(() {
                                      _longPressedIndexes.add(index); // Thêm chỉ mục vào Set
                                    });
                                  },
                                  onLongPressEnd: (_) {
                                    setState(() {
                                      _longPressedIndexes.remove(index); // Xóa chỉ mục khỏi Set
                                    });
                                  },
                                  onTap: () {
                                    handleItemGenreTopic(id: index + 1);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 150),
                                    curve: Curves.easeInOut,
                                    margin: index == 0
                                        ? _longPressedIndexes.contains(index)
                                            ? EdgeInsets.fromLTRB(
                                                34.w,
                                                3.h,
                                                20.w,
                                                3.h,
                                              )
                                            : EdgeInsets.fromLTRB(
                                                29.w,
                                                0.h,
                                                15.w,
                                                0.h,
                                              )
                                        : _longPressedIndexes.contains(index)
                                            ? EdgeInsets.fromLTRB(
                                                5.w,
                                                3.h,
                                                20.w,
                                                3.h,
                                              )
                                            : EdgeInsets.only(
                                                right: 15.w,
                                              ),
                                    padding: EdgeInsets.fromLTRB(
                                      10.w,
                                      12.h,
                                      10.w,
                                      5.h,
                                    ),
                                    width: _longPressedIndexes.contains(index) ? 160.w : 170.w,
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: colorsList[index],
                                      ),
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 20.h,
                                            height: 20.h,
                                            child: Image.asset(
                                              assetsIc[index],
                                              color: Colors.white,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            genresAndTopics[index].name.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'CenturyGothicBold',
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: handleGetAllChuDe_TheLoai,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: 15.w,
                                    ),
                                    width: 80.w,
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          'assets/images/ic-circled-down-left-arrow.png',
                                          color: Color.fromRGBO(255, 255, 255, 0.90),
                                          width: 40.w,
                                          height: 40.h,
                                        ),
                                        Text(
                                          'Xem tất cả',
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothicRegular',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(255, 255, 255, 0.90),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: historyByUserEmail.isNotEmpty,
                          child: renderTitle(
                            marginTop: 35,
                            marginBottom: 12,
                            title: 'Gợi ý dành riêng cho bạn',
                            function: null,
                          ),
                        ),
                        Visibility(
                          visible: historyByUserEmail.isNotEmpty,
                          child: Container(
                            height: 220.h,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              // Số lượng các page
                              controller: PageController(
                                viewportFraction:
                                    0.86, // Chỉ định phần trăm màn hình mà mỗi page sẽ chiếm (86% trong trường hợp này)
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(
                                    0.w,
                                    0.h,
                                    index != 3 ? 30.w : 0.w,
                                    0.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      renderItemSongForRecent(
                                        index: index,
                                        id: songsTop12Recent[index * 3].id,
                                        picture: songsTop12Recent[index * 3].picture,
                                        songName: songsTop12Recent[index * 3].name,
                                        artistName:
                                            songsTop12Recent[index * 3].artists.map((artist) => artist.name).join(', '),
                                        releaseDate: songsTop12Recent[index * 3].releaseDate!,
                                      ),
                                      renderItemSongForRecent(
                                        index: index,
                                        id: songsTop12Recent[index * 3 + 1].id,
                                        picture: songsTop12Recent[index * 3 + 1].picture,
                                        songName: songsTop12Recent[index * 3 + 1].name,
                                        artistName: songsTop12Recent[index * 3 + 1]
                                            .artists
                                            .map((artist) => artist.name)
                                            .join(', '),
                                        releaseDate: songsTop12Recent[index * 3 + 1].releaseDate!,
                                      ),
                                      renderItemSongForRecent(
                                        index: index,
                                        id: songsTop12Recent[index * 3 + 2].id,
                                        picture: songsTop12Recent[index * 3 + 2].picture,
                                        songName: songsTop12Recent[index * 3 + 2].name,
                                        artistName: songsTop12Recent[index * 3 + 2]
                                            .artists
                                            .map((artist) => artist.name)
                                            .join(', '),
                                        releaseDate: songsTop12Recent[index * 3 + 2].releaseDate!,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            29.w,
                            35.h,
                            29.w,
                            0.h,
                          ),
                          height: 445.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 6, 160, 181),
                                Color.fromARGB(255, 10, 104, 115),
                                Color.fromARGB(255, 13, 72, 79),
                                Color.fromARGB(255, 16, 43, 45),
                                Color.fromRGBO(15, 32, 33, 0.61),
                                Colors.black12,
                                Colors.black26,
                                Colors.black38,
                                Colors.black45,
                                Colors.black54,
                                Colors.black87,
                                Colors.black,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                  15.w,
                                  15.h,
                                  0.w,
                                  15.h,
                                ),
                                // color: Colors.red,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 55.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Cập nhật ',
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicRegular',
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(255, 255, 255, 0.70),
                                                ),
                                              ),
                                              Text(
                                                '${DateFormat('dd.MM.yyyy - HH:mm:ss').format(_dateTime)}',
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicBold',
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '#Genchart',
                                            style: TextStyle(
                                              fontFamily: 'CenturyGothicRegular',
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(255, 255, 255, 0.70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50.h,
                                      child: Image.asset('assets/images/bg-gen-chart.png'),
                                    ),
                                  ],
                                ),
                              ),
                              for (int index = 0; index < songsTop5Genchart.length; index++)
                                renderItemSongForGenchart(
                                    rank: index,
                                    id: songsTop5Genchart[index].id,
                                    picture: songsTop5Genchart[index].picture,
                                    songName: songsTop5Genchart[index].name,
                                    artistName:
                                        songsTop5Genchart[index].artists.map((artist) => artist.name).join(', ')),
                              Container(
                                height: 0.5.h,
                                margin: EdgeInsets.fromLTRB(
                                  15.w,
                                  10.h,
                                  15.w,
                                  0.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Color.fromRGBO(255, 255, 255, 0.70),
                                ),
                              ),
                              GestureDetector(
                                onTap: handleChart,
                                child: Container(
                                  height: 45.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)),
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    'Xem tất cả',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 255, 255, 0.90),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
