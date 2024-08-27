import 'package:client/models/playlist_model.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  BuildContext context;

  Playlist playlist;

  Function popCallBack;

  PlaylistPage({
    super.key,
    required this.context,
    required this.playlist,
    required this.popCallBack,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
