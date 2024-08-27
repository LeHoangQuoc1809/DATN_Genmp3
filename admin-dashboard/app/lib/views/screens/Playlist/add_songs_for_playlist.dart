import 'package:app/configs/rss.dart';
import 'package:app/models/song.dart';
import 'package:app/views/components/PushDown_GestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../modelViews/modelViews_mng.dart';
import '../../../models/artist.dart';
import '../../../services/service_mng.dart';
import '../../components/circel_picture_component.dart';
import '../../components/content_frame.dart';
import '../../components/suggestion_search_bar.dart';

class AddSongsForPlaylist extends StatefulWidget {
  const AddSongsForPlaylist({
    Key? key,
  }) : super(key: key);

  @override
  State<AddSongsForPlaylist> createState() => _AddSongsForPlaylistState();
}

class _AddSongsForPlaylistState extends State<AddSongsForPlaylist> {
  List<dynamic> suggestions = [];
  List<Song> _songs = [];

  List<Song> _unselectedCallbackSongs = [];
  List<Song> _unselectedDisplaySongs = [];

  List<Song> _selectedCallbackSongs = [];
  List<Song> _selectedDisplaySongs = [];

  final FocusNode focusNode = FocusNode();
  bool showSuggestions = false;
  TextEditingController searchUnselectedController = TextEditingController();

  TextEditingController searchSelectedController = TextEditingController();

  Future loadData() async {
    List<Song> songs = await ModelviewsManager.songModelviews.getAllSongs();

    setState(() {
      _songs = songs;
      _unselectedDisplaySongs = List.from(songs);
      _unselectedCallbackSongs = List.from(songs);
    });
  }

