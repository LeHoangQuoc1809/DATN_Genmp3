import 'package:app/configs/rss.dart';
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

class AddArtistForAlbum extends StatefulWidget {
  const AddArtistForAlbum({
    Key? key,
  }) : super(key: key);

  @override
  State<AddArtistForAlbum> createState() => _AddArtistForAlbumState();
}

class _AddArtistForAlbumState extends State<AddArtistForAlbum> {
  List<dynamic> suggestions = [];
  List<Artist> _artists = [];
  final FocusNode focusNode = FocusNode();
  bool showSuggestions = false;
  TextEditingController searchArtistsController = TextEditingController();

  Future loadData() async {
    List<Artist> artists =
        await ModelviewsManager.artistModelview.getAllArtists();

    setState(() {
      _artists = artists;
    });
  }

  void updateListViewContentForSearching(List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _artists = [];
      } else if (isaSsign) {
        _artists = newData.map((i) => i as Artist).toList();
      } else {
        loadData();
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
          "Add Artists",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: rss.u * 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF48BB78),
          ),
        ),
      ),
      content: ContentFrame(
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
                              _buildTableHeaderRow(rss: rss, headers: headers),
                              // Content Rows
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _artists.length,
                                  itemBuilder: (context, index) {
                                    return _buildTableContentRow(
                                      rss: rss,
                                      artist: _artists[index],
                                      bgColor: index % 2 == 0
                                          ? const Color(0xc8eceff3)
                                          : null,
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
                      controller: searchArtistsController,
                      data: _artists,
                      searchExecutionEvent: updateListViewContentForSearching,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      ],
    );
  }

  List<String> headers = ["name", "picture", "Actions"];

  Widget _buildTableHeaderRow(
      {required RSS rss, required List<String> headers, Color? bgColor}) {
    return Container(
      padding: EdgeInsets.only(
        top: rss.u * 2,
        bottom: rss.u * 2,
      ),
      child: Row(
        children: headers.map((header) {
          int flex = 5;
          return Expanded(
            flex: flex,
            child: Container(
              padding: EdgeInsets.all(rss.u * 2),
              alignment: header == "Actions" || header == "picture"
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
    required Artist artist,
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
                flex: 5,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    artist.name,
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              CircelPictureComponent(
                rss: rss,
                flex: 5,
                src: Artist.getUrlImg(artist.picture, artist.id),
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    width: rss.u * 20,
                    child: PushdownGesturedetector(
                      elevation: rss.u * 1,
                      onTapDownElevation: rss.u * 2,
                      radius: rss.u * 10,
                      onTap: () {
                        Navigator.of(context).pop(artist);
                      },
                      child: Text(
                        "Choose",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: rss.u * 6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
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
