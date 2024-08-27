import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../../modelViews/modelViews_mng.dart';
import '../../models/genre_model.dart';
import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../services/service_mng.dart';
import '../components/padding_animation_widget.dart';

class TopicGenrePage extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int id, String name, String type, String start) onTapItem;

  const TopicGenrePage({
    super.key,
    required this.onBack,
    required this.onTapItem,
  });

  @override
  State<TopicGenrePage> createState() => _TopicGenrePageState();
}

class _TopicGenrePageState extends State<TopicGenrePage> {
  final ScrollController _scrollController = ScrollController();

  // final PageController _pageController = PageController();
  late PageController _pageController;
  bool isPageViewBuilt = false;
  Timer? _pageChangeTimer;
  bool _isLoading = true;
  bool isSwipingLeft = false;
  List<Genre> allGenres = [];
  List<Topic> allTopics = [];
  List<dynamic> genresAndTopics = [];
  int currentlyPage = 0;
  String _typeForGenreTopic = '';
  String _startForGenreTopic = '';
  int _idForGenreTopic = 0;
  String _nameForGenreTopic = '';
  List<String> photo = [
    '${ServiceManager.imgUrl}song/1_1_Chua-Chau-Khai-Phong-Truc-Anh-Babe.png',
    '${ServiceManager.imgUrl}song/9_67_Khach-Sang-Do-Chau-Khai-Phong.png',
    '${ServiceManager.imgUrl}song/10_79_Ao-Cu-Tinh-Moi-Chau-Khai-Phong.png',
  ];
  List<List<Color>> colorsList = [
    [
      Colors.blue.shade200,
      Colors.blue.shade300,
      Colors.blue.shade400,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.blue.shade700,
      Colors.blue.shade800,
      Colors.blue.shade900,
    ],
    [
      Colors.purple.shade200,
      Colors.purple.shade300,
      Colors.purple.shade400,
      Colors.purple.shade500,
      Colors.purple.shade600,
      Colors.purple.shade700,
      Colors.purple.shade800,
      Colors.purple.shade900,
    ],
    [
      Colors.redAccent.shade100,
      Colors.redAccent.shade200,
      Colors.redAccent.shade400,
      Colors.redAccent.shade700,
    ],
    [
      Colors.green.shade200,
      Colors.green.shade300,
      Colors.green.shade400,
      Colors.green.shade500,
      Colors.green.shade600,
      Colors.green.shade700,
      Colors.green.shade800,
      Colors.green.shade900,
    ],
    [
      Colors.orange.shade200,
      Colors.orange.shade300,
      Colors.orange.shade400,
      Colors.orange.shade500,
      Colors.orange.shade600,
      Colors.orange.shade700,
      Colors.orange.shade800,
      Colors.orange.shade900,
    ],
    [
      Colors.teal.shade200,
      Colors.teal.shade300,
      Colors.teal.shade400,
      Colors.teal.shade500,
      Colors.teal.shade600,
      Colors.teal.shade700,
      Colors.teal.shade800,
      Colors.teal.shade900,
    ],
    [
      Colors.amber.shade200,
      Colors.amber.shade300,
      Colors.amber.shade400,
      Colors.amber.shade500,
      Colors.amber.shade600,
      Colors.amber.shade700,
      Colors.amber.shade800,
      Colors.amber.shade900,
    ],
    [
      Colors.deepPurple.shade200,
      Colors.deepPurple.shade300,
      Colors.deepPurple.shade400,
      Colors.deepPurple.shade500,
      Colors.deepPurple.shade600,
      Colors.deepPurple.shade700,
      Colors.deepPurple.shade800,
      Colors.deepPurple.shade900,
    ],
    [
      Colors.cyan.shade200,
      Colors.cyan.shade300,
      Colors.cyan.shade400,
      Colors.cyan.shade500,
      Colors.cyan.shade600,
      Colors.cyan.shade700,
      Colors.cyan.shade800,
      Colors.cyan.shade900,
    ],
    [
      Colors.indigo.shade200,
      Colors.indigo.shade300,
      Colors.indigo.shade400,
      Colors.indigo.shade500,
      Colors.indigo.shade600,
      Colors.indigo.shade700,
      Colors.indigo.shade800,
      Colors.indigo.shade900,
    ],
    [
      Colors.lime.shade200,
      Colors.lime.shade300,
      Colors.lime.shade400,
      Colors.lime.shade500,
      Colors.lime.shade600,
      Colors.lime.shade700,
      Colors.lime.shade800,
      Colors.lime.shade900,
    ],
    [
      Colors.deepOrange.shade200,
      Colors.deepOrange.shade300,
      Colors.deepOrange.shade400,
      Colors.deepOrange.shade500,
      Colors.deepOrange.shade600,
      Colors.deepOrange.shade700,
      Colors.deepOrange.shade800,
      Colors.deepOrange.shade900,
    ],
    [
      Colors.brown.shade200,
      Colors.brown.shade300,
      Colors.brown.shade400,
      Colors.brown.shade500,
      Colors.brown.shade600,
      Colors.brown.shade700,
      Colors.brown.shade800,
      Colors.brown.shade900,
    ],
    [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ],
    [
      Colors.blueGrey.shade200,
      Colors.blueGrey.shade300,
      Colors.blueGrey.shade400,
      Colors.blueGrey.shade500,
      Colors.blueGrey.shade600,
      Colors.blueGrey.shade700,
      Colors.blueGrey.shade800,
      Colors.blueGrey.shade900,
    ],
    [
      Colors.pink.shade200,
      Colors.pink.shade300,
      Colors.pink.shade400,
      Colors.pink.shade500,
      Colors.pink.shade600,
      Colors.pink.shade700,
      Colors.pink.shade800,
      Colors.pink.shade900,
    ],
    [
      Colors.lightBlue.shade200,
      Colors.lightBlue.shade300,
      Colors.lightBlue.shade400,
      Colors.lightBlue.shade500,
      Colors.lightBlue.shade600,
      Colors.lightBlue.shade700,
      Colors.lightBlue.shade800,
      Colors.lightBlue.shade900,
    ],
    [
      Colors.lightGreen.shade200,
      Colors.lightGreen.shade300,
      Colors.lightGreen.shade400,
      Colors.lightGreen.shade500,
      Colors.lightGreen.shade600,
      Colors.lightGreen.shade700,
      Colors.lightGreen.shade800,
      Colors.lightGreen.shade900,
    ],
    [
      Colors.deepPurpleAccent.shade100,
      Colors.deepPurpleAccent.shade200,
      Colors.deepPurpleAccent.shade400,
      Colors.deepPurpleAccent.shade700,
    ],
    [
      Colors.amberAccent.shade100,
      Colors.amberAccent.shade200,
      Colors.amberAccent.shade400,
      Colors.amberAccent.shade700,
    ],
    [
      Colors.blueAccent.shade100,
      Colors.blueAccent.shade200,
      Colors.blueAccent.shade400,
      Colors.blueAccent.shade700,
    ],
    [
      Colors.cyanAccent.shade100,
      Colors.cyanAccent.shade200,
      Colors.cyanAccent.shade400,
      Colors.cyanAccent.shade700,
    ],
    [
      Colors.deepOrangeAccent.shade100,
      Colors.deepOrangeAccent.shade200,
      Colors.deepOrangeAccent.shade400,
      Colors.deepOrangeAccent.shade700,
    ],
    [
      Colors.deepPurpleAccent.shade100,
      Colors.deepPurpleAccent.shade200,
      Colors.deepPurpleAccent.shade400,
      Colors.deepPurpleAccent.shade700,
    ],
    [
      Colors.greenAccent.shade100,
      Colors.greenAccent.shade200,
      Colors.greenAccent.shade400,
      Colors.greenAccent.shade700,
    ],
    [
      Colors.indigoAccent.shade100,
      Colors.indigoAccent.shade200,
      Colors.indigoAccent.shade400,
      Colors.indigoAccent.shade700,
    ],
    [
      Colors.lightBlueAccent.shade100,
      Colors.lightBlueAccent.shade200,
      Colors.lightBlueAccent.shade400,
      Colors.lightBlueAccent.shade700,
    ],
    [
      Colors.orangeAccent.shade100,
      Colors.orangeAccent.shade200,
      Colors.orangeAccent.shade400,
      Colors.orangeAccent.shade700,
    ],
    [
      Colors.pinkAccent.shade100,
      Colors.pinkAccent.shade200,
      Colors.pinkAccent.shade400,
      Colors.pinkAccent.shade700,
    ],
    [
      Colors.purpleAccent.shade100,
      Colors.purpleAccent.shade200,
      Colors.purpleAccent.shade400,
      Colors.purpleAccent.shade700,
    ],
  ];
  List<String> assetsIc = [
    'assets/images/ic-music.png',
    'assets/images/ic-star.png',
    'assets/images/ic-audio-wave.png',
    'assets/images/ic-music-record.png',
    'assets/images/ic-headphones.png',
    'assets/images/ic-sample-rate.png',
  ];

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    _pageChangeTimer?.cancel();
    super.dispose();
  }

  void _startAutoPageChange() {
    _pageChangeTimer?.cancel();
    _pageChangeTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (!isPageViewBuilt || _pageController.positions.isEmpty) return;

      int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
      if (nextPage >= 3) {
        nextPage = 0;
      }
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void onChangPage({required int index}) {
    setState(() {
      currentlyPage = index;
    });
  }

  int getRandomNumber() {
    var random = Random();
    return random.nextInt(6);
  }

  void handleGenre({required int id}) {
    print('-------------------handleGenre với id: ${id}-------------------');
    setState(() {
      _idForGenreTopic = id;
      _nameForGenreTopic = allGenres[id - 1].name;
      _typeForGenreTopic = 'genre';
      _startForGenreTopic = 'TopicGenrePage';
    });
    widget.onTapItem(_idForGenreTopic, _nameForGenreTopic, _typeForGenreTopic, _startForGenreTopic);
  }

  void handleTopic({required int id}) {
    print('-------------------handleTopic với id: ${id}-------------------');
    setState(() {
      _idForGenreTopic = id;
      _nameForGenreTopic = allTopics[id - 1].name;
      _typeForGenreTopic = 'topic';
      _startForGenreTopic = 'TopicGenrePage';
    });
    widget.onTapItem(_idForGenreTopic, _nameForGenreTopic, _typeForGenreTopic, _startForGenreTopic);
  }

  Future<void> loadData() async {
    try {
      List<Genre> getAllGenres = await ModelviewsManager.genreModelview.getAllGenres();
      List<Topic> getAllTopics = await ModelviewsManager.topicModelviews.getAllTopics();
      setState(() {
        allGenres = getAllGenres;
        allTopics = getAllTopics;
        genresAndTopics.addAll(allGenres);
        genresAndTopics.addAll(allTopics);
        print('getAllGenres: ${getAllGenres}');
        print('getAllTopics: ${getAllTopics}');
        print('genresAndTopics: ${genresAndTopics}');
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isPageViewBuilt) {
        setState(() {
          isPageViewBuilt = true;
        });
        _startAutoPageChange();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build TopicGenrePage-----------------------------');
    return GestureDetector(
      // onHorizontalDragUpdate: (details) {
      //   if (details.delta.dx > 0 &&
      //       !isSwipingLeft &&
      //       details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
      //     // Vuốt từ trái sang phải
      //     widget.onBack();
      //     isSwipingLeft = true; // Đánh dấu đã xử lý vuốt từ trái sang phải
      //   }
      // },
      // onHorizontalDragEnd: (details) {
      //   isSwipingLeft = false; // Đặt lại biến đánh dấu khi kết thúc vuốt ngang
      // },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0.w,
          0.h,
          0.w,
          0.h,
        ),
        width: 428.w,
        height: MediaQuery.of(context).size.height,
        // color: const Color.fromARGB(255, 30, 30, 30),
        color: Colors.transparent,
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(-0.w, -0.h),
              // Di chuyển sang trái 25.w và lên trên 0.h
              child: GestureDetector(
                onTap: () {
                  _scrollToTop();
                },
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: 80.h,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    25.w,
                    0.h,
                    25.w,
                    0.h,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            widget.onBack();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 32.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 32.w),
                          alignment: Alignment.bottomCenter,
                          color: Colors.transparent,
                          child: Text(
                            'Chủ đề và thể loại',
                            style: TextStyle(
                              fontFamily: 'CenturyGothicBold',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 13, 72, 79),
                        // Color.fromARGB(255, 16, 43, 45),
                      ),
                    )
                  : genresAndTopics.isEmpty
                      ? Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontFamily: 'CenturyGothicRegular',
                              fontSize: 20.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.fromLTRB(
                            0.w,
                            15.h,
                            0.w,
                            0.h,
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 150.h),
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 130.h,
                                    child: PageView(
                                      controller: _pageController,
                                      scrollDirection: Axis.horizontal,
                                      reverse: false,
                                      onPageChanged: (index) {
                                        onChangPage(index: index);
                                      },
                                      pageSnapping: true,
                                      physics: const ClampingScrollPhysics(),
                                      children: [
                                        for (int i = 0; i < 3; i++)
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                              25.w,
                                              0.h,
                                              25.w,
                                              0.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  photo[i],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 130.h,
                                    alignment: Alignment.bottomCenter,
                                    child: DotsIndicator(
                                      position: currentlyPage,
                                      dotsCount: 3,
                                      reversed: false,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      decorator: DotsDecorator(
                                        size: Size.square(9),
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        activeSize: Size(15, 9),
                                        activeShape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        activeColor: Color.fromARGB(255, 13, 72, 79),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                  25.w,
                                  25.h,
                                  0.w,
                                  10.h,
                                ),
                                child: Text(
                                  "Thể loại",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.fromLTRB(
                                  25.w,
                                  0.h,
                                  25.w,
                                  0.h,
                                ),
                                child: GridView.count(
                                  padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  crossAxisCount: 2,
                                  childAspectRatio: 2,
                                  shrinkWrap: true,
                                  // Đặt shrinkWrap thành true để phù hợp với không gian con của ListView
                                  children: List.generate(
                                    allGenres.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          handleGenre(id: allGenres[index].id);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                            10.w,
                                            12.h,
                                            10.w,
                                            5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: colorsList[index],
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 20.h,
                                                height: 20.h,
                                                child: Image.asset(
                                                  assetsIc[index % assetsIc.length],
                                                  color: Colors.white,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                allGenres[index].name.toUpperCase(),
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicBold',
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                  25.w,
                                  25.h,
                                  0.w,
                                  10.h,
                                ),
                                child: Text(
                                  "Chủ Đề",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.fromLTRB(
                                  25.w,
                                  0.h,
                                  25.w,
                                  0.h,
                                ),
                                child: GridView.count(
                                  padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  crossAxisCount: 2,
                                  childAspectRatio: 2,
                                  shrinkWrap: true,
                                  // Đặt shrinkWrap thành true để phù hợp với không gian con của ListView
                                  children: List.generate(
                                    allTopics.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          handleTopic(id: allTopics[index].id);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                            10.w,
                                            12.h,
                                            10.w,
                                            5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: colorsList[colorsList.length - index - 1],
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 20.h,
                                                height: 20.h,
                                                child: Image.asset(
                                                  assetsIc[index % assetsIc.length],
                                                  color: Colors.white,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                allTopics[index].name.toUpperCase(),
                                                style: TextStyle(
                                                  fontFamily: 'CenturyGothicBold',
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
