import 'dart:async';
import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/rss.dart';
import '../../../models/album.dart';
import '../../../models/artist.dart';
import '../../../models/song.dart';
import '../../../services/service_mng.dart';

class ChooseAlbum extends StatefulWidget {
  List<Artist> artists;

  ChooseAlbum({super.key, required this.artists});

  @override
  State<ChooseAlbum> createState() => _ChooseAlbumState();
}

class _ChooseAlbumState extends State<ChooseAlbum> {
  List<Map<Artist, List<Album>>> _artistAlbumsData = [];
  List<Artist> _artists = [];
  List<dynamic> _expandedStates = [];
  List<Song> _songs = [];

  void loadAllAlbumsFromArtists() async {
    print("=========================Loading=========================");
    //get albums from artists
    List<Map<Artist, List<Album>>> artistAlbumsData = [];
    List<dynamic> expandedStates = [];
    for (var artist in _artists) {
      List<Album> albumsOfArtist =
          await ModelviewsManager.albumModelview.getAlbumsByArtistId(artist.id);
      for (var alb in albumsOfArtist) {
        expandedStates.add({"album_id": alb.id, "bool": false});
      }
      artistAlbumsData.add({artist: albumsOfArtist});
    }
    setState(() {
      _expandedStates = expandedStates;
      _artistAlbumsData = artistAlbumsData;
    });
  }

  void onTapShowSongs(int index, int album_id) async {
    List<Song> songs = [];
    final data = await ServiceManager.songService.getSongsByAlbumId(album_id);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    setState(() {
      _songs = songs;
      for (int i = 0; i < _expandedStates.length; i++) {
        if (_expandedStates[i]["album_id"] != album_id) {
          _expandedStates[i]["bool"] = false;
        } else {
          _expandedStates[i]["bool"] = !_expandedStates[i]["bool"];
        }
      }
    });
  }

  @override
  void initState() {
    _artists = widget.artists;
    // TODO: implement initState
    super.initState();
    loadAllAlbumsFromArtists();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return AlertDialog(
      title: Container(
        width: double.infinity,
        child: Text(
          "Choose Album",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: rss.u * 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF48BB78),
          ),
        ),
      ),
      content: Container(
        height: rss.u * 80, // Adjust height as needed
        width: rss.u * 150, // Adjust width as needed
        child: _artistAlbumsData.isEmpty
            ? Center(
                child: Text(
                  "No albums found.",
                  style: GoogleFonts.roboto(
                    fontSize: rss.u * 14,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _artistAlbumsData.length,
                itemBuilder: (context, index) {
                  var entry = _artistAlbumsData[index];
                  return entry.entries.map((artistAlbums) {
                    var artist = artistAlbums.key;
                    var albums = artistAlbums.value;
                    bool isEmpty = albums.isNotEmpty;
                    return Container(
                      margin: EdgeInsets.only(bottom: rss.u * 10),
                      // Add some spacing between items
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist.name,
                            style: GoogleFonts.roboto(
                              fontSize: rss.u * 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          isEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: albums.length,
                                  itemBuilder: (context, albumIndex) {
                                    Map<String, dynamic>? foundState =
                                        _expandedStates.firstWhere(
                                      (element) =>
                                          element["album_id"] ==
                                          albums[albumIndex].id,
                                      orElse: () => null,
                                    );
                                    print("foundState:${foundState}");
                                    return GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: rss.u * 2),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              width: rss.u * 0.6,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 9,
                                                  child: Text(
                                                    albums[albumIndex].name,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: rss.u * 8,
                                                      color: const Color(
                                                          0xFF2D3748),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: rss.u * 10,
                                                    child:
                                                        BackgroundAnimationGestureDetector(
                                                      duration: const Duration(
                                                        milliseconds: 100,
                                                      ),
                                                      onTap: () {
                                                        onTapShowSongs(
                                                          albumIndex,
                                                          albums[albumIndex].id,
                                                        );

                                                        //Show list of Songs below in here
                                                      },
                                                      bgColorX:
                                                          Colors.transparent,
                                                      bgColorY: const Color(
                                                        0xB610FF00,
                                                      ),
                                                      bgColorHover: const Color(
                                                        0xB64C674C,
                                                      ),
                                                      radius: rss.u * 20,
                                                      child: FaIcon(
                                                        !foundState!["bool"]
                                                            ? FontAwesomeIcons
                                                                .caretDown
                                                            : FontAwesomeIcons
                                                                .caretUp,
                                                        size: rss.u * 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: foundState!["bool"],
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  rss.u * 5,
                                                ),
                                                height: _songs.isNotEmpty
                                                    ? rss.u * 20 * _songs.length
                                                    : rss.u * 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    rss.u * 5,
                                                  ),
                                                  border: Border.all(
                                                    width: rss.u * 0.5,
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                child: _songs.isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount:
                                                            _songs.length,
                                                        itemBuilder: (context,
                                                            songIndex) {
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                top: BorderSide(
                                                                  width: rss.u *
                                                                      0.5,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              _songs[songIndex]
                                                                  .name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontSize:
                                                                    rss.u * 5,
                                                                color:
                                                                    const Color(
                                                                  0xFF2D3748,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                    : Text(
                                                        "None",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: rss.u * 6,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: const Color(
                                                              0xFF000000),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(albums[albumIndex]); // Pass
                                      },
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    );
                  }).toList()[0];
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: Text(
            "Cancel",
            style: GoogleFonts.roboto(
              fontSize: rss.u * 10,
              color: const Color(0xFF48BB78),
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundAnimationGestureDetector extends StatefulWidget {
  final Color bgColorX;
  final Color bgColorY;
  final Color bgColorHover;
  final VoidCallback onTap;
  final Duration duration;
  final Widget child;
  final double radius;

  BackgroundAnimationGestureDetector({
    super.key,
    this.bgColorX = Colors.transparent,
    this.bgColorY = Colors.grey,
    required this.onTap,
    this.duration = const Duration(milliseconds: 100),
    required this.child,
    this.radius = 0,
    this.bgColorHover = Colors.transparent,
  });

  @override
  State<BackgroundAnimationGestureDetector> createState() =>
      _BackgroundAnimationGestureDetectorState();
}

class _BackgroundAnimationGestureDetectorState
    extends State<BackgroundAnimationGestureDetector> {
  late Color _currentBackgroundColor;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _currentBackgroundColor = widget.bgColorX;
  }

  void _changeColor() {
    if (!_isAnimating) {
      setState(() {
        _currentBackgroundColor = widget.bgColorY;
        _isAnimating = true;
      });

      Timer(widget.duration, () {
        setState(() {
          _currentBackgroundColor = widget.bgColorHover;
          _isAnimating = false;
        });
      });
    }
  }

  void _onHover(bool isHovering) {
    print("_onHover:$isHovering");
    setState(() {
      _currentBackgroundColor =
          isHovering ? widget.bgColorHover : widget.bgColorX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          _changeColor();
          widget.onTap();
        },
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: _currentBackgroundColor,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
