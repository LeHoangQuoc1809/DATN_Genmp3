import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/views/pages/Song/song_snack_bar_content.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:ui';
import 'package:client/models/artist_model.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/components/padding_animation_widget.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/album_model.dart';
import '../../../models/song_model.dart';
import '../../../provider/GlobalPlaySongSate.dart';
import '../../components/components.dart';

class ArtistInforPage extends StatefulWidget {
  BuildContext context;
  Artist artist;
  Function popCallBack;

  ArtistInforPage({
    super.key,
    required this.context,
    required this.artist,
    required this.popCallBack,
  });

  @override
  State<ArtistInforPage> createState() => _ArtistInforPageState();
}

class _ArtistInforPageState extends State<ArtistInforPage> {
  List<Artist> artistStack = [];

  List<Album> albums = [];

  List<Song> songs = [];

  List<Artist> similarArtists = [];

  bool isFollowed = false;

  late Artist artist;

  String numberOfFollowerString = "999BBB";

  Future<void> loadArtistInfoData() async {
    try {
      //get top song of artist
      final topSongsResponse = http.get(Uri.parse('https://api.example.com/data1'));
      //get all albums of artist
      final albumsResponse = http.get(Uri.parse('https://api.example.com/data2'));
      //get info of artist
      final numberOfFollowerResponse = http.get(Uri.parse('https://api.example.com/data3'));

      final similarArtistsResponse = ModelviewsManager.artistModelview.getTop5SimilarArtist(artist.id);

      final results = await Future.wait([
        topSongsResponse,
        albumsResponse,
        numberOfFollowerResponse,
        similarArtistsResponse,
      ]);

      List<Song> topSongsData = results[0] as List<Song>;
      List<Album> albumsData = results[1] as List<Album>;
      String numberOfFollowerData = results[2] as String;
      List<Artist> similarArtistsData = results[3] as List<Artist>;

      setState(() {
        songs = topSongsData;
        albums = albumsData;
        numberOfFollowerString = numberOfFollowerData;
        similarArtists = similarArtistsData;
      });
    } catch (e) {
      final similarArtistsResponse = await ModelviewsManager.artistModelview.getTop5SimilarArtist(artist.id);

      List<Artist> similarArtistsData = similarArtistsResponse;
      setState(() {
        isFollowed = true;
        songs = [
          Song(
              id: 1,
              name: "Chua Chau Khai Phong Truc AnhBabe",
              duration: const Duration(seconds: 30, minutes: 3),
              picture: "Chua-Chau-Khai-Phong-Truc-Anh-Babe",
              listenCount: 100000,
              lyric: "lyric",
              topics: [],
              genres: [],
              album_id: 1,
              artists: [Artist(id: 1, name: "Artist 1", description: "artist_description", picture: "artist_picture")]),
          Song(
              id: 2,
              name: "Neu-Em-Muon-Chia-Tay-Instrument-Edm-Chau-Khai-Phong",
              duration: const Duration(seconds: 30, minutes: 3),
              picture: "Neu-Em-Muon-Chia-Tay-Instrument-Edm-Chau-Khai-Phong",
              listenCount: 9999,
              lyric: "lyric",
              topics: [],
              genres: [],
              album_id: 1,
              artists: [Artist(id: 1, name: "Artist 1", description: "artist_description", picture: "artist_picture")]),
          Song(
              id: 13,
              name: "Buc-Tranh-Lem-Mau-Khang-Viet-Chau-Khai-Phong",
              duration: const Duration(seconds: 30, minutes: 3),
              picture: "Buc-Tranh-Lem-Mau-Khang-Viet-Chau-Khai-Phong",
              listenCount: 9000000,
              lyric: "lyric",
              topics: [],
              genres: [],
              album_id: 1,
              artists: [
                Artist(id: 1, name: "Artist 1", description: "artist_description", picture: "artist_picture"),
                Artist(id: 2, name: "Artist 2", description: "artist_description", picture: "artist_picture"),
                Artist(id: 3, name: "Artist 3", description: "artist_description", picture: "artist_picture"),
              ]),
          Song(
              id: 14,
              name: "Khi-Em-Ra-Di-Chau-Khai-Phong-Anh-Thi",
              duration: const Duration(seconds: 30, minutes: 3),
              picture: "Khi-Em-Ra-Di-Chau-Khai-Phong-Anh-Thi",
              listenCount: 9999,
              lyric: "lyric",
              topics: [],
              genres: [],
              album_id: 1,
              artists: [
                Artist(id: 1, name: "Artist 1", description: "artist_description", picture: "artist_picture"),
              ]),
          Song(
            id: 15,
            name: "Nghe-Noi-Anh-Yeu-Em-Chau-Khai-Phong-Ngan-Ngan",
            duration: const Duration(seconds: 30, minutes: 3),
            picture: "Nghe-Noi-Anh-Yeu-Em-Chau-Khai-Phong-Ngan-Ngan",
            listenCount: 9999,
            lyric: "lyric",
            topics: [],
            genres: [],
            album_id: 1,
            artists: [Artist(id: 1, name: "Artist 1", description: "artist_description", picture: "artist_picture")],
          ),
        ];
        albums = [
          Album(
              id: 1,
              name: "Long Album Name Long Album Name Long Album Name",
              releaseDate: "20/11/2002",
              picture: "photo",
              artistId: 1,
              description: "album_description"),
          Album(
              id: 2,
              name: "Album 2",
              releaseDate: "20/11/2002",
              picture: "photo",
              artistId: 1,
              description: "album_description"),
          Album(
              id: 3,
              name: "Album 1",
              releaseDate: "20/11/2002",
              picture: "photo",
              artistId: 1,
              description: "album_description"),
          Album(
              id: 4,
              name: "Album 2",
              releaseDate: "20/11/2002",
              picture: "photo",
              artistId: 1,
              description: "album_description"),
        ];
        similarArtists = similarArtistsData;
        [
          Artist(id: 1, name: "Châu Khải Phong", description: "description", picture: "Chau-Khai-Phong"),
          Artist(id: 2, name: "Trúc Anh Babe", description: "description", picture: "Truc-Anh-Babe"),
          Artist(id: 3, name: "Đỗ Minh Quân", description: "description", picture: "Do-Minh-Quan"),
          Artist(id: 4, name: "Bằng Kiều", description: "description", picture: "Bang-Kieu"),
          Artist(id: 5, name: "Tuấn Hưng", description: "description", picture: "Tuan-Hung"),
        ];
      });
    }
  }

