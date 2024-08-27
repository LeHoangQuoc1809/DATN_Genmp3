import 'dart:convert';

import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/components/padding_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/song_model.dart';
import '../../models/static_data_model.dart';
import '../../provider/GlobalPlaySongSate.dart';
import '../../services/service_mng.dart';
import '../components/components.dart';

class ChartPage extends StatefulWidget {
  ChartPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopInAppBar = false;
  bool _isLoading = true;
  bool isSwipingLeft = false;
  List<Song> songsForGenchart = [];

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      List<Song> songsData = await ModelviewsManager.songModelviews.getTop100SongsListenCountMax();
      setState(() {
        songsForGenchart = songsData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handlePhatNgauNhien() {
    print('--------------------------------handlePhatNgauNhien-----------------------------------');
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

  Widget renderItemSong({
    required int rank,
    required int id,
    required String picture,
    required String songName,
    required String artistName,
  }) {
    rank += 1; // 0 -> 1 -------- 99 -> 100
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
      height: 60.h,
      margin: EdgeInsets.fromLTRB(
        0.w,
        0.h,
        0.w,
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
          height: 60.h,
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
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                width: 40.w,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      rank.toString(),
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      '•',
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 250.w,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        fontSize: 13.sp,
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
    _scrollController.addListener(() {
      if (_scrollController.offset > 50.h && !_showTopInAppBar) {
        setState(() {
          _showTopInAppBar = true;
        });
      } else if (_scrollController.offset <= 50.h && _showTopInAppBar) {
        setState(() {
          _showTopInAppBar = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build ChartPage-----------------------------------');
    return GestureDetector(
      // onHorizontalDragUpdate: (details) {
      //   if (details.delta.dx > 0 &&
      //       !isSwipingLeft &&
      //       details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
      //     // Vuốt từ trái sang phải
      //     widget.onBack();
      //     isSwipingLeft = true; // Đánh dấu đã xử lý vuốt từ trái sang phải
      //   }
      // },
      // onHorizontalDragEnd: (details) {
      //   isSwipingLeft = false; // Đặt lại biến đánh dấu khi kết thúc vuốt ngang
      // },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0.w,
          0.h,
          0.w,
          0.h,
        ),
        width: 428.w,
        height: MediaQuery.of(context).size.height,
        // color: const Color.fromARGB(255, 30, 30, 30),
        color: Colors.transparent,
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(-0.w, -0.h),
              // Di chuyển sang trái 25.w và lên trên 0.h
              child: GestureDetector(
                onTap: () {
                  _scrollToTop();
                },
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: 80.h,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    25.w,
                    0.h,
                    25.w,
                    0.h,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            widget.onBack();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 32.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 32.w),
                          alignment: Alignment.bottomCenter,
                          color: Colors.transparent,
                          child: Text(
                            _showTopInAppBar ? 'Top 100 Genchart' : '',
                            style: TextStyle(
                              fontFamily: 'CenturyGothicBold',
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 13, 72, 79),
                        // Color.fromARGB(255, 16, 43, 45),
                      ),
                    )
                  : songsForGenchart.isEmpty
                      ? Center(
                          child: Text(
                            'No songs available',
                            style: TextStyle(
                              fontFamily: 'CenturyGothicRegular',
                              fontSize: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.fromLTRB(
                            25.w,
                            _showTopInAppBar ? 15.h : 0.h,
                            25.w,
                            0.h,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                            itemCount: songsForGenchart.length + 1,
                            // Thêm 1 để hiển thị header
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                  // color: Colors.black,
                                  child: Column(
                                    children: [
                                      Text(
                                        '#Genchart',
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Container(
                                        width: 250.w,
                                        height: 59.h,
                                        child: PaddingAnimationWidget(
                                          onTap: () {
                                            handlePhatNgauNhien();
                                          },
                                          miliDuration: 50,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(35.r),
                                              color: Color.fromARGB(255, 6, 160, 181),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color.fromARGB(255, 6, 160, 181).withOpacity(0.3),
                                                  // Màu và độ mờ của bóng
                                                  spreadRadius: 5,
                                                  // Bán kính phát tán của bóng
                                                  blurRadius: 3, // Độ mờ của bóng
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'PHÁT NGẪU NHIÊN',
                                              style: TextStyle(
                                                fontFamily: 'CenturyGothicRegular',
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              Song song = songsForGenchart[index - 1];
                              return renderItemSong(
                                rank: index - 1,
                                id: song.id,
                                picture: song.picture,
                                songName: song.name,
                                artistName: song.artists.map((artist) => artist.name).join(', '),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
