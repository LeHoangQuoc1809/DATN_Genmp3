import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/models/playlist_model.dart';
import 'package:client/models/static_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/song_model.dart';
import '../../services/service_mng.dart';
import '../components/components.dart';
import '../components/effect_tap.dart';
import '../components/padding_animation_widget.dart';

class LibraryPage extends StatefulWidget {
  int isLibraryPage;

  LibraryPage({super.key, required this.isLibraryPage});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ScrollController _scrollControllerLibraryPage = ScrollController();
  final ScrollController _scrollControllerItemPlaylistPage = ScrollController();
  bool _showTopInAppBarItemPlaylistPage = false;
  bool _isLoadingLibraryPage = true;
  bool _isLoadingItemPlaylistPage = true;
  List<Playlist> allPlaylistOfUser = [];
  List<Song> allSongOfPlaylist = [];
  bool _isItemPlaylistPage = false;
  Playlist? _currentlyPlaylist = null;

  void _scrollToTop() {
    _scrollControllerLibraryPage.animateTo(
      0.0,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollControllerLibraryPage.dispose();
    _scrollControllerItemPlaylistPage.dispose();
    super.dispose();
  }

  Future<void> loadDataLibraryPage() async {
    try {
      List<Playlist> getAllPlaylistsByUserEmail = await ModelviewsManager.playlistModelview
          .getAllPlaylistsByUserEmail(user_email: StaticData.currentlyUser!.email);
      setState(() {
        allPlaylistOfUser = getAllPlaylistsByUserEmail;
        print('allPlaylistOfUser: ${allPlaylistOfUser}');
        _isLoadingLibraryPage = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoadingLibraryPage = false;
      });
    }
  }

  Future<void> loadDataItemPlaylistPage({
    required int playlist_id,
  }) async {
    try {
      List<Song> getAllSongsByPlaylistId =
          await ModelviewsManager.songModelviews.getAllSongsByPlaylistId(playlist_id: playlist_id);
      setState(() {
        allSongOfPlaylist = getAllSongsByPlaylistId;
        _isLoadingItemPlaylistPage = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoadingItemPlaylistPage = false;
      });
    }
  }

  Future<void> handleCreatePlaylist({
    required BuildContext context,
  }) async {
    final namePlaylistController = TextEditingController(text: '');
    print('-------------------------------------handleCreatePlaylist----------------------------------');

    Future<void> handleCreate() async {
      final namePlaylist = namePlaylistController.text;
      if (namePlaylist != '') {
        Playlist? playlist = await ModelviewsManager.playlistModelview
            .createPlaylistForClient(user_email: StaticData.currentlyUser!.email, name: namePlaylist);
        if (playlist != null) {
          Navigator.of(context).pop(); // Đóng dialog
          loadDataLibraryPage(); // Cập nhật lại dữ liệu
        } else {
          showSnackBar(
            context: context,
            message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
            color: Colors.orange[700]!,
          );
        }
      }
    }

    return await showDialog(
        context: context,
        barrierDismissible: true, // Cho phép đóng dialog khi bấm ra ngoài
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 30, 30, 30),
            title: Container(
              alignment: Alignment.center,
              child: Text(
                "Create Playlist",
                style: TextStyle(
                  fontFamily: 'CenturyGothicBold',
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            content: Container(
              height: 150.h,
              width: 1.w,
              // color: Colors.lightBlueAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.h,
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20), // giới hạn số lượng ký tự là 20
                      ],
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      controller: namePlaylistController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                          0.w,
                          -15.h,
                          0.w,
                          0.h,
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: 'Name playlist',
                        hintStyle: TextStyle(
                          fontFamily: 'CenturyGothicRegular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      // style: TextStyle(
                      //   fontFamily: 'CenturyGothicRegular',
                      //   fontSize: 15.sp,
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '20 characters only',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 0.h,
                    ),
                    width: 377.w,
                    height: 59.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 6, 160, 181),
                      borderRadius: BorderRadius.circular(35.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 6, 160, 181).withOpacity(0.3), // Màu và độ mờ của bóng
                          spreadRadius: 5, // Bán kính phát tán của bóng
                          blurRadius: 3, // Độ mờ của bóng
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        handleCreate();
                      },
                      child: Text(
                        'Create',
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void handleBackToLibraryPage() {
    setState(() {
      _isItemPlaylistPage = false;
      _currentlyPlaylist = null;
      allSongOfPlaylist = [];
    });
    print('--------------------------Clear ItemPlaylistPage On Stack---------------------------');
  }

  Future<void> handleOnTapItemPlaylist({required Playlist playlist}) async {
    // Gọi hàm loadDataItemPlaylistPage và đợi nó hoàn tất
    await loadDataItemPlaylistPage(playlist_id: playlist.id);
    // Sau khi dữ liệu đã được tải xong, cập nhật trạng thái
    setState(() {
      _currentlyPlaylist = playlist;
      _isItemPlaylistPage = true;
      widget.isLibraryPage = 2;
    });
    print('---------------------------Add ItemPlaylistPage On Stack----------------------------');
  }

  String getTotalDuration(List<Song> allSongOfPlaylist) {
    // Tổng thời gian tính bằng Duration
    Duration totalDuration = allSongOfPlaylist.fold<Duration>(Duration(), (sum, song) => sum + song.duration);

    // Chuyển đổi tổng thời gian thành giờ và phút
    int totalMinutes = totalDuration.inMinutes;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    // Hiển thị kết quả
    if (hours > 0) {
      return '$hours giờ $minutes phút';
    } else {
      return '$minutes phút';
    }
  }

  Widget add4PictureForPlaylist({required List<Song> firstFourSongList}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              '${ServiceManager.imgUrl}song/${firstFourSongList[0].id}_${firstFourSongList[0].picture}.png',
              width: 100.w, // Half of the container width
              height: 100.w, // Half of the container height
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.network(
              '${ServiceManager.imgUrl}song/${firstFourSongList[1].id}_${firstFourSongList[1].picture}.png',
              width: 100.w,
              height: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.network(
              '${ServiceManager.imgUrl}song/${firstFourSongList[2].id}_${firstFourSongList[2].picture}.png',
              width: 100.w,
              height: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              '${ServiceManager.imgUrl}song/${firstFourSongList[3].id}_${firstFourSongList[3].picture}.png',
              width: 100.w,
              height: 100.w,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItemPlaylistPage() {
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
        color: const Color.fromARGB(255, 30, 30, 30),
        // color: Colors.transparent,
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
                            handleBackToLibraryPage();
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
                            _showTopInAppBarItemPlaylistPage ? 'Top 100 Genchart' : '',
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
              child: _isLoadingItemPlaylistPage
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 13, 72, 79),
                        // Color.fromARGB(255, 16, 43, 45),
                      ),
                    )
                  : allSongOfPlaylist.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.fromLTRB(
                            25.w,
                            _showTopInAppBarItemPlaylistPage ? 15.h : 0.h,
                            25.w,
                            0.h,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: _scrollControllerItemPlaylistPage,
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                            itemCount: allSongOfPlaylist.length + 1,
                            // Thêm 1 để hiển thị header
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                Song song0 = allSongOfPlaylist[0];
                                List<Song>? firstFourSongList =
                                    allSongOfPlaylist.length >= 4 ? allSongOfPlaylist.sublist(0, 4) : null;
                                print("firstFourSongList: $firstFourSongList");
                                return Container(
                                  // color: Colors.black,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 200.w,
                                        height: 200.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r),
                                          color: Colors.transparent,
                                          image: allSongOfPlaylist.length < 4
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      '${ServiceManager.imgUrl}song/${song0.id}_${song0.picture}.png'),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: allSongOfPlaylist.length >= 4
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(5.r),
                                                child: add4PictureForPlaylist(firstFourSongList: firstFourSongList!),
                                              )
                                            : null,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        _currentlyPlaylist!.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        child: Text(
                                          '${allSongOfPlaylist.length.toString()} bài hát • ${getTotalDuration(allSongOfPlaylist)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothicRegular',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(255, 255, 255, 0.70),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width: 250.w,
                                        height: 59.h,
                                        child: PaddingAnimationWidget(
                                          onTap: () {},
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
                              Song song = allSongOfPlaylist[index - 1];
                              return renderItemSong(
                                rank: index - 1,
                                id: song.id,
                                picture: song.picture,
                                songName: song.name,
                                artistName: song.artists.map((artist) => artist.name).join(', '),
                              );
                            },
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.fromLTRB(
                            25.w,
                            _showTopInAppBarItemPlaylistPage ? 15.h : 0.h,
                            25.w,
                            0.h,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: _scrollControllerItemPlaylistPage,
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                            itemCount: allSongOfPlaylist.length + 1,
                            // Thêm 1 để hiển thị header
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                  // color: Colors.black,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 200.w,
                                        height: 200.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r),
                                          color: Colors.grey.shade600,
                                        ),
                                        child: Image.asset('assets/images/ic-music.png'),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        _currentlyPlaylist!.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
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
        onTap: () {},
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
    loadDataLibraryPage();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLibraryPage == 1) {
      handleBackToLibraryPage();
    }
    return builLibraryPage(context);
  }

  Widget builLibraryPage(BuildContext context) {
    print('--------------------------------Build LibraryPage-----------------------------------');
    return _isLoadingLibraryPage
        ? Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 13, 72, 79),
              // Color.fromARGB(255, 16, 43, 45),
            ),
          )
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  0.w,
                  0.h,
                  0.w,
                  0.h,
                ),
                // color: const Color.fromARGB(255, 30, 30, 30),
                color: Colors.transparent,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scrollToTop();
                      },
                      child: Container(
                        height: 48.h,
                        margin: EdgeInsets.fromLTRB(
                          29.w,
                          53.h,
                          29.w,
                          10.h,
                        ),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.sp), boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 6, 160, 181).withOpacity(0.3),
                                  // Màu và độ mờ của bóng
                                  spreadRadius: 1,
                                  // Bán kính phát tán của bóng
                                  blurRadius: 1, // Độ mờ của bóng
                                )
                              ]),
                              child: Image.asset(
                                'assets/images/logo.png',
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text(
                                "Your Library",
                                style: TextStyle(
                                  fontFamily: 'CenturyGothicBold',
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(0, 194, 203, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        controller: _scrollControllerLibraryPage,
                        padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                        children: [
                          Container(
                            height: 130.h,
                            margin: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0.h),
                            color: Colors.transparent,
                            child: ListView(
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal, // Đặt hướng cuộn là ngang
                              children: [
                                Container(
                                  width: 110.w,
                                  height: 130.h,
                                  margin: EdgeInsets.fromLTRB(
                                    29.w,
                                    0.h,
                                    15.w,
                                    0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    10.w,
                                    10.h,
                                    10.w,
                                    10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white70,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        child: Icon(
                                          Icons.arrow_circle_down_outlined,
                                          size: 40.sp,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Đã tải',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '333',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicRegular',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 110.w,
                                  height: 130.h,
                                  margin: EdgeInsets.fromLTRB(
                                    0.w,
                                    0.h,
                                    15.w,
                                    0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    10.w,
                                    10.h,
                                    10.w,
                                    10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white70,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        child: Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 40.sp,
                                          color: Colors.amber.shade500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Tải Lên',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '111',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicRegular',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 110.w,
                                  height: 130.h,
                                  margin: EdgeInsets.fromLTRB(
                                    0.w,
                                    0.h,
                                    15.w,
                                    0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    10.w,
                                    10.h,
                                    10.w,
                                    10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white70,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        child: Image.asset(
                                          'assets/images/ic-artist.png',
                                          width: 40.w,
                                          height: 40.w,
                                          color: Colors.orange.shade900,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Nghệ sĩ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicBold',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '000',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothicRegular',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              29.w,
                              25.h,
                              29.w,
                              10.h,
                            ),
                            child: Text(
                              'Playlist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'CenturyGothicBold',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              handleCreatePlaylist(context: context);
                            },
                            child: Container(
                              height: 70.h,
                              color: Colors.transparent,
                              margin: EdgeInsets.fromLTRB(
                                29.w,
                                0.h,
                                29.w,
                                15.h,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.h,
                                    height: 70.h,
                                    margin: EdgeInsets.fromLTRB(
                                      0.w,
                                      0.h,
                                      15.w,
                                      0.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white70,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 45.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Tạo playlist',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'CenturyGothicBold',
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allPlaylistOfUser.length,
                            itemBuilder: (context, index) {
                              Playlist playlist = allPlaylistOfUser[index];
                              return GestureDetector(
                                onTap: () {
                                  handleOnTapItemPlaylist(playlist: playlist);
                                },
                                child: Container(
                                  height: 70.h,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.fromLTRB(
                                    29.w,
                                    0.h,
                                    29.w,
                                    15.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70.h,
                                        height: 70.h,
                                        margin: EdgeInsets.fromLTRB(
                                          0.w,
                                          0.h,
                                          15.w,
                                          0.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: Colors.white70,
                                          // image: DecorationImage(
                                          //   image: NetworkImage(
                                          //       '${ServiceManager.imgUrl}album/${(index + 1) * 5}_photo.png'),
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                        child: Image.asset(
                                          'assets/images/bg-login.png',
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                playlist.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicBold',
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                playlist.modifyDate,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicRegula',
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.white,
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _isItemPlaylistPage,
                child: renderItemPlaylistPage(),
              ),
            ],
          );
  }
}