  void handleOnTapFeaturedSong() async {
    print("handleOnTapFeaturedSong");
  }

  void handleOnTapFollow() async {
    print("handleOnTapFollow");
    setState(() {
      isFollowed = !isFollowed;
    });
  }

  void handleOnTapPlay() async {
    print("handleOnTapPlay");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var musicPlayState = Provider.of<MusicPlayState>(context, listen: false);
      musicPlayState.stop();
      musicPlayState.setCurrentSongsList(songs);
      musicPlayState.setCurrentSong(songs[0]);
      musicPlayState.play();
      musicPlayState.toggleRotation();
    });
  }

  void handleOnTapAlbums() async {
    print("handleOnTapAlbums");
  }

  void handleOnTapAlbumsSeeAll() async {
    print("handleOnTapAlbumsSeeAll");
  }

  void handleOnTapSongsSeeAll() async {
    print("handleOnTapSongsSeeAll");
  }

  void handleOnTapAlbum(Album tappedAlbum) async {
    print("handleOnTapAlbum");
  }

  void handleOnTapSong(Song tappedSong) async {
    print("handleOnTapSong");
  }

  void handleOnTapArtist(Artist art) async {
    print("handleOnTapArtist");
    setState(() {
      artistStack.add(art);
      artist = art;
    });
  }

  // void handleOnTapDetailSong(Song tappedSong, BuildContext context) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: SongSnackBarContent(
  //           song: tappedSong,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    artist = widget.artist;
    artistStack.add(artist);
    loadArtistInfoData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 400.h,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              // Tính toán vị trí cuộn hiện tại
              double top = constraints.biggest.height;
              return FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: top < 200.h
                      ? Container(
                          key: const ValueKey('NewTitle-Condensed'),
                          color: Colors.grey.shade900,
                          height: 120.h,
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.w,
                                child: InkWell(
                                  onTap: () {
                                    if (artistStack.length == 1) {
                                      widget.popCallBack(context: widget.context);
                                    } else {
                                      setState(() {
                                        artistStack.removeLast();
                                        artist = artistStack.last;
                                      });
                                    }
                                  },
                                  splashColor: const Color.fromRGBO(138, 154, 157, 0.3),
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.r),
                                  ),
                                  borderRadius: BorderRadius.circular(35.r),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: FaIcon(
                                      FontAwesomeIcons.arrowLeft,
                                      size: 25.sp,
                                      color: const Color.fromRGBO(247, 250, 252, 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    artist.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "CenturyGothicBold",
                                      fontSize: 30.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      : Container(
                          key: const ValueKey('NewTitle-Expanded'),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                // Màu bóng mờ
                                spreadRadius: 2,
                                // Độ rộng của bóng mờ
                                blurRadius: 5, // Độ mờ của bóng mờ
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                // Màu bóng mờ
                                spreadRadius: 1,
                                // Độ rộng của bóng mờ
                                blurRadius: 3, // Độ mờ của bóng mờ
                              ),
                            ],
                            color: Colors.transparent,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(183, 183, 183, 0.3411764705882353),
                                Color.fromRGBO(194, 194, 194, 0.4196078431372549),
                                Color.fromRGBO(168, 167, 167, 0.5803921568627451),
                                Color.fromRGBO(168, 167, 167, 0.703921568627451),
                                Color.fromRGBO(168, 167, 167, 0.803921568627451),
                                Color.fromRGBO(143, 143, 143, 0.980392156862745),
                              ],
                            ),
                          ),
                          child: Container(
                            color: Colors.transparent,
                            height: 120.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10.w),
                                  // height: 55.h,
                                  color: Colors.transparent,
                                  child: AutoSizeText(
                                    artist.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicBold',
                                      color: Colors.white,
                                      fontSize: 35.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10.w),
                                  // height: 20.h,
                                  color: Colors.transparent,
                                  child: Text(
                                    numberOfFollowerString,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      color: Colors.grey.shade100,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // height: 45.h,
                                  // color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 110.w,
                                        height: 30.h,
                                        child: PaddingAnimationWidget(
                                          onTap: () {
                                            handleOnTapFollow();
                                          },
                                          miliDuration: 50,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white, width: 1.sp),
                                              borderRadius: BorderRadius.circular(25.r),
                                              color: Colors.grey.shade700.withOpacity(0.7),
                                            ),
                                            child: Text(
                                              isFollowed ? "Followed" : "Follow",
                                              style: TextStyle(
                                                  color: Colors.grey.shade100,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 110.w,
                                          height: 30.h,
                                          child: PaddingAnimationWidget(
                                            onTap: () {
                                              handleOnTapPlay();
                                            },
                                            miliDuration: 50,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.r),
                                                color: const Color.fromRGBO(6, 160, 181, 1.0),
                                              ),
                                              child: Text(
                                                "Play",
                                                style: TextStyle(
                                                    color: Colors.grey.shade100,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      Artist.getUrlImg(artist.picture, artist.id),
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      left: 10.w,
                      top: statusBarHeight + 5.h,
                      width: 50.w,
                      height: 50.w,
                      child: InkWell(
                        onTap: () {
                          if (artistStack.length == 1) {
                            widget.popCallBack(context: widget.context);
                          } else {
                            setState(() {
                              artistStack.removeLast();
                              artist = artistStack.last;
                            });
                          }
                        },
                        splashColor: const Color.fromRGBO(138, 154, 157, 0.3),
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                        borderRadius: BorderRadius.circular(35.r),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.r),
                            color: const Color.fromARGB(182, 82, 89, 91),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            size: 25.sp,
                            color: const Color.fromRGBO(237, 240, 241, 0.8274509803921568),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Container(
              //height: 400.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(21, 21, 21, 0.8156862745098039),
                    Color.fromRGBO(26, 26, 26, 0.8156862745098039),
                    Color.fromRGBO(30, 29, 29, 0.8156862745098039),
                    Color.fromRGBO(42, 42, 42, 0.8156862745098039),
                    Color.fromRGBO(47, 47, 47, 0.8156862745098039),
                  ],
                ),
              ),
              child: Column(
                children: [
                  EffectTap(
                    onTap: () {
                      handleOnTapFeaturedSong();
                    },
                    color: Colors.grey.shade800,
                    child: Container(
                      height: 50.h,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 5.w,
                              right: 5.w,
                              bottom: 5.h,
                            ),
                            child: Text(
                              "Featured Song",
                              style: TextStyle(
                                fontFamily: "CenturyGothicBold",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              size: 25.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        //height: 550.h,
                        child: Column(
                          children: [
                            ...songs.map((song) {
                              return EffectTap(
                                onTap: () {
                                  print(" >>> >>> OnTap: ${song.name}");
                                  handleOnTapSong(song);
                                },
                                color: Colors.grey.shade800,
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(10.r), boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey,
                                      blurStyle: BlurStyle.outer,
                                      offset: Offset(0, 2),
                                      spreadRadius: 2,
                                    )
                                  ]),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60.w,
                                        height: 60.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          image: DecorationImage(
                                            image: NetworkImage(Song.getUrlImg(song.picture, song.id)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: "CenturyGothicBold",
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              song.getArtistNamesString(),
                                              style: TextStyle(
                                                fontFamily: "CenturyGothicRegular",
                                                color: Colors.grey.shade400,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 50.w,
                                        alignment: Alignment.center,
                                        child: EffectTap(
                                          onTap: () {
                                            handleOnTapDetailSong(song, context);
                                          },
                                          miliDuration: 100,
                                          radius: 25.r,
                                          color: Colors.grey.shade800,
                                          child: FaIcon(
                                            FontAwesomeIcons.ellipsisVertical,
                                            size: 18.sp,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              width: 90.w,
                              height: 35.h,
                              child: PaddingAnimationWidget(
                                onTap: () {
                                  handleOnTapSongsSeeAll();
                                },
                                miliDuration: 50,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400, width: 1.sp),
                                    borderRadius: BorderRadius.circular(25.r),
                                    color: Colors.grey.shade700.withOpacity(0.7),
                                  ),
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      fontFamily: "CenturyGothicBold",
                                      color: Colors.grey.shade100,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      EffectTap(
                        onTap: () {
                          handleOnTapAlbums();
                        },
                        color: Colors.transparent,
                        toColor: Colors.grey.shade700,
                        child: Container(
                          height: 55.h,
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 5.w,
                                  bottom: 5.h,
                                ),
                                child: Text(
                                  "Albums",
                                  style: TextStyle(
                                    fontFamily: "CenturyGothicBold",
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 25.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 350.h,
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...albums.map(
                              (album) {
                                return Container(
                                  width: 200.w,
                                  child: PaddingAnimationWidget(
                                    onTap: () {
                                      handleOnTapAlbum(album);
                                    },
                                    miliDuration: 50,
                                    paddingAnimation: 1.r,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 250.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r),
                                              image: DecorationImage(
                                                image: NetworkImage(Album.getUrlImg(album.picture, album.id)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            child: Text(
                                              album.name,
                                              style: TextStyle(
                                                fontFamily: "CenturyGothicRegular",
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                wordSpacing: 0.5.w,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              album.releaseDate,
                                              style: TextStyle(
                                                fontFamily: "CenturyGothicRegular",
                                                fontSize: 14.sp,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(bottom: 100.h),
                              width: 100.w,
                              color: Colors.transparent,
                              margin: EdgeInsets.only(
                                right: 15.w,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EffectTap(
                                    onTap: () {
                                      handleOnTapAlbumsSeeAll();
                                    },
                                    toColor: Colors.grey.shade800,
                                    radius: 60.r,
                                    child: Image.asset(
                                      'assets/images/ic-circled-down-left-arrow.png',
                                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                                      width: 75.w,
                                      height: 75.w,
                                    ),
                                  ),
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromRGBO(255, 255, 255, 0.90),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          bottom: 5.h,
                        ),
                        height: 55.h,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Similar Artists",
                          style: TextStyle(
                            fontFamily: "CenturyGothicBold",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 230.h,
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...similarArtists.map(
                              (artist) {
                                return Container(
                                  width: 200.w,
                                  child: PaddingAnimationWidget(
                                    onTap: () {
                                      handleOnTapArtist(artist);
                                    },
                                    miliDuration: 50,
                                    paddingAnimation: 1.r,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 180.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100.r),
                                              image: DecorationImage(
                                                image: NetworkImage(Artist.getUrlImg(artist.picture, artist.id)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            artist.name,
                                            style: TextStyle(
                                              fontFamily: "CenturyGothicRegular",
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              wordSpacing: 0.5.w,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      bottom: 5.h,
                    ),
                    height: 55.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About Artist",
                      style: TextStyle(
                        fontFamily: "CenturyGothicBold",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Column(
                      children: [
                        Container(
                          height: 50.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150.w,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontFamily: "CenturyGothicRegular",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  artist.name,
                                  style: TextStyle(
                                    fontFamily: "CenturyGothicRegular",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150.w,
                              child: Text(
                                "Description",
                                style: TextStyle(
                                  fontFamily: "CenturyGothicRegular",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                artist.description ?? "",
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontFamily: "CenturyGothicRegular",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150.h,
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
