import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../configs/rss.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatefulWidget {
  MainMenu({
    Key? key,
    required this.layoutContext,
    required this.onTagSelected,
  }) : super(key: key);
  final layoutContext;
  final Function(int) onTagSelected;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0; // Default to first item being selected

  RSS rss = RSS();

  void _onMenuTagTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTagSelected(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rss.init(context);
    Color selectedIconColor = const Color(0xFFFFFFFF);
    Color selectedBgIconColor = const Color(0xFF4FD1C5);
    Color selectedTextColor = const Color(0xFF2D3748);
    Color unselectedTextColor = const Color(0xFFA0AEC0);
    Color unselectedIconColor = const Color(0xFF4FD1C5);
    Color unselectedBgIconColor = const Color(0xFFFFFFFF);
    TextStyle selectedTextStyle = GoogleFonts.roboto(
      color: selectedTextColor,
      fontWeight: FontWeight.bold,
      fontSize: rss.u * 7,
    );
    TextStyle unselectedTextStyle = GoogleFonts.roboto(
      color: unselectedTextColor,
      fontWeight: FontWeight.normal,
      fontSize: rss.u * 6,
    );
    return Container(
      width: rss.u * 100,
      padding: EdgeInsets.only(left: rss.u * 7, right: rss.u * 7),
      // Fixed width for sidebar
      child: Column(
        children: [
          Container(
            height: rss.u * 20,
            padding: EdgeInsets.only(left: rss.u * 8, right: rss.u * 8),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.barsProgress,
                  color: const Color(0xFF2D3748),
                  size: rss.u * 12,
                ),
                SizedBox(
                  width: rss.u * 5,
                ),
                AutoSizeText(
                  "MENU",
                  style: GoogleFonts.roboto(
                    fontSize: rss.u * 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: rss.u * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade400,
                  Colors.grey.shade400,
                  Colors.transparent,
                ],
                stops: const [
                  0,
                  0.3,
                  0.3,
                  1
                ], // Adjust these to control the fade length
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: rss.u * 5),
              children: [
                MenuTag(
                  contentTag: "Topic",
                  isSelected: _selectedIndex == 0,
                  iconTag: FontAwesomeIcons.barsStaggered,
                  onTap: () => _onMenuTagTapped(0),
                ),
                MenuTag(
                  contentTag: "Genre",
                  isSelected: _selectedIndex == 1,
                  iconTag: FontAwesomeIcons.fan,
                  onTap: () => _onMenuTagTapped(1),
                ),
                MenuTag(
                  contentTag: "Songs",
                  isSelected: _selectedIndex == 2,
                  iconTag: FontAwesomeIcons.music,
                  onTap: () => _onMenuTagTapped(2),
                ),
                MenuTag(
                  contentTag: "Artist",
                  isSelected: _selectedIndex == 3,
                  iconTag: FontAwesomeIcons.feather,
                  onTap: () => _onMenuTagTapped(3),
                ),
                MenuTag(
                  contentTag: "Album",
                  isSelected: _selectedIndex == 4,
                  iconTag: FontAwesomeIcons.compactDisc,
                  onTap: () => _onMenuTagTapped(4),
                ),
                MenuTag(
                  contentTag: "User",
                  isSelected: _selectedIndex == 5,
                  iconTag: FontAwesomeIcons.userLarge,
                  onTap: () => _onMenuTagTapped(5),
                ),
                MenuTag(
                  contentTag: "Playlist",
                  isSelected: _selectedIndex == 6,
                  iconTag: FontAwesomeIcons.playstation,
                  onTap: () => _onMenuTagTapped(6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MenuTag extends StatefulWidget {
  MenuTag({
    Key? key,
    this.isSelected = true,
    this.contentTag = "",
    this.iconTag = FontAwesomeIcons.music,
    required this.onTap,
    //required this.layoutContext,
  }) : super(key: key);
  bool isSelected;
  String contentTag;
  IconData iconTag;
  final onTap;

  //final layoutContext;

  @override
  State<MenuTag> createState() => _MenuTagState();
}

class _MenuTagState extends State<MenuTag> {
  double _elevation = 3.0;
  late bool isSelected;
  late IconData iconTag;

  //RSS rss = RSS();
  @override
  void initState() {
    super.initState();
    iconTag = widget.iconTag;
    //rss.init(widget.layoutContext);
  }

  @override
  Widget build(BuildContext context) {
    isSelected = widget.isSelected;
    RSS rss = RSS();
    rss.init(context);
    Color selectedIconColor = const Color(0xFFFFFFFF);
    Color selectedBgIconColor = const Color(0xFF4FD1C5);
    Color selectedTextColor = const Color(0xFF2D3748);
    Color unselectedTextColor = const Color(0xFFA0AEC0);
    Color unselectedIconColor = const Color(0xFF4FD1C5);
    Color unselectedBgIconColor = const Color(0xFFFFFFFF);
    Color selectedBoxBgColor = const Color(0xFFFFFFFF);
    Color unselectedBoxBgColor = const Color(0xFFFFFF);
    TextStyle selectedTextStyle = GoogleFonts.roboto(
      color: selectedTextColor,
      fontWeight: FontWeight.bold,
      fontSize: rss.u * 7,
    );
    TextStyle unselectedTextStyle = GoogleFonts.roboto(
      color: unselectedTextColor,
      fontWeight: FontWeight.normal,
      fontSize: rss.u * 6,
    );
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _elevation = 2.0;
      }),
      onTapUp: (_) => setState(() {
        _elevation = 3.0;
      }),
      onTapCancel: () => setState(() {
        _elevation = 3.0;
      }),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding:
              EdgeInsets.fromLTRB(rss.u * 6, rss.u * 4, rss.u * 6, rss.u * 4),
          decoration: BoxDecoration(
            color: isSelected ? selectedBoxBgColor : unselectedBoxBgColor,
            borderRadius: BorderRadius.circular(rss.u * 8),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.black.withOpacity(0.1)
                    : Colors.transparent,
                offset: Offset(0, _elevation),
                blurRadius: _elevation,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: rss.u * 16,
                height: rss.u * 16,
                decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBgIconColor
                        : unselectedBgIconColor,
                    borderRadius: BorderRadius.circular(rss.u * 6)),
                child: Center(
                  child: FaIcon(
                    iconTag,
                    color: isSelected ? selectedIconColor : unselectedIconColor,
                    size: rss.u * 6,
                  ),
                ),
              ),
              SizedBox(
                width: rss.u * 4,
              ),
              AutoSizeText(
                widget.contentTag,
                style: isSelected ? selectedTextStyle : unselectedTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
