import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/song_model.dart';
import '../pages/Song/song_snack_bar_content.dart';

void onDismissKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.focusedChild?.unfocus();
  }
}

void showSnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 3500),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void handleOnTapDetailSong(Song tappedSong, BuildContext context) async {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: SongSnackBarContent(
          song: tappedSong,
        ),
      );
    },
  );
}
