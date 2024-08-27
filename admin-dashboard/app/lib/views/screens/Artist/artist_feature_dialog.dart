import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/models/artist.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/rss.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../models/topic.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/input_box.dart';
import 'dart:async';
import 'dart:html';

class ArtistFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  Artist? artist;

  ArtistFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.artist,
  });

  @override
  State<ArtistFeatureDialog> createState() => _ArtistFeatureDialogState();
}

class _ArtistFeatureDialogState extends State<ArtistFeatureDialog> {
  late Future<void> _createArtistState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  String _nameErrorValidationText = "";

  String _descriptionErrorValidationText = "";

  String _pictureErrorValidationText = "";

  String _fileName = "";

  String _base64String = "";

  late Artist _artist;

  int mode = 0;

  bool isNotError = false;

  bool isLoading = true;

  void confirmEvent(BuildContext context) async {
    setState(() {
      validateSongInputs();
      isNotError = areInputsValid();
    });

    if (isNotError) {
      if (widget.mode == 0) //Create mode
      {
        Artist? newCreateArtist = await createNewEntry();
        if (newCreateArtist != null) {}
      } else if (widget.mode == 1) //Edit mode
      {
        Artist? newUpdateArtist = await editEntry();
        if (newUpdateArtist != null) {}
      }
      Navigator.of(context).pop(1); //return 1 to reload the List
    } else {
      setState(() {
        createArtistState();
      });
    }
  }

  Future<Artist?> editEntry() async {
    Artist? newCreateArtist =
        await ModelviewsManager.artistModelview.updateArtist(
      id: _artist.id,
      pictureBase64: _base64String,
      picture: _fileName.toString().split('.').first,
      name: _nameController.text,
      description: _descriptionController.text,
    );
    return newCreateArtist;
  }

  Future<Artist?> createNewEntry() async {
    Artist? newUpdateArtist =
        await ModelviewsManager.artistModelview.createArtist(
      pictureBase64: _base64String.split(',').last,
      picture: _fileName.toString().split('.').first,
      name: _nameController.text,
      description: _descriptionController.text,
    );
    return newUpdateArtist;
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

  Future<void> createArtistState() async {
    if (widget.mode != 0) {
      setState(() {
        _nameController.text = _artist.name;
        _descriptionController.text =
            _artist.description != null ? _artist.description! : "";
        _fileName = _artist.picture;
      });
    }
  }

  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New Artist";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit Artist";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "Artist Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _artist = widget.artist!;
    }
    _createArtistState = createArtistState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    double textBoxWidth = rss.u * 50;
    double textBoxHeight = rss.u * 13;
    return FutureBuilder<void>(
      future: _createArtistState,
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
                  : Artist.getUrlImg(_fileName, _artist.id),
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
