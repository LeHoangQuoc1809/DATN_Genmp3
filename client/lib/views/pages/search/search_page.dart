import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/models/album_model.dart';
import 'package:client/models/artist_model.dart';
import 'package:client/models/playlist_model.dart';
import 'package:client/views/components/effect_tap.dart';
import 'package:client/views/pages/Artist/artist_infor_page.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/genre_model.dart';
import '../../../models/song_model.dart';
import '../../../models/topic_model.dart';
import '../../../provider/GlobalPlaySongSate.dart';
import '../../components/components.dart';
import '../Album/album_page.dart';
import '../Playlist/playlist_page.dart';
import 'loading_search_tag_display.dart';
import 'loading_tag_display.dart';

class SearchPage extends StatefulWidget {
  Function onBackTap;

  SearchPage({
    super.key,
    required this.onBackTap,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  final _textFieldKey = GlobalKey();

  Timer? _debounce;

  List<dynamic> _suggestionsList = [];

  List<dynamic> _backupSuggestionsList = [];

  bool _isSuggested = false;

  bool _isSuggestionsLoading = false;

  late Future<void> _getSuggestionsDataState;

  int _selectedIndex = -1;

  Widget currentWidget = Container();

  List<String> buttonLabels = ["Songs", "Playlists", "Artists", "Albums"];

  List<String> backupButtonLabels = ["Songs", "Playlists", "Artists", "Albums"];

  //handling function
  Future runDebounceTimer(String query) async {
    print("runDebounceTimer with${query}");
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      setState(() {
        if (query.isNotEmpty) {
          _isSuggested = true;
          _isSuggestionsLoading = true;
        } else {
          _isSuggested = false;
          _isSuggestionsLoading = false;
        }
        buttonLabels = backupButtonLabels;
        currentWidget = buildSearchPage(context); // Thêm dòng này
      });
      await getSuggestionsData(query);
    });
  }

  Future fetchData() async {
    Future.delayed(Duration(milliseconds: 500));
  }

  Future getSuggestionsData(String query) async {
    if (query.isEmpty) return;
    //await 3 tác vụ truy vấn từ server
    //artist, song, playlist,
    print("getSuggestedData is Starting now");
    List<dynamic> suggestionsList = [];

    //Real api call

    dynamic searchData = await ModelviewsManager.searchModelview.getTop5Search(query);

    suggestionsList.addAll(searchData['artists']);
    suggestionsList.addAll(searchData['albums']);
    suggestionsList.addAll(searchData['playlists']);
    suggestionsList.addAll(searchData['songs']);

    setState(() {
      print("setState in");
      _suggestionsList = suggestionsList;
      _backupSuggestionsList = suggestionsList;
      _isSuggestionsLoading = false;

      currentWidget = buildSearchPage(context); // Thêm dòng này
    });
  }

  void popPageCallBack({required BuildContext context}) {
    setState(() {
      currentWidget = buildSearchPage(context);
    });
  }

  List<Song> getQueueOfSong(Song song) {
    List<Song> songs = [song, song, song, song, song];
    return songs;
  }

