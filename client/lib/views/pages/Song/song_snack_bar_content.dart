import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/song_model.dart';
import '../../../provider/GlobalPlaySongSate.dart';
import '../../components/effect_tap.dart';

class SongSnackBarContent extends StatefulWidget {
  Song song;

  SongSnackBarContent({super.key, required this.song});

  @override
  State<SongSnackBarContent> createState() => _SongSnackBarContentState();
}

class _SongSnackBarContentState extends State<SongSnackBarContent> {
  @override
  void initState() {
    super.initState();
  }

  Future handleShareIconOnTap() async {
    print("handleShareIconOnTap");
  }

  Future handleDownloadOnTap() async {
    print("handleDownloadOnTap");
  }

  Future handleAddToCurrentQueueOnTap() async {
    print("handleAddToCurrentQueueOnTap");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var musicPlayState = Provider.of<MusicPlayState>(context, listen: false);
      musicPlayState.addToLastCurrentSongsList(widget.song);
    });
  }

  Future handlePlayThisAndSimilarQueueOnTap() async {
    print("handlePlayThisAndSimilarQueueOnTap");
  }

  Future handleGoToAlbumOnTap() async {
    print("handleGoToAlbumOnTap");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/bg-otp.png"),
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
                        widget.song.name,
                        style: TextStyle(
                          fontFamily: "CenturyGothicBold",
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        widget.song.getArtistNamesString(),
                        style: TextStyle(
                          fontFamily: "CenturyGothicRegular",
                          color: Colors.grey.shade400,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                EffectTap(
                  onTap: handleShareIconOnTap,
                  toColor: Colors.white,
                  radius: 30.r,
                  miliDuration: 300,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.share,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
          Divider(
            height: 1.sp,
            color: Colors.grey,
          ),
          buildActionItem(
            icon: FontAwesomeIcons.download,
            label: "Download",
            onTap: handleDownloadOnTap,
          ),
          buildActionItem(
            icon: FontAwesomeIcons.plus,
            label: "Add to Current Queue",
            onTap: handleAddToCurrentQueueOnTap,
          ),
          buildActionItem(
            icon: FontAwesomeIcons.circlePlay,
            label: "Play This and Similar Queue",
            onTap: handlePlayThisAndSimilarQueueOnTap,
          ),
          buildActionItem(
            icon: FontAwesomeIcons.compactDisc,
            label: "Go to Album",
            onTap: handleGoToAlbumOnTap,
          ),
        ],
      ),
    );
  }

  Widget buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return EffectTap(
      toColor: Colors.grey.shade900,
      onTap: onTap,
      child: Container(
        height: 70.h,
        padding: EdgeInsets.all(15.r),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 20.sp,
              color: Colors.white,
            ),
            SizedBox(width: 20.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: "CenturyGothicRegular",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
