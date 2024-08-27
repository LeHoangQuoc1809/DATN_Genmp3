import 'package:app/models/topic.dart';
import 'package:app/views/components/PushDown_GestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/rss.dart';
import '../../../modelViews/modelViews_mng.dart';
import '../../../models/genre.dart';
import '../../components/content_frame.dart';

class MultipleAdd extends StatefulWidget {
  List<dynamic> data;

  String base64String;

  String type;

  MultipleAdd(
      {super.key,
      required this.data,
      required this.base64String,
      required this.type});

  @override
  State<MultipleAdd> createState() => _MultipleAddState();
}

class _MultipleAddState extends State<MultipleAdd> {
  RSS rss = RSS();

  List<String> _selectedItems = [];

  List<dynamic> fakeData = [];

  List<Map<String, dynamic>> fetchData = [];

  Future loadData() async {
    List<Map<String, dynamic>> data = [];
    if (widget.type == "topic") {
      print("widget.base64String:${widget.base64String}");
      data = await ModelviewsManager.songModelviews
          .predictTopic(widget.base64String);
    } else if (widget.type == "genre") {
      data = await ModelviewsManager.songModelviews
          .predictGenre(widget.base64String);
    }

    setState(() {
      fetchData = data;

      print("OK 1");
      if (widget.data.isNotEmpty) {
        print("OK 2");
        _selectedItems = List.from(widget.data);
        print("_selectedItems:${_selectedItems}");
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
    rss.init(context);
    return AlertDialog(
      title: Container(
        width: double.infinity,
        child: Text(
          "Add ${widget.type.toUpperCase()}",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: rss.u * 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF48BB78),
          ),
        ),
      ),
      content: ContentFrame(
        child: Container(
          height: rss.u * 120,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: rss.u * 200,
                  padding: EdgeInsets.fromLTRB(
                      rss.u * 2, rss.u * 10, rss.u * 2, rss.u * 5),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: rss.u * 5,
                      runSpacing: rss.u * 5,
                      children: fetchData.map((item) {
                        String name = item.keys.first;
                        String probability = item.values.first + "%";
                        bool isSelected = _selectedItems.contains(name);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedItems.remove(name);
                              } else {
                                _selectedItems.add(name);
                              }
                            });
                          },
                          child: Container(
                            width: rss.u * 95,
                            height: rss.u * 30,
                            padding: EdgeInsets.only(
                              left: rss.u * 5,
                              right: rss.u * 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(rss.u * 20),
                              color: isSelected
                                  ? Colors.blue
                                  : const Color(0xFF87CEFA),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: rss.u * 20,
                                  height: rss.u * 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius:
                                        BorderRadius.circular(rss.u * 30),
                                  ),
                                  child: Text(
                                    probability,
                                    style: GoogleFonts.roboto(
                                      fontSize: rss.u * 8,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: rss.u * 5,
                                ),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: GoogleFonts.roboto(
                                      fontSize: rss.u * 8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              Navigator.of(context).pop(null);
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
              print("_selectedItems:${_selectedItems}");
              Navigator.of(context).pop(_selectedItems);
            },
          ),
        ),
      ],
    );
  }
}
