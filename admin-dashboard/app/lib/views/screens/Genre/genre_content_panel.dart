import 'package:app/models/genre.dart';
import 'package:app/views/screens/Genre/genre_feature_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/rss.dart';
import '../../../modelViews/modelViews_mng.dart';
import '../../../models/song.dart';
import '../../../services/service_mng.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/actions_button_row.dart';
import '../../components/content_frame.dart';
import '../../components/suggestion_search_bar.dart';
import '../../components/warning_delete_dialog.dart';

class GenreContentPanel extends StatefulWidget {
  RSS rss;

  GenreContentPanel({super.key, required this.rss});

  @override
  State<GenreContentPanel> createState() => _GenreContentPanelState();
}

class _GenreContentPanelState extends State<GenreContentPanel> {
  List<Genre> _genres = [];

  RSS rss = RSS();

  bool _isLoading = true; // Add this line

  TextEditingController searchController = TextEditingController();

  Future loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Genre> genres = await ModelviewsManager.genreModelview.getAllGenres();
      setState(() {
        _genres = genres;
      });
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void updateListViewContentForSearching(List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _genres = [];
      } else if (isaSsign) {
        _genres = newData.map((i) => i as Genre).toList();
      } else {
        loadData();
      }
    });
  }

  //###############################################
  //  onTap
  //##############################################
  Future<bool> deleteGenre(Genre genre) async {
    bool state = await ModelviewsManager.genreModelview.deleteGenreById(id: genre.id);
    return state;
  }

  Future<void> onTapDelete(Genre genre) async {
    String constrainString = "Linking Songs: ";
    List<Song> songs = await ModelviewsManager.genreModelview.getSongsByGenreId(genre.id);
    if (songs.isEmpty) {
      constrainString += "NONE";
    }
    for (var song in songs) {
      constrainString += "\n - ${song.name} ";
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
          title: songs.isEmpty ? "Do you want to delete this Genre?" : "This Genre cannot be deleted!",
          rss: rss,
          object: genre,
          isConstrained: songs.isEmpty ? false : true,
          confirmEvent: deleteGenre,
          canBeDeleted: songs.isEmpty,
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

  Future<void> onTapEdit(Genre genre) async {
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
        return GenreFeatureDialog(
          rss: rss,
          genre: genre,
          mode: 1,
        );
      },
    );
    if (result != null) {
      if (result != 0) {
        print("Rebuild de load danh sach moi");
        await loadData();
        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  Future<void> onTapDetail(Genre genre) async {
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
        return GenreFeatureDialog(
          rss: rss,
          genre: genre,
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
        return GenreFeatureDialog(
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
                                      itemCount: _genres.length,
                                      itemBuilder: (context, index) {
                                        return _buildTableContentRow(
                                          rss: rss,
                                          genre: _genres[index],
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
                    data: _genres,
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
  List<String> headers = Genre.getFields()..add("Actions");

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
            case "name":
              flex = 4;
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
    required Genre genre,
    Future<void> Function(Genre)? onTapDelete,
    Future<void> Function(Genre)? onTapEdit,
    Future<void> Function(Genre)? onTapDetail,
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
              Expanded(
                flex: 1,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    genre.id.toString(),
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    genre.name,
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
                    genre.description != null ? genre.description.toString() : "",
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ActionsButtonRow(
                  onTapDelete: onTapDelete != null ? (object) => onTapDelete!(object as Genre) : null,
                  onTapEdit: onTapEdit != null ? (object) => onTapEdit!(object as Genre) : null,
                  onTapDetail: onTapDetail != null ? (object) => onTapDetail!(object as Genre) : null,
                  object: genre,
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
