import 'package:app/configs/rss.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestionSearchBar extends StatefulWidget {
  TextEditingController controller;

  List<dynamic> data;

  Function(List<dynamic>, bool) searchExecutionEvent;

  bool isSubmittEvent;

  SuggestionSearchBar({
    super.key,
    required this.controller,
    required this.data,
    required this.searchExecutionEvent,
    this.isSubmittEvent = true,
  });

  @override
  State<SuggestionSearchBar> createState() => _SuggestionSearchBarState();
}

class _SuggestionSearchBarState extends State<SuggestionSearchBar> {
  RSS rss = RSS();

  List<dynamic> suggestions = [];

  List<dynamic> returnList = [];

  final FocusNode focusNode = FocusNode();

  bool isShowSuggestions = false;

  @override
  Widget build(BuildContext context) {
    rss.init(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: rss.u * 8),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: rss.u * 2,
                  offset: Offset(0, rss.u * 1),
                ),
              ],
              borderRadius: BorderRadius.circular(rss.u * 10),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              style: GoogleFonts.roboto(
                fontSize: rss.u * 8,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF000000),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: rss.u * 2,
                  horizontal: rss.u * 5,
                ),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(rss.u * 10),
                ),
                fillColor: const Color(0xFFFFFFFF),
                filled: true,
                suffixIcon: widget.controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: rss.u * 8,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          widget.searchExecutionEvent([], false);
                          setState(() {
                            suggestions = [];
                            isShowSuggestions = false;
                          });
                        },
                      ),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  setState(() {
                    suggestions = updateSuggestions(text);
                    isShowSuggestions = true;
                  });
                } else {
                  setState(() {
                    suggestions = [];
                    isShowSuggestions = false;
                  });
                }
              },
              onSubmitted: (String text) {
                if (widget.isSubmittEvent) {
                  print(suggestions);
                  widget.searchExecutionEvent(suggestions, true);
                }
                setState(() {
                  isShowSuggestions = false;
                });
              },
            ),
          ),
        ),
        if (isShowSuggestions) _buildSuggestionsList(rss),
      ],
    );
  }

  List<dynamic> updateSuggestions(String query) {
    List<dynamic> _suggestions = [];
    if (query.isNotEmpty) {
      List<dynamic> filteredSuggestions = widget.data
          .where((object) =>
              object.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _suggestions = filteredSuggestions;
    }
    return _suggestions;
  }

  Widget _buildSuggestionsList(RSS rss) {
    return Positioned(
      top: rss.u * 25,
      left: rss.u * 5,
      right: rss.u * 5,
      child: Material(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.fromLTRB(rss.u * 2, 0, rss.u * 2, 0),
          decoration: BoxDecoration(
            color: const Color(0xfffcf8ff),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, rss.u * 1),
                blurRadius: rss.u * 1,
              ),
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
                    widget.controller.text = suggestions[index].name;
                    focusNode.unfocus();
                    widget.searchExecutionEvent([suggestions[index]], true);
                    setState(() {
                      suggestions = updateSuggestions('');
                      isShowSuggestions = false;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
