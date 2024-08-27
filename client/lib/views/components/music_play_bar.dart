import 'dart:convert';
import 'dart:ui';
import 'package:client/models/artist_model.dart';
import 'package:client/models/static_data_model.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/components/music_play_bottom_sheet.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/song_model.dart';
import 'dart:typed_data';

import '../../provider/GlobalPlaySongSate.dart';

class MusicPlayBar extends StatefulWidget {
  MusicPlayBar({
    super.key,
  });

  @override
  State<MusicPlayBar> createState() => _MusicPlayBarState();
}

class _MusicPlayBarState extends State<MusicPlayBar> {
  @override
  Widget build(BuildContext context) {
    print("--------------------------------Build Music Play Bar-----------------------------");
    return Consumer<MusicPlayState>(
      builder: (context, musicPlayState, child) {
        return EffectTap(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return MusicPlayBottomSheet();
              },
            );
          },
          toColor: Colors.grey.shade300,
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 40.w,
                height: 40.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: RotateDisc(
                    isPlaying: musicPlayState.isPlaying,
                    child: Image.network(
                      Song.getUrlImg(musicPlayState.currentSong.picture, musicPlayState.currentSong.id),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 170.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicPlayState.currentSong.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "CenturyGothicRegular",
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      musicPlayState.currentSong.getArtistNamesString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "CenturyGothicRegular",
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  musicPlayState.onBackTap();
                },
                icon: FaIcon(
                  FontAwesomeIcons.backward,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  musicPlayState.onPlayTap();
                },
                icon: musicPlayState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : FaIcon(
                        musicPlayState.isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                        size: 25.sp,
                        color: Colors.white,
                      ),
              ),
              IconButton(
                onPressed: () {
                  musicPlayState.onNextTap();
                },
                icon: FaIcon(
                  FontAwesomeIcons.forward,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RotateDisc extends StatefulWidget {
  final Widget child;
  final bool isPlaying;

  RotateDisc({super.key, required this.child, required this.isPlaying});

  @override
  State<RotateDisc> createState() => _RotateDiscState();
}

class _RotateDiscState extends State<RotateDisc> with SingleTickerProviderStateMixin {
  //late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2),
    // );
    // if (widget.isPlaying) {
    //   _controller.repeat();
    // } else {
    //   _controller.stop();
    // }
  }

  // @override
  // void didUpdateWidget(RotateDisc oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.isPlaying) {
  //     _controller.repeat();
  //   } else {
  //     _controller.stop();
  //   }
  // }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayState>(
      builder: (context, musicPlayState, child) {
        return RotationTransition(
          turns: musicPlayState.controllerDisc,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: widget.child,
          ),
        );
      },
    );
  }
}
