import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/rss.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../models/topic.dart';
import '../../../services/service_mng.dart';
import '../../components/input_box.dart';

class TopicFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  Topic? topic;

  TopicFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.topic,
  });

  @override
  State<TopicFeatureDialog> createState() => _TopicFeatureDialogState();
}

class _TopicFeatureDialogState extends State<TopicFeatureDialog> {
  late Future<void> _createTopicState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _nameErrorValidationText = "";
  String _descriptionErrorValidationText = "";

  late Topic _topic;

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
        createTopicState();
      });
    }
  }

  Future<void> editEntry() async {
    await ModelviewsManager.topicModelviews.updateTopicById(
      id: _topic.id,
      name: _nameController.text,
      description: _descriptionController.text,
    );
  }

  Future<void> createNewEntry() async {
    await ModelviewsManager.topicModelviews.createTopic(
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

  Future<void> createTopicState() async {
    if (widget.mode != 0) {
      setState(() {
        _nameController.text = _topic.name;
        _descriptionController.text =
            _topic.description != null ? _topic.description! : "";
      });
    }
  }

  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New Topic";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit Topic";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "Topic Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _topic = widget.topic!;
    }
    _createTopicState = createTopicState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    return FutureBuilder<void>(
      future: _createTopicState,
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
