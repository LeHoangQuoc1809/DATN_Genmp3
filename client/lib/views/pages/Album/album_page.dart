import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/models/album_model.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/components/padding_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/artist_model.dart';
import '../../../models/song_model.dart';

class AlbumPage extends StatefulWidget {
  BuildContext context;

  Album album;

  Function popCallBack;

  AlbumPage({
    super.key,
    required this.context,
    required this.album,
    required this.popCallBack,
  });

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  int i = 0;

  late Album album;

  List<Color> generateGradientColors(Color startColor, Color endColor, int steps) {
    List<Color> colors = [];
    for (int i = 0; i < steps; i++) {
      double t = i / (steps - 1);
      int red = (startColor.red + (endColor.red - startColor.red) * t).round();
      int green = (startColor.green + (endColor.green - startColor.green) * t).round();
      int blue = (startColor.blue + (endColor.blue - startColor.blue) * t).round();
      colors.add(Color.fromARGB(255, red, green, blue));
    }
    return colors;
  }

  void handleOnTapSong(Song tappedSong) async {
    print("handleOnTapSong");
  }

  void handleOnTapDetailSong(Song song, BuildContext context) async {
    print("handleOnTapDetailSong");
  }

  void handleOnTapArtist(Artist art) async {
    print("handleOnTapArtist");
  }

  @override
  void initState() {
    super.initState();
    album = widget.album;
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    Color startColor = const Color.fromARGB(255, 66, 66, 70);
    Color endColor = const Color.fromARGB(255, 38, 42, 42);
    List<Color> gradientColors = generateGradientColors(startColor, endColor, 10);
    List<Color> gradientReverseColors = generateGradientColors(endColor, startColor, 10);
    int minutesTotal = 0;
    for (var song in album.songs) {
      minutesTotal += song.duration.inMinutes;
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500.h,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  title: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: top < 150.h
                        ? Container(
                            key: const ValueKey('NewTitle-Condensed'),
                            color: Colors.grey.shade900,
                            height: 120.h,
                            padding: EdgeInsets.only(top: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35.r),
                                  ),
                                  child: EffectTap(
                                    onTap: () {},
                                    toColor: Colors.grey,
                                    radius: 35.r,
                                    child: FaIcon(
                                      FontAwesomeIcons.arrowLeft,
                                      size: 25.sp,
                                      color: const Color.fromRGBO(247, 250, 252, 1.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      album.name,
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
                                Container(
                                  width: 50.w,
                                  height: 40.h,
                                  child: PaddingAnimationWidget(
                                    onTap: () {},
                                    miliDuration: 50,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 13, 72, 79),
                                        borderRadius: BorderRadius.circular(25.r),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons.random,
                                          size: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(60.w, 110.h, 60.w, 0.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: gradientColors,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 300.w,
                              height: 300.h,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 5.sp,
                                    spreadRadius: 5.sp,
                                  ),
                                ],
                              ),
                              child: Image.network(
                                Album.getUrlImg(album.picture, album.id),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                album.name,
                                style: TextStyle(
                                  fontFamily: "CenturyGothicBold",
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                album.artist != null ? album.artist!.name : "",
                                style: TextStyle(
                                  fontFamily: "CenturyGothicRegular",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              width: 200.w,
                              height: 45.h,
                              child: PaddingAnimationWidget(
                                onTap: () {},
                                miliDuration: 50,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 13, 72, 79),
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(bottom: 5.h),
                                        child: Text(
                                          "Play Now",
                                          style: TextStyle(
                                            fontFamily: "CenturyGothicBold",
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons.random,
                                          size: 18.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10.w,
                        top: statusBarHeight + 5.h,
                        width: 50.w,
                        height: 50.w,
                        child: InkWell(
                          onTap: () {
                            widget.popCallBack(context: widget.context);
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
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientReverseColors,
                ),
              ),
              child: Column(
                children: [
                  ...album.songs.map((song) {
                    return EffectTap(
                      onTap: () {
                        print(" >>> >>> OnTap: ${song.name}");
                        handleOnTapSong(song);
                      },
                      color: Colors.grey.shade800,
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), boxShadow: const [
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
                              padding: EdgeInsets.only(left: 5.w, right: 8.w),
                              alignment: Alignment.center,
                              child: Text(
                                "${++i}",
                                style: TextStyle(
                                  fontFamily: "CenturyGothicBold",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
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
                  Container(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      bottom: 5.h,
                    ),
                    height: 55.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "More About Album",
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
                                  "Release Date",
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
                                  album.releaseDate,
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
                        Container(
                          height: 40.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150.w,
                                child: Text(
                                  "${album.songs.length} Songs",
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
                                  "$minutesTotal minutes",
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
                        ),
                        Container(
                          height: 40.h,
                          child: Row(
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
                                  album.description ?? "",
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
                    height: 100.h,
                    padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 5.h),
                    child: PaddingAnimationWidget(
                      onTap: () {
                        handleOnTapArtist(album.artist!);
                      },
                      miliDuration: 50,
                      paddingAnimation: 1.r,
                      child: Container(
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h, top: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 68.w,
                              height: 90.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                image: DecorationImage(
                                  image: NetworkImage(Artist.getUrlImg(album.artist!.picture, album.artist!.id)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 250.w,
                                    child: Text(
                                      album.artist!.name,
                                      style: TextStyle(
                                        fontFamily: "CenturyGothicBold",
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "134K Follower",
                                    style: TextStyle(
                                      fontFamily: "CenturyGothicRegular",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
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
