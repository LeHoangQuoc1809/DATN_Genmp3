import 'dart:math';
import 'dart:ui';
import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/views/pages/search/fake_search_bar.dart';
import 'package:client/views/pages/search/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/genre_model.dart';
import '../../../models/song_model.dart';
import '../../../models/topic_model.dart';
import '../../components/components.dart';
import 'loading_tag_display.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchMainPage extends StatefulWidget {
  int isSearchPage;

  SearchMainPage({super.key, required this.isSearchPage});

  @override
  State<SearchMainPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchMainPage> {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
    Colors.amber,
    Colors.redAccent,
    Colors.purpleAccent,
  ];

  late Future<void> _fetchDataState;

  final searchController = TextEditingController(text: '');

  //bool _isSearching = false;

  List<Genre> _genres = [];

  List<Topic> _topics = [];

  Future fetchData() async {
    print("fetchData Runnning");
    //get
    try {
      List<Topic> topicsData = await ModelviewsManager.topicModelviews.getAllTopics();

      List<Genre> genresData = await ModelviewsManager.genreModelview.getAllGenres();

      print("Call Api Done");

      setState(() {
        _topics = topicsData;
        _genres = genresData;
      });
    } catch (e) {
      print("Error when fetching data:$e");
    }

    print("fetchData Done");
  }

  void _showSearchBar() {
    print("_showSearchBar called with: ${widget.isSearchPage}");
    setState(() {
      if (widget.isSearchPage == 1) {
        widget.isSearchPage = 2;
      } else {
        widget.isSearchPage = 1;
      }
    });
  }

  void _handleSearchTagTap({
    required dynamic object,
  }) {
    if (object is Genre) {
      print("Genre: ${object.name}");
    } else if (object is Topic) {
      print("Topic: ${object.name}");
    } else {
      print("ELSE: $object");
    }
  }

  @override
  void initState() {
    print("initState Search Page");
    super.initState();
    _fetchDataState = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Search Page");
    if (widget.isSearchPage == 1) {
      return GestureDetector(
        onTap: () {
          onDismissKeyboard(context);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
            28.w,
            0,
            28.w,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: (22.h + 18.h + 13.h),
              ),
              Container(
                height: 48.h,
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
                        "Search",
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
              SizedBox(
                height: 21.h,
              ),
              FakeSearchBar(
                onTap: _showSearchBar,
              ),
              SizedBox(
                height: 30.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.fromLTRB(
                          12.w,
                          5.h,
                          12.w,
                          20.h,
                        ),
                        child: Text(
                          "Browse All",
                          style: TextStyle(
                            fontFamily: 'CenturyGothicBold',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      Container(
                        child: FutureBuilder<void>(
                          future: _fetchDataState,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return LoadingTagDisplay();
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (_genres.isNotEmpty) {
                              double boxWidth = 175.w;

                              double boxHeight = 120.h;
                              //Create a List of Tag Widgets
                              List<Widget> tagWidgets = [];
                              // Create a list of genre widgets
                              List<Widget> genreWidgets = _genres.map((genre) {
                                String idStr = genre.id.toString();
                                int colorId = int.parse(idStr[idStr.length - 1]);
                                final backgroundColor = colors[colorId];

                                return SearchTag(
                                  height: boxHeight,
                                  width: boxWidth,
                                  title: genre.name,
                                  subTitle: genre.description!,
                                  bgColor: backgroundColor,
                                  onTap: () {
                                    _handleSearchTagTap(object: genre);
                                  },
                                );
                              }).toList();

                              List<Widget> topicWidgets = _topics.map((topic) {
                                String idStr = topic.id.toString();
                                int colorId = int.parse(idStr[idStr.length - 1]);
                                final backgroundColor = colors[colorId];

                                return SearchTag(
                                  height: boxHeight,
                                  width: boxWidth,
                                  title: topic.name,
                                  subTitle: topic.description!,
                                  bgColor: backgroundColor,
                                  onTap: () {
                                    _handleSearchTagTap(object: topic);
                                  },
                                );
                              }).toList();

                              tagWidgets.insertAll(0, genreWidgets);
                              tagWidgets.insertAll(0, topicWidgets);
                              tagWidgets.insert(
                                0,
                                SearchTag(
                                  height: boxHeight,
                                  width: boxWidth,
                                  title: "New Release",
                                  subTitle: "New Release",
                                  bgColor: Colors.blueAccent,
                                  onTap: () {
                                    _handleSearchTagTap(object: "New Release");
                                  },
                                ),
                              );
                              tagWidgets.insert(
                                1,
                                SearchTag(
                                  height: boxHeight,
                                  width: boxWidth,
                                  title: "Made For You",
                                  subTitle: "Made For You",
                                  bgColor: Colors.teal,
                                  onTap: () {
                                    _handleSearchTagTap(object: "Made For You");
                                  },
                                ),
                              );
                              tagWidgets.insert(
                                1,
                                SearchTag(
                                  height: boxHeight,
                                  width: boxWidth,
                                  title: "Chart",
                                  subTitle: "Chart",
                                  bgColor: Colors.purple,
                                  onTap: () {
                                    _handleSearchTagTap(object: "Chart");
                                  },
                                ),
                              );

                              return Wrap(
                                spacing: 12.w,
                                runSpacing: 15.h,
                                alignment: WrapAlignment.spaceBetween,
                                children: tagWidgets,
                              );
                            } else {
                              return Center(
                                child: Text(
                                  'No data',
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicBold',
                                    color: Colors.white,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 130.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SearchPage(onBackTap: _showSearchBar);
    }
  }
}

class SearchTag extends StatefulWidget {
  final String title;
  final String subTitle;
  final double width;
  final double height;
  final Color bgColor;
  final double titleSize;
  final double subTitleSize;
  final VoidCallback onTap;

  SearchTag({
    super.key,
    this.title = "",
    this.subTitle = "",
    required this.width,
    required this.height,
    this.bgColor = Colors.grey,
    this.titleSize = 16,
    this.subTitleSize = 7,
    required this.onTap,
  });

  @override
  _SearchTagState createState() => _SearchTagState();
}

class _SearchTagState extends State<SearchTag> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = true;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            _isPressed = false;
          });
          print("onTap");
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(_isPressed ? 2.sp : 0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.r),
              topRight: Radius.circular(5.r),
              bottomLeft: Radius.circular(5.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140.w,
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          color: Colors.white,
                          fontSize: widget.titleSize.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      width: 100.w,
                      child: Text(
                        widget.subTitle,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          color: Colors.white,
                          fontSize: widget.subTitleSize.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(
                    widget.width / 2.5,
                    widget.height / 1.5,
                  ),
                  painter: TrianglePainter(
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height) // Điểm cuối của đoạn cong
      ..arcToPoint(
        Offset(size.width, size.height),
        clockwise: false, // Hướng vẽ (đi ngược chiều kim đồng hồ)
      ) // Điểm bắt đầu của đoạn cong
      ..close(); // Đóng path

    // Tạo một path hình tròn hoặc đường cong cho màu nền
    final backgroundPath = Path()
      ..moveTo(0, size.height) // Điểm bắt đầu của màu nền
      ..lineTo(size.width, 0) // Điểm cuối của đoạn cong
      ..lineTo(size.width, size.height) // Điểm cuối của đoạn cong
      ..arcToPoint(
        Offset(size.width, size.height),
        clockwise: false,
      )
      ..close(); // Đóng path

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    canvas.drawPath(backgroundPath, paint);
    canvas.drawPath(path, Paint()..color = color);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
