import 'package:app/views/components/circel_picture_component.dart';
import 'package:app/views/components/content_frame.dart';
import 'package:app/views/components/content_panel.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:app/views/screens/Song/song_feature_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/rss.dart';
import '../../../models/artist.dart';
import '../../../models/song.dart';
import '../../../services/service_mng.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/actions_button_row.dart';
import '../../components/suggestion_search_bar.dart';
import '../../components/warning_delete_dialog.dart';

class SongContentPanel extends StatefulWidget {
  RSS rss;

  SongContentPanel({super.key, required this.rss});

  @override
  State<SongContentPanel> createState() => _SongContentPanelState();
}

class _SongContentPanelState extends State<SongContentPanel> {
  List<Song> _songs = [];

  List<Song> _searchSongs = [];

  RSS rss = RSS();

  bool _isLoading = true; // Add this line

  TextEditingController searchController = TextEditingController();

  Future loadData() async {
    setState(() {
      _isLoading = true;
    });
    List<Song> songs = [];
    final data = await ServiceManager.songService.getAllSongs();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      list.forEach((song) {
        //
        Song newSong = Song.fromJson(song as Map<String, dynamic>);
        songs.add(newSong);
        //
      });
    } else {
      print(data['message']);
    }

    setState(() {
      _searchSongs = songs;
      _songs = songs;
      _isLoading = false;
    });
  }

  //#######################################
  //Update ListView Content When Searching has Finished
  //#######################################
  void updateListViewContentForSearching(List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _songs = [];
      } else if (isaSsign) {
        _songs = newData.map((i) => i as Song).toList();
      } else {
        loadData();
      }
    });
  }

  Future<bool> deleteSong(Song song) async {
    print("called");
    final data = await ServiceManager.songService.deleteSongById(song.id);
    if (data['message'] == "OK") {
      print("${song.id} was Deleted");
    } else {
      print("MESSAGE: ${data["message"]}");
    }
    return true;
  }

  Future<void> onTapDelete(Song song) async {
    String constrainString = "Linking Artists: ";
    List<Artist> artists = song.artists != null ? song.artists! : [];
    if (song.artists!.isEmpty) {
      constrainString += "NONE";
    }
    for (var artist in artists) {
      constrainString += "\n - ${artist.name} ";
    }

    final result = await showGeneralDialog<int>(
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return WarningDeleteDialog(
          title: "Do you want to delete this Song?",
          rss: rss,
          object: song,
          isConstrained: artists.isEmpty ? false : true,
          confirmEvent: deleteSong,
          constrainedListWidget: Container(
            child: Text(
              constrainString,
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                fontSize: rss.u * 7,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
        );
      },
    );
    if (result != null) {
      if (result == 1) {
        print("Rebuild de load danh sach moi");
        await loadData();
        setState(() {});
      }
    }
  }

  Future<void> onTapEdit(Song song) async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SongFeatureDialog(
          rss: rss,
          // title: "Song",
          // context: context,
          song: song,
          mode: 1,
        );
      },
    );
    if (result != null) {
      if (result != 0) {
        print("Rebuild de load danh sach moi");

        setState(() {
          loadData();
        });
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  Future<void> onTapDetail(Song song) async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SongFeatureDialog(
          rss: rss,
          song: song,
          mode: 2,
        );
      },
    );
    if (result != null) {
      if (result != 0) {
        print("Rebuild de load danh sach moi");

        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  Future<void> onTapCreateButton() async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic, // Customize the animation curve as needed
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SongFeatureDialog(
          rss: rss,
          //context: context,
          mode: 0,
          //loadData: loadData,
        );
      },
    );
    if (result != null) {
      if (result == 1) {
        print("Rebuild de load danh sach moi");
        await loadData(); // Reload data after deletion
        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  @override
  void initState() {
    rss = widget.rss;
    super.initState();
    loadData();
  }

  //############################
  // Main build
  //###########################
  @override
  Widget build(BuildContext context) {
    return ContentFrame(
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
                      _buildCreateButton(rss),
                      Expanded(
                        child: Column(
                          children: [
                            // Header Row
                            _buildTableHeaderRow(rss: rss, headers: headers),
                            // Content Rows
                            Expanded(
                              child: _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      itemCount: _songs.length,
                                      itemBuilder: (context, index) {
                                        return _buildTableContentRow(
                                          rss: rss,
                                          song: _songs[index],
                                          onTapDelete: onTapDelete,
                                          onTapEdit: onTapEdit,
                                          onTapDetail: onTapDetail,
                                          bgColor: index % 2 == 0 ? const Color(0xc8eceff3) : null,
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
                  padding: EdgeInsets.only(
                    left: rss.u * 100,
                    right: rss.u * 100,
                  ),
                  child: SuggestionSearchBar(
                    controller: searchController,
                    data: _searchSongs,
                    searchExecutionEvent: updateListViewContentForSearching,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(RSS rss) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: rss.u * 3, top: rss.u * 5),
        child: PushdownGesturedetector(
          elevation: rss.u * 1,
          onTapDownElevation: rss.u * 0.2,
          radius: rss.u * 8,
          onTap: onTapCreateButton,
          child: Text(
            "Create New",
            style: GoogleFonts.roboto(
              fontSize: rss.u * 7,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  //##################################
  //_build Header And Content Row
  //#################################
  List<String> headers = Song.getFields()..add("Actions");

  Widget _buildTableHeaderRow({required RSS rss, required List<String> headers, Color? bgColor}) {
    return Container(
      padding: EdgeInsets.only(
        top: rss.u * 2,
        bottom: rss.u * 2,
      ),
      child: Row(
        children: headers.map((header) {
          int flex = 0;
          switch (header) {
            case "id":
              flex = 1;
              break;
            case "picture":
              flex = 3;
              break;
            case "name":
              flex = 6;
              break;
            case "LC":
              flex = 2;
              break;
            default:
              flex = 5;
              break;
          }
          return Expanded(
            flex: flex,
            child: Container(
              padding: EdgeInsets.all(rss.u * 2),
              alignment: header == "Actions" || header == "picture" ? Alignment.center : Alignment.centerLeft,
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
    Future<void> Function(Song)? onTapDelete,
    Future<void> Function(Song)? onTapEdit,
    Future<void> Function(Song)? onTapDetail,
    Color? bgColor = Colors.transparent,
  }) {
    TextStyle styleContentRow = GoogleFonts.roboto(
      fontSize: rss.u * 7,
      fontWeight: FontWeight.w700,
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
                flex: 1,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.id.toString(),
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
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
                flex: 5,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.artists?.map((artist) => artist.name).join(', ') ?? "",
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.listenCount.toString(),
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ActionsButtonRow(
                  onTapDelete: onTapDelete != null ? (object) => onTapDelete!(object as Song) : null,
                  onTapEdit: onTapEdit != null ? (object) => onTapEdit!(object as Song) : null,
                  onTapDetail: onTapDetail != null ? (object) => onTapDetail!(object as Song) : null,
                  object: song,
                  paddingAllRow: EdgeInsets.all(rss.u * 2),
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
