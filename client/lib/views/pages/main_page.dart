import 'dart:async';

import 'package:client/models/user_model.dart';
import 'package:client/views/components/music_play_bar.dart';
import 'package:client/views/pages/home_page.dart';
import 'package:client/views/pages/profile_page.dart';
import 'package:client/views/pages/register_page.dart';
import 'package:client/views/pages/search/search_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helpers/shared_preferences_helper.dart';
import '../../models/song_model.dart';
import 'package:provider/provider.dart';
import '../../models/static_data_model.dart';
import '../../provider/GlobalPlaySongSate.dart';
import 'library_page.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int isHomePage = 1;
  int isSearchPage = 0;
  int isLibraryPage = 0;
  List<String> navStringIcons = [
    'assets/images/ic-home.png',
    'assets/images/ic-search.png',
    'assets/images/ic-folder.png',
  ];
  List<String> navStringLabels = [
    "Home",
    "Search",
    "Library",
  ];

  Future loadQueueInShareReference() async {
    List<Song> songsForQueueInMusicPlayBar = [
      Song(
        id: 1,
        name: "Chưa",
        duration: const Duration(seconds: 35, minutes: 4),
        picture: "1_Chua-Chau-Khai-Phong-Truc-Anh-Babe",
        listenCount: 0,
        lyric: "lyric",
        album_id: 1,
        artists: [],
        genres: [],
        topics: [],
      ),
      Song(
        id: 2,
        name: "Nếu em muốn chia tay",
        duration: const Duration(seconds: 49, minutes: 4),
        picture: "10_Neu-Em-Muon-Chia-Tay-Chau-Khai-Phong-ACV",
        listenCount: 0,
        lyric: "lyric",
        album_id: 2,
        artists: [],
        genres: [],
        topics: [],
      ),
      Song(
        id: 3,
        name: "Chốn phồn hoa",
        duration: const Duration(seconds: 30, minutes: 4),
        picture: "30_Chon-Phon-Hoa-Chau-Khai-Phong-ACV",
        listenCount: 0,
        lyric: "lyric",
        album_id: 4,
        artists: [],
        genres: [],
        topics: [],
      ),
    ];

    // Delay the state update to ensure it happens after the build phase
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var musicPlayState = Provider.of<MusicPlayState>(context, listen: false);
      musicPlayState.setCurrentSongsList(songsForQueueInMusicPlayBar);
      musicPlayState.setCurrentSong(songsForQueueInMusicPlayBar[1]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQueueInShareReference();
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build MainPage-----------------------------------');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromARGB(255, 30, 30, 30),
        child: Stack(
          children: [
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 220.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 13, 72, 79),
                        Color.fromARGB(255, 16, 43, 45),
                        Color.fromARGB(0, 14, 14, 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: isHomePage == 1
                  ? HomePage(isHomePage: isHomePage)
                  : isSearchPage == 1
                      ? SearchMainPage(isSearchPage: isSearchPage)
                      : isLibraryPage == 1
                          ? LibraryPage(isLibraryPage: isLibraryPage)
                          : SizedBox(),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 283.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black12,
                        Colors.black87,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 140.h,
                child: Column(
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      height: 60.h,
                      child: MusicPlayBar(),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: navStringIcons.map((String) {
                          int index = navStringIcons.indexOf(String);
                          bool isSelected = _currentIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                  if (_currentIndex == 0) {
                                    isHomePage = 1;
                                    isSearchPage = 0;
                                    isLibraryPage = 0;
                                  } else if (_currentIndex == 1) {
                                    isHomePage = 0;
                                    isSearchPage = 1;
                                    isLibraryPage = 0;
                                  } else {
                                    isHomePage = 0;
                                    isSearchPage = 0;
                                    isLibraryPage = 1;
                                  }
                                });
                              },
                              child: Container(
                                //height: 77.h ,
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      navStringIcons[index],
                                      width: 20.w,
                                      height: 20.h,
                                      color: isSelected
                                          ? Color.fromARGB(255, 0, 194, 203)
                                          : Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    Text(
                                      navStringLabels[index],
                                      style: TextStyle(
                                        fontFamily: 'CenturyGothicRegular',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Color.fromARGB(255, 0, 194, 203)
                                            : Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