  void updateListViewContentForSearching(List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _unselectedCallbackSongs = List.from(_unselectedDisplaySongs);
        _unselectedDisplaySongs = [];
      } else if (isaSsign) {
        _unselectedCallbackSongs = List.from(_unselectedDisplaySongs);
        _unselectedDisplaySongs = newData.map((i) => i as Song).toList();
      } else {
        _unselectedDisplaySongs = List.from(_unselectedCallbackSongs);
      }
    });
  }

  void updateSelectedListViewContentForSearching(
      List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _selectedCallbackSongs = List.from(_selectedDisplaySongs);
        _selectedDisplaySongs = [];
      } else if (isaSsign) {
        _selectedCallbackSongs = List.from(_selectedDisplaySongs);
        _selectedDisplaySongs = newData.map((i) => i as Song).toList();
      } else {
        _selectedDisplaySongs = List.from(_selectedCallbackSongs);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return AlertDialog(
      title: Container(
        width: double.infinity,
        child: Text(
          "Add Songs",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: rss.u * 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF48BB78),
          ),
        ),
      ),
      content: Row(
        children: [
          Expanded(
            flex: 10,
            child: ContentFrame(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: rss.u * 30,
                          left: rss.u * 0,
                          right: rss.u * 0,
                          bottom: 0,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    // Header Row
                                    _buildTableHeaderRow(
                                        rss: rss, headers: headers),
                                    // Content Rows
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            _unselectedDisplaySongs.length,
                                        itemBuilder: (context, index) {
                                          return _buildTableContentRow(
                                            rss: rss,
                                            song:
                                                _unselectedDisplaySongs[index],
                                            bgColor: index % 2 == 0
                                                ? const Color(0xc8eceff3)
                                                : null,
                                            isAddAction: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: rss.u * 100,
                          width: rss.u * 250,
                          padding: EdgeInsets.only(
                            left: rss.u * 40,
                            right: rss.u * 40,
                          ),
                          child: SuggestionSearchBar(
                            controller: searchUnselectedController,
                            data: _unselectedDisplaySongs,
                            searchExecutionEvent:
                                updateListViewContentForSearching,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.arrowRight,
                    size: rss.u * 10,
                    color: const Color(0xffA0AEC0),
                  ),
                  SizedBox(
                    height: rss.u * 5,
                  ),
                  FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: rss.u * 10,
                    color: const Color(0xffA0AEC0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: ContentFrame(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: rss.u * 30,
                          left: rss.u * 0,
                          right: rss.u * 0,
                          bottom: 0,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    // Header Row
                                    _buildTableHeaderRow(
                                        rss: rss, headers: headers),
                                    // Content Rows
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _selectedDisplaySongs.length,
                                        itemBuilder: (context, index) {
                                          return _buildTableContentRow(
                                            rss: rss,
                                            song: _selectedDisplaySongs[index],
                                            bgColor: index % 2 == 0
                                                ? const Color(0xc8eceff3)
                                                : null,
                                            isAddAction: false,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: rss.u * 100,
                          width: rss.u * 250,
                          padding: EdgeInsets.only(
                            left: rss.u * 40,
                            right: rss.u * 40,
                          ),
                          child: SuggestionSearchBar(
                            controller: searchSelectedController,
                            data: _selectedDisplaySongs,
                            searchExecutionEvent:
                                updateSelectedListViewContentForSearching,
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
      actions: [
        Container(
          width: rss.u * 35,
          height: rss.u * 15,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                // Specifies the shape of the button's border
                borderRadius: BorderRadius.circular(rss.u * 8),
                // Rounded corners with a radius of 8
                side: BorderSide(
                  color: const Color(0xFF48BB78), // Color of the border
                  width: rss.u * 0.5, // Width of the border
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                fontSize: rss.u * 6,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF48BB78),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          width: rss.u * 35,
          height: rss.u * 15,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF48BB78),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rss.u * 8),
              ),
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.roboto(
                  fontSize: rss.u * 6,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFFFFFF)),
            ),
            onPressed: () {
              Navigator.of(context).pop(_selectedCallbackSongs);
            },
          ),
        ),
      ],
    );
  }

  List<String> headers = ["picture", "name", "artist", "Action"];

  Widget _buildTableHeaderRow(
      {required RSS rss, required List<String> headers, Color? bgColor}) {
    return Container(
      padding: EdgeInsets.only(
        top: rss.u * 2,
        bottom: rss.u * 2,
      ),
      child: Row(
        children: headers.map((header) {
          int flex = 3;
          switch (header) {
            case "Action":
              flex = 3;
              break;
            case "picture":
              flex = 3;
              break;
            default:
              flex = 4;
          }
          return Expanded(
            flex: flex,
            child: Container(
              padding: EdgeInsets.all(rss.u * 2),
              alignment: header == "Action" || header == "picture"
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Text(
                header.toUpperCase(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: rss.u * 8,
                  color: const Color(0xffA0AEC0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableContentRow({
    required RSS rss,
    required Song song,
    Color? bgColor = Colors.transparent,
    bool isAddAction = false,
  }) {
    TextStyle styleContentRow = GoogleFonts.roboto(
      fontSize: rss.u * 6,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF2D3748),
    );
    EdgeInsets edgeInsets = EdgeInsets.only(left: rss.u * 2, right: rss.u * 2);
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(rss.u * 5),
      ),
      child: Column(
        children: [
          SizedBox(
            height: rss.u * 5,
          ),
          Row(
            children: [
              CircelPictureComponent(
                rss: rss,
                flex: 3,
                src: Song.getUrlImg(song.picture, song.id),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.name,
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.artists?.map((artist) => artist.name).join(', ') ?? "",
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  width: rss.u * 20,
                  child: PushdownGesturedetector(
                    elevation: rss.u * 1,
                    onTapDownElevation: rss.u * 2,
                    radius: rss.u * 10,
                    onTap: () {
                      setState(() {
                        if (isAddAction) {
                          _selectedDisplaySongs.add(song);
                          _selectedCallbackSongs.add(song);

                          _unselectedCallbackSongs.remove(song);
                          _unselectedDisplaySongs.remove(song);
                        } else {
                          _selectedCallbackSongs.remove(song);
                          _selectedDisplaySongs.remove(song);

                          _unselectedCallbackSongs.add(song);
                          _unselectedDisplaySongs.add(song);
                        }
                      });
                      //Navigator.of(context).pop(song);
                    },
                    child: Text(
                      isAddAction ? "Selected" : "Unselected",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: rss.u * 5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: rss.u * 5,
          ),
        ],
      ),
    );
  }
}
