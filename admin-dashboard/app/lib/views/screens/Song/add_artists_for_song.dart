import 'package:app/configs/rss.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/artist.dart';
import '../../../services/service_mng.dart';

class AddArtistsForSong extends StatefulWidget {
  const AddArtistsForSong({
    Key? key,
    required this.artists,
  }) : super(key: key);
  final List<Artist> artists;

  @override
  State<AddArtistsForSong> createState() => _AddArtistsForSongState();
}

class _AddArtistsForSongState extends State<AddArtistsForSong> {
  List<dynamic> suggestions = [];
  List<Artist> _allArtists = [];
  final FocusNode focusNode = FocusNode();
  bool showSuggestions = false;
  TextEditingController searchArtistsController = TextEditingController();
  List<Artist> _selectedArtists = [];

  Future<void> loadArtists() async {
    List<Artist> artists = [];
    final data = await ServiceManager.artistService.getAllArtists();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      artists = list.map((i) => Artist.fromJson(i)).toList();
    } else {
      print(data['message']);
    }

    for (var artist in _selectedArtists) {
      if (artists.contains(artist)) {
        artists.remove(artist);
      }
    }
    setState(() {
      _allArtists = artists;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedArtists = widget.artists.map((e) => e).toList();
    loadArtists();
  }

  List<Artist> updateSuggestions(String query) {
    List<Artist> suggestions = [];
    if (query.isEmpty) {
      suggestions = [];
    } else {
      List<Artist> filteredSuggestions = _allArtists
          .where((artist) =>
              artist.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      suggestions = filteredSuggestions;
    }
    print(suggestions);
    return suggestions;
  }

  void confirmEvent(BuildContext context, List<Artist> selectedArtists) {
    Navigator.of(context).pop(selectedArtists);
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
      content: Container(
        height: rss.u * 80,
        width: rss.u * 150,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: rss.u * 8),
                  child: Container(
                    width: rss.u * 200,
                    height: rss.u * 18,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: rss.u * 2,
                          offset: Offset(
                              0, rss.u * 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(rss.u * 10),
                    ),
                    child: TextField(
                      controller: searchArtistsController,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.search,
                      style: GoogleFonts.roboto(
                          fontSize: rss.u * 8,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF000000)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: rss.u * 2, horizontal: rss.u * 5),
                        // Adjust padding to change the height
                        hintText: "Search",
                        border: OutlineInputBorder(
                          // Changed to OutlineInputBorder for borderRadius
                          borderSide: BorderSide.none, // No visible border
                          borderRadius: BorderRadius.circular(rss.u *
                              10), // Matching the Container's borderRadius
                        ),
                        fillColor: const Color(0xFFFFFFFF),
                        //const Color(0xFFDEE1E5),
                        filled: true,
                        // Enable filling the color
                        suffixIcon: searchArtistsController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: rss.u * 8,
                                ),
                                onPressed: () {
                                  searchArtistsController.clear();
                                  // Call setState to update the TextField's appearance
                                  setState(() {
                                    suggestions = [];
                                  });
                                },
                              ),
                      ),
                      onChanged: (text) {
                        if (text.isNotEmpty) {
                          var updatedSuggestions = updateSuggestions(text);
                          setState(() {
                            suggestions = updatedSuggestions;
                            showSuggestions = suggestions
                                .isNotEmpty; // Only show suggestions if
                          });
                        } else {
                          setState(() {
                            suggestions = [];
                            showSuggestions = false;
                          });
                        }
                      },
                      onSubmitted: (String text) {
                        print("Search for: $text");
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: rss.u * 5,
                ),
                Container(
                  width: double.infinity,
                  height: rss.u * 45,
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: rss.u * 5,
                      // Khoảng cách giữa các widget theo chiều ngang
                      runSpacing: rss.u * 5,
                      // Khoảng cách giữa các widget theo chiều dọc
                      children: _selectedArtists.map((artist) {
                        return Container(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: rss.u * 15,
                                    height: rss.u * 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(Artist.getUrlImg(
                                            artist.picture, artist.id)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedArtists.remove(artist);
                                            _allArtists.add(artist);
                                          });
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.x,
                                          size: rss.u * 5,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: rss.u * 2,
                              ),
                              Text(
                                artist.name,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: rss.u * 4,
                                  color: const Color(0xFF2D3748),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            if (showSuggestions && suggestions.isNotEmpty)
              Positioned(
                top: rss.u * 25,
                // Adjust as needed based on your UI layout
                left: rss.u * 5,
                right: rss.u * 5,
                bottom: rss.u * 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(rss.u * 2, 0, rss.u * 2, 0),
                  decoration: BoxDecoration(
                    color: const Color(0xfffcf8ff),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, rss.u * 1),
                        blurRadius: rss.u * 1,
                      )
                    ],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(rss.u * 2),
                    ),
                  ),
                  child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(
                          rss.u * 5,
                          rss.u * 2,
                          rss.u * 5,
                          rss.u * 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: rss.u * 0.1,
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          child: Text(
                            suggestions[index].name,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: rss.u * 7,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          onTap: () {
                            searchArtistsController.clear();
                            focusNode.unfocus();
                            setState(() {
                              Artist temp = suggestions[index];
                              //update icons list
                              _selectedArtists.add(temp);
                              _allArtists.remove(temp);

                              //
                              suggestions = [];
                              showSuggestions =
                                  false; // Hide suggestions after selection
                            });
                          },
                        ),
                      );
                    },
                  ),
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
              Navigator.of(context).pop(widget.artists);
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
                // Specifies the shape of the button's border
                borderRadius: BorderRadius.circular(rss.u * 8),
              ),
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.roboto(
                fontSize: rss.u * 6,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFFFFFF),
              ),
            ),
            onPressed: () {
              confirmEvent(context, _selectedArtists);
            },
          ),
        ),
      ],
    );
  }
}
