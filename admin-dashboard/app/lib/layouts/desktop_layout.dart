import 'package:app/configs/rss.dart';
import 'package:app/views/components/main_menu.dart';
import 'package:app/views/components/top_bar.dart';
import 'package:app/views/screens/Album/album_content_panel.dart';
import 'package:app/views/screens/Artist/artist_content_panel.dart';
import 'package:app/views/screens/Genre/genre_content_panel.dart';
import 'package:app/views/screens/Playlist/playlist_content_panel.dart';
import 'package:app/views/screens/User/user_content_panel.dart';
import 'package:flutter/material.dart';

import '../views/screens/Song/song_content_panel.dart';
import '../views/screens/Topic/topic_content_panel.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  int _selectedIndex = 0; // Initial index
  RSS rss = RSS();

  // Function to change the selected index
  void _changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 1:
        return GenreContentPanel(rss: rss);
      case 2:
        return SongContentPanel(rss: rss);
      case 3:
        return ArtistContentPanel(rss: rss);
      case 4:
        return AlbumContentPanel(rss: rss);
      case 5:
        return UserContentPanel(rss: rss);
      case 6:
        return PlaylistContentPanel(rss: rss);
      default:
        return TopicContentPanel(
          rss: rss,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    rss.init(context);
    return Scaffold(
      appBar: TopBar(
        appBarHeight: rss.u * 25,
      ),
      // Ensure you create an instance of TopBar here
      body: Container(
        padding: EdgeInsets.only(top: rss.u * 5),
        color: const Color(0xFFF8F9FA),
        child: Row(
          children: [
            MainMenu(
              layoutContext: context,
              onTagSelected: _changeIndex,
            ),
            Expanded(
              child: _getSelectedScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