  void changePage({required BuildContext context, required dynamic object}) async {
    if (object is Artist) {
      currentWidget = ArtistInforPage(
        context: context,
        artist: object,
        popCallBack: popPageCallBack,
      );
    } else if (object is Song) {
      List<Song> queue = await getQueueOfSong(object);

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        var musicPlayState = Provider.of<MusicPlayState>(context, listen: false);
        musicPlayState.stop();
        musicPlayState.setCurrentSongsList(queue);
        musicPlayState.setCurrentSong(queue[0]);
        musicPlayState.play();
        musicPlayState.toggleRotation();
      });
    } else if (object is Playlist) {
      currentWidget = PlaylistPage(
        context: context,
        playlist: object,
        popCallBack: popPageCallBack,
      );
    } else if (object is Album) {
      currentWidget = AlbumPage(
        context: context,
        album: object,
        popCallBack: popPageCallBack,
      );
    }
  }

  Future getSpecificSuggestions(String label) async {
    List<dynamic> data = [];
    if (label == "Songs") {
      data = await ModelviewsManager.songModelviews.get50SongsForSearch(_searchController.text);
    } else if (label == "Playlists") {
      data = await ModelviewsManager.playlistModelview.get50PlaylistsForSearch(_searchController.text);
    } else if (label == "Albums") {
      data = await ModelviewsManager.albumModelview.get50AlbumsForSearch(_searchController.text);
    } else {
      data = await ModelviewsManager.artistModelview.get50ArtistsForSearch(_searchController.text);
    }

    setState(() {
      if (data.isEmpty) {
        _suggestionsList = [""];
      } else {
        _suggestionsList = data;
      }
      currentWidget = buildSearchPage(context);
    });
  }

  //init
  @override
  void initState() {
    super.initState();
    currentWidget = buildSearchPage(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild SearchPage");
    return currentWidget;
  }

  Widget buildSearchPage(BuildContext context) {
    print("rebuild buildSearchPage");
    return GestureDetector(
      onTap: () {
        onDismissKeyboard(context);
      },
      onHorizontalDragStart: (details) {
        if (details.globalPosition.dx < 150) {
          widget.onBackTap();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: (22.h + 18.h + 0.h),
            ),
            Container(
              height: 70.h,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      widget.onBackTap();
                    },
                    splashColor: const Color.fromRGBO(138, 154, 157, 0.3),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.r),
                    ),
                    borderRadius: BorderRadius.circular(35.r),
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        size: 25.sp,
                        color: const Color.fromARGB(255, 138, 154, 157),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                    height: 60.h,
                  ),
                  Container(
                    height: 55.h,
                    width: 333.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20.w, 0, 0.w, 0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(138, 154, 157, 0.3),
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: _searchController,
                            cursorColor: const Color.fromRGBO(255, 138, 154, 157),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search now",
                              hintStyle: TextStyle(
                                fontFamily: 'CenturyGothicRegular',
                                color: const Color.fromARGB(179, 153, 162, 169),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _suggestionsList = [];
                                    _isSuggested = false;
                                    _debounce?.cancel();
                                    buttonLabels = backupButtonLabels;
                                    currentWidget = buildSearchPage(context);
                                  });
                                },
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 15.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.x,
                                    size: 25.sp,
                                    color: const Color.fromARGB(255, 138, 154, 157),
                                  ),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'CenturyGothicRegular',
                              color: const Color.fromARGB(255, 194, 205, 215),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.normal,
                            ),
                            onChanged: (text) {
                              runDebounceTimer(text);
                            },
                            onSubmitted: (text) {},
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: !_isSuggested
                    ? Center(
                        child: Container(
                          width: 300.w,
                          child: Text(
                            "Search for artists, songs, and more.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'CenturyGothicBold',
                              color: const Color.fromARGB(255, 194, 205, 215),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                    : _isSuggestionsLoading
                        ? const LoadingSearchTagDisplay()
                        : _suggestionsList.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 5.w, 8.h),
                                    height: 60.h,
                                    child: ListView(scrollDirection: Axis.horizontal, children: [
                                      if (buttonLabels.length == 1) ...{
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: EffectTap(
                                            onTap: () {
                                              setState(() {
                                                buttonLabels = List.from(backupButtonLabels);
                                                _suggestionsList = _backupSuggestionsList;
                                                currentWidget = buildSearchPage(context);
                                              });
                                            },
                                            child: Container(
                                              width: 40.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.r),
                                                color: const Color.fromRGBO(87, 87, 87, 0.6588235294117647),
                                              ),
                                              alignment: Alignment.center,
                                              child: FaIcon(
                                                FontAwesomeIcons.x,
                                                size: 18.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      },
                                      ...buttonLabels.map((label) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: EffectTap(
                                            onTap: () {
                                              setState(() {
                                                buttonLabels = [label];
                                                getSpecificSuggestions(label);
                                              });
                                            },
                                            color: const Color.fromRGBO(87, 87, 87, 0.6588235294117647),
                                            radius: 25.r,
                                            child: Container(
                                              width: 100.w,
                                              height: 50.h,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.r),
                                              ),
                                              child: Text(
                                                label,
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicRegular',
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(bottom: 150.h),
                                        itemCount: _suggestionsList.length,
                                        itemBuilder: (context, index) {
                                          dynamic item;
                                          String typeItem = "";
                                          String subTitle = "";
                                          double radius = 15.r;
                                          item = _suggestionsList[index];
                                          String urlImg = "";

                                          Widget returnWidget;

                                          if (item is Artist) {
                                            typeItem = "Artist";
                                            subTitle = item.description ?? "No Description";
                                            radius = 60.r;
                                            urlImg = Artist.getUrlImg(item.picture, item.id);
                                          } else if (item is Playlist) {
                                            typeItem = "Playlist";
                                            subTitle = item.modifyDate;
                                            urlImg = Playlist.getUrlImg(item.picture, item.id);
                                          } else if (item is Song) {
                                            typeItem = "Song";
                                            subTitle = item.getArtistNamesString();
                                            urlImg = Song.getUrlImg(item.picture, item.id);
                                          } else if (item is Album) {
                                            typeItem = "Album";
                                            subTitle = (item.artist != null ? item.artist!.name : "No Artist");
                                            urlImg = Album.getUrlImg(item.picture, item.id);
                                          } else {
                                            item = "";
                                          }
                                          if (item == "") {
                                            returnWidget = Center(
                                              child: Text(
                                                'No Data',
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicBold',
                                                  color: Colors.white,
                                                  fontSize: 35.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          } else {
                                            returnWidget = EffectTap(
                                              toColor: Colors.white,
                                              miliDuration: 500,
                                              onTap: () {
                                                print("onTapItem");
                                                setState(() {
                                                  changePage(context: context, object: item);
                                                  _selectedIndex = index;
                                                });
                                              },
                                              child: Container(
                                                height: 120.h,
                                                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                                                color: Colors.grey.shade900.withOpacity(0.8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 20.w),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(radius),
                                                        child: Image.network(
                                                          urlImg,
                                                          fit: BoxFit.cover,
                                                          width: 75.w,
                                                          height: 75.h,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              width: 230.w,
                                                              child: Text(
                                                                item.name,
                                                                textAlign: TextAlign.left,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontFamily: 'CenturyGothicBold',
                                                                  color: const Color.fromARGB(
                                                                    255,
                                                                    239,
                                                                    235,
                                                                    235,
                                                                  ),
                                                                  fontSize: 20.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3.h,
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(right: 10.w),
                                                              child: Text(
                                                                '$typeItem • $subTitle',
                                                                textAlign: TextAlign.left,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontFamily: 'CenturyGothicRegular',
                                                                  color: const Color.fromARGB(
                                                                    255,
                                                                    220,
                                                                    216,
                                                                    216,
                                                                  ),
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (item is Song)
                                                      EffectTap(
                                                        onTap: () {
                                                          handleOnTapDetailSong(item, context);
                                                        },
                                                        toColor: Colors.grey,
                                                        radius: 35.r,
                                                        miliDuration: 200,
                                                        child: Container(
                                                          width: 60.w,
                                                          alignment: Alignment.center,
                                                          child: FaIcon(
                                                            FontAwesomeIcons.ellipsisVertical,
                                                            size: 25.sp,
                                                            color: const Color.fromARGB(199, 195, 195, 204),
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return returnWidget;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'No Data',
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicBold',
                                    color: Colors.white,
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
