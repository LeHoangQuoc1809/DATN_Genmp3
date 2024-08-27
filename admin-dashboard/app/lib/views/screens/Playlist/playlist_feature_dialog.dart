import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/models/artist.dart';
import 'package:app/models/playlist.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:app/views/screens/Playlist/add_songs_for_playlist.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/rss.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../configs/dateFormat.dart';
import '../../../models/song.dart';
import '../../../models/topic.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/input_box.dart';
import 'dart:async';
import 'dart:html';

class PlaylistFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  Playlist? playlist;

  PlaylistFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.playlist,
  });

  @override
  State<PlaylistFeatureDialog> createState() => _PlaylistFeatureDialogState();
}

class _PlaylistFeatureDialogState extends State<PlaylistFeatureDialog> {
  late Future<void> _createPlaylistState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  String _nameErrorValidationText = "";

  String _descriptionErrorValidationText = "";

  String _pictureErrorValidationText = "";

  String _fileName = "";

  String _base64String = "";

  late Playlist _playlist;

  List<Song> _songs = [];

  int mode = 0;

  bool isNotError = false;

  bool isLoading = true;

  void onTapAddSongs(BuildContext context) async {
    final result = await showGeneralDialog<List<Song>>(
        context: context,
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.linear,
            ),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddSongsForPlaylist();
        });

    if (result != null) {
      setState(() {
        _songs = result;
      });
    }
  }

  void confirmEvent(BuildContext context) async {
    setState(() {
      validateSongInputs();
      isNotError = areInputsValid();
    });

    if (isNotError) {
      if (widget.mode == 0) //Create mode
      {
        Playlist? newCreatePlaylist = await createNewEntry();
        if (newCreatePlaylist != null) {}
      } else if (widget.mode == 1) //Edit mode
      {
        Playlist? newUpdatePlaylist = await editEntry();
        if (newUpdatePlaylist != null) {}
      }
      Navigator.of(context).pop(1); //return 1 to reload the List
    } else {
      setState(() {
        createPlaylistState();
      });
    }
  }

  Future<Playlist?> editEntry() async {
    // Playlist? newCreatePlaylist =
    //     await ModelviewsManager.artistModelview.updateArtist(
    //   id: _playlist.id,
    //   pictureBase64: _base64String,
    //   picture: _fileName.toString().split('.').first,
    //   name: _nameController.text,
    //   description: _descriptionController.text,
    // );
    // return newCreatePlaylist;
  }

  Future<Playlist?> createNewEntry() async {
    Playlist? newPlaylist =
        await ModelviewsManager.playlistModelview.createPlaylist(
      pictureBase64: _base64String.split(',').last,
      picture: _fileName.toString().split('.').first,
      name: _nameController.text,
      description: _descriptionController.text,
      song_ids: _songs.map((song) => song.id).toList(),
    );
    return newPlaylist;
  }

  bool areInputsValid() {
    return _nameErrorValidationText.isEmpty &&
        _pictureErrorValidationText.isEmpty;
  }

  void validateSongInputs() {
    _nameErrorValidationText =
        _nameController.text.isEmpty ? "Name cannot be empty" : "";
    _pictureErrorValidationText =
        _fileName.isEmpty ? "Picture cannot be empty" : "";
  }

  Future<void> createPlaylistState() async {
    if (widget.mode != 0) {
      setState(() {
        _nameController.text = _playlist.name;
        _descriptionController.text =
            _playlist.description != null ? _playlist.description! : "";
        _fileName = _playlist.picture;
        _songs = _playlist.songs;
      });
    }
  }

  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New Playlist";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit Playlist";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "Playlist Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _playlist = widget.playlist!;
    }
    _createPlaylistState = createPlaylistState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    double textBoxWidth = rss.u * 50;
    double textBoxHeight = rss.u * 13;
    return FutureBuilder<void>(
      future: _createPlaylistState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading...",
                    style: GoogleFonts.roboto(
                      fontSize: rss.u * 20,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: rss.u * 20),
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade100,
                    color: Colors.blueAccent,
                    strokeWidth: rss.u * 5,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return FeatureDialog(
            rss: rss,
            title: _titleDialog,
            confirmEvent: () {
              confirmEvent(context);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InputBox(
                    controller: _nameController,
                    requirement: true,
                    label: "Name",
                    errorText: _nameErrorValidationText,
                  ),
                  SizedBox(height: rss.u * 5),
                  InputBox(
                    controller: _descriptionController,
                    label: "Description",
                    isFlexibleHeight: true,
                    errorText: _descriptionErrorValidationText,
                  ),
                  SizedBox(height: rss.u * 5),
                  _buildAddSongs(rss, onTapAddSongs, textBoxWidth,
                      textBoxHeight, "Add Songs"),
                  SizedBox(height: rss.u * 5),
                  _buildFilePicker(
                    context,
                    rss,
                    textBoxWidth,
                    textBoxHeight,
                    "Photo File",
                    pickImageFile,
                  ),
                  if (_pictureErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _pictureErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  if (_fileName.isNotEmpty) _buildImagePreview(rss),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAddSongs(RSS rss, Function onTap, double textBoxWidth,
      double textBoxHeight, String label) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          PushdownGesturedetector(
            bgColor: const Color(0xFF4FD1C5),
            elevation: rss.u * 1,
            onTapDownElevation: rss.u * 0.2,
            radius: rss.u * 10,
            onTap: () => onTap(context),
            child: TextContentBox(
              width: textBoxWidth,
              height: textBoxHeight,
              text: label,
            ),
          ),
          SizedBox(width: rss.u * 5),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: rss.u * 16,
              padding: EdgeInsets.fromLTRB(
                  rss.u * 5, rss.u * 2, rss.u * 5, rss.u * 2),
              decoration: BoxDecoration(
                border: Border.all(
                    width: rss.u * 0.5, color: const Color(0xFF4FD1C5)),
                borderRadius: BorderRadius.circular(rss.u * 10),
              ),
              child: Text(
                _songs.isNotEmpty
                    ? "${_songs.length} songs have been added!"
                    : "None are added",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: rss.u * 7,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(RSS rss) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: rss.u * 120,
          height: rss.u * 120,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: rss.u * 5),
          child: Image.network(
              _base64String.isNotEmpty
                  ? _base64String
                  : Playlist.getUrlImg(_fileName, _playlist.id),
              fit: BoxFit.fill),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _base64String = "";
                _fileName = "";
                _pictureErrorValidationText = "";
              });
            },
            child: FaIcon(
              FontAwesomeIcons.x,
              size: rss.u * 5,
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorText(RSS rss, String errorText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: rss.u * 5),
      child: Text(
        errorText,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: rss.u * 5,
          color: Colors.red.shade700,
        ),
      ),
    );
  }

  void pickImageFile() {
    pickFile(
      accept: 'image/*',
      onFilePicked: (file) {
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          if (reader.readyState == FileReader.DONE) {
            final String result = reader.result as String;
            // final String base64String = result
            //     .split(',')
            //     .last;
            setState(() {
              _base64String = result;
              _fileName = file.name;
              _pictureErrorValidationText = "";
            });
          }
        });
        reader.readAsDataUrl(file);
      },
    );
  }

  void pickFile(
      {required String accept, required void Function(File) onFilePicked}) {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = accept;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final file = files.first;
        onFilePicked(file);
      }
    });
  }

  Widget _buildFilePicker(
    BuildContext context,
    RSS rss,
    double textBoxWidth,
    double textBoxHeight,
    String label,
    Function onTap,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          PushdownGesturedetector(
            bgColor: const Color(0xFF4FD1C5),
            elevation: rss.u * 1,
            onTapDownElevation: rss.u * 0.2,
            radius: rss.u * 10,
            onTap: () => onTap(),
            child: TextContentBox(
              width: textBoxWidth,
              height: textBoxHeight,
              text: label,
            ),
          ),
          SizedBox(width: rss.u * 5),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: rss.u * 16,
              padding: EdgeInsets.fromLTRB(
                  rss.u * 5, rss.u * 2, rss.u * 5, rss.u * 2),
              decoration: BoxDecoration(
                border: Border.all(
                    width: rss.u * 0.5, color: const Color(0xFF4FD1C5)),
                borderRadius: BorderRadius.circular(rss.u * 10),
              ),
              child: Text(
                _fileName.isNotEmpty ? _fileName : "None are selected",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: rss.u * 7,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker(
    BuildContext context,
    RSS rss,
    double textBoxWidth,
    double textBoxHeight,
    Function(BuildContext) onTap,
    String label,
    String releaseDateText,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          PushdownGesturedetector(
            bgColor: const Color(0xFF4FD1C5),
            elevation: rss.u * 1,
            onTapDownElevation: rss.u * 0.2,
            radius: rss.u * 10,
            onTap: () => onTap(context),
            child: TextContentBox(
              width: textBoxWidth,
              height: textBoxHeight,
              text: label,
            ),
          ),
          SizedBox(width: rss.u * 5),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: rss.u * 16,
              padding: EdgeInsets.fromLTRB(
                  rss.u * 5, rss.u * 2, rss.u * 5, rss.u * 2),
              decoration: BoxDecoration(
                border: Border.all(
                    width: rss.u * 0.5, color: const Color(0xFF4FD1C5)),
                borderRadius: BorderRadius.circular(rss.u * 10),
              ),
              child: Text(
                releaseDateText.isNotEmpty
                    ? releaseDateText
                    : "None are selected",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: rss.u * 7,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextContentBox extends StatelessWidget {
  final String text;
  final double width;
  final double height;

  TextContentBox({
    Key? key,
    this.text = "",
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);

    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: rss.u * 7,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
