import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/song_model.dart';
import '../../provider/GlobalPlaySongSate.dart';
import 'music_play_bar.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayBottomSheet extends StatefulWidget {
  const MusicPlayBottomSheet({super.key});

  @override
  State<MusicPlayBottomSheet> createState() => _MusicPlayBottomSheetState();
}

class _MusicPlayBottomSheetState extends State<MusicPlayBottomSheet> {
  PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  bool is1Mode = false;

  @override
  void initState() {
    print("Init bottom Sheet");
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 1;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(" __________ Rebuild _MusicPlayBottomSheetState");
    return Consumer<MusicPlayState>(
      builder: (context, musicPlayState, child) {
        //
        Stream<Duration> positionStream =
            musicPlayState.audioPlayer.positionStream.map((position) => position ?? Duration.zero).cast<Duration>();

        Stream<Duration> durationStream =
            musicPlayState.audioPlayer.durationStream.map((duration) => duration ?? Duration.zero).cast<Duration>();
        //
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff542271),
              Color(0xff232069),
            ],
          )),
          padding: EdgeInsets.fromLTRB(5.w, 35.h, 5.w, 60.h),
          child: Column(
            children: [
              Container(
                //height: 60.h,
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      child: IconButton(
                        onPressed: () {},
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          FontAwesomeIcons.angleDown,
                          size: 25.sp,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "Play from",
                              style: TextStyle(
                                fontFamily: "CenturyGothicRegular",
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Search",
                              style: TextStyle(
                                fontFamily: "CenturyGothicBold",
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              height: 10.h,
                              color: Colors.lightBlueAccent,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 50.w,
                      height: 50.w,
                      child: IconButton(
                        onPressed: () {},
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 25.sp,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Text("Page Left"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              50.h,
                              0,
                              50.h,
                            ),
                            child: Container(
                              width: 300.w,
                              height: 300.h,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade700,
                                    spreadRadius: 10.sp,
                                    offset: Offset(0, 5),
                                    blurRadius: 150.r,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(500.r),
                                child: RotateDisc(
                                  isPlaying: musicPlayState.isPlaying,
                                  child: Image.network(
                                    Song.getUrlImg(
                                      musicPlayState.currentSong.picture,
                                      musicPlayState.currentSong.id,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              musicPlayState.currentSong.name,
                              style: TextStyle(
                                fontFamily: "CenturyGothicBold",
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            child: Text(
                              musicPlayState.currentSong.name,
                              style: TextStyle(
                                fontFamily: "CenturyGothicRegular",
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Text("Page Right"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<Duration>(
                stream: Rx.combineLatest2<Duration, Duration, Duration>(
                  positionStream,
                  durationStream,
                  (position, duration) => position,
                ),
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = musicPlayState.audioPlayer.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _printDuration(position),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            _printDuration(duration),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          trackHeight: 2.0,
                          // Làm mỏng thanh trượt
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          overlayColor: Colors.white.withOpacity(0.2),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            final newPosition = Duration(seconds: value.toInt());
                            musicPlayState.audioPlayer.seek(newPosition);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              Container(
                //Music Play bar
                height: 100.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {},
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          FontAwesomeIcons.shuffle,
                          size: 20.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          musicPlayState.onBackTap();
                        },
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          FontAwesomeIcons.backward,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    musicPlayState.isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 5.sp, color: Colors.white),
                              borderRadius: BorderRadius.circular(35.r),
                            ),
                            child: IconButton(
                              onPressed: () {
                                musicPlayState.onPlayTap();
                              },
                              splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                              highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                              icon: FaIcon(
                                musicPlayState.isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                                size: 35.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          musicPlayState.onNextTap();
                        },
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          FontAwesomeIcons.forward,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: is1Mode ? 2.sp : 0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(35.r),
                      ),
                      child: IconButton(
                        onPressed: () {
                          switch (musicPlayState.mode) {
                            case 0:
                              print("musicPlayState.mode:${musicPlayState.mode}");
                              musicPlayState.setMode(2);
                              break;
                            case 1:
                              print("musicPlayState.mode case 1:${musicPlayState.mode}");
                              setState(() {
                                is1Mode = false;
                                musicPlayState.setMode(0);
                              });
                              break;
                            case 2:
                              print("musicPlayState.mode case 2:${musicPlayState.mode}");
                              setState(() {
                                is1Mode = true;
                                musicPlayState.setMode(1);
                              });
                              break;
                          }
                        },
                        splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn
                        highlightColor: Colors.grey.withOpacity(0.1), // Màu nền khi giữ
                        icon: FaIcon(
                          is1Mode ? FontAwesomeIcons.one : FontAwesomeIcons.repeat,
                          size: 20.sp,
                          color: musicPlayState.mode != 0 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
