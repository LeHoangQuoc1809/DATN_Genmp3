import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/rss.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../models/genre.dart';
import '../../../models/topic.dart';
import '../../../services/service_mng.dart';
import '../../components/input_box.dart';

class GenreFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  Genre? genre;

  GenreFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.genre,
  });

  @override
  State<GenreFeatureDialog> createState() => _GenreFeatureDialogState();
}

class _GenreFeatureDialogState extends State<GenreFeatureDialog> {
  late Future<void> _createGenreState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _nameErrorValidationText = "";
  String _descriptionErrorValidationText = "";

  late Genre _genre;

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
        await createNewEntry();
      } else if (widget.mode == 1) //Edit mode
      {
        await editEntry();
      }
      Navigator.of(context).pop(1); //return 1 to reload the List
    } else {
      setState(() {
        createGenreState();
      });
    }
  }

  Future<void> editEntry() async {
    await ModelviewsManager.genreModelview.updateGenre(
      id: _genre.id,
      name: _nameController.text,
      description: _descriptionController.text,
    );
  }

  Future<void> createNewEntry() async {
    await ModelviewsManager.genreModelview.createGenre(
      name: _nameController.text,
      description: _descriptionController.text,
    );
  }

  bool areInputsValid() {
    return _nameErrorValidationText.isEmpty;
  }

  void validateSongInputs() {
    _nameErrorValidationText =
        _nameController.text.isEmpty ? "Name cannot be empty" : "";
  }

  Future<void> createGenreState() async {
    if (widget.mode != 0) {
      setState(() {
        _nameController.text = _genre.name;
        _descriptionController.text =
            _genre.description != null ? _genre.description! : "";
      });
    }
  }

  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New Genre";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit Genre";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "Genre Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _genre = widget.genre!;
    }
    _createGenreState = createGenreState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    return FutureBuilder<void>(
      future: _createGenreState,
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
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
