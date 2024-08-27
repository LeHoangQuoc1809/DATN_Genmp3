import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/circel_picture_component.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/rss.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../models/user.dart';
import '../../../models/user.dart';
import '../../../models/artist.dart';
import '../../../models/song.dart';
import '../../../services/service_mng.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/input_box.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:html';

class UserFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  User? user;

  UserFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.user,
  });

  @override
  State<UserFeatureDialog> createState() => _UserFeatureDialogState();
}

class _UserFeatureDialogState extends State<UserFeatureDialog> {
  final _formKey = GlobalKey<FormState>();

  late Future<void> _createUserState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  String _nameErrorValidationText = "";

  String _descriptionErrorValidationText = "";

  String _pictureErrorValidationText = "";

  String _fileName = "";

  String _base64String = "";

  String _releaseDateText = "";

  String _releaseDateErrorValidationText = "";

  DateTime? _selectedDateTime;

  Artist? _artist;

  String _artistErrorValidationText = "";

  User? _user;

  List<Song>? _songs;

  int mode = 0;

  bool isNotError = false;

  bool isLoading = true;

  String dateTimeToStringFormat(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // Pick date first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _releaseDateText = dateTimeToStringFormat(_selectedDateTime!);
          _releaseDateErrorValidationText = "";
        });
      }
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
        await createNewEntry();
      } else if (widget.mode == 1) //Edit mode
      {
        //editEntry
      }
      Navigator.of(context).pop(1); //return 1 to reload the List
    } else {
      setState(() {
        createUserState();
      });
    }
  }

  Future<void> createNewEntry() async {
    // await ModelviewsManager.userModelview.createUser(
    //   name: _nameController.text,
    //   description: _descriptionController.text,
    // );
  }

  bool areInputsValid() {
    return _nameErrorValidationText.isEmpty &&
        _releaseDateErrorValidationText.isEmpty &&
        _pictureErrorValidationText.isEmpty;
  }

  void validateSongInputs() {
    _nameErrorValidationText =
        _nameController.text.isEmpty ? "Name cannot be empty" : "";
    _releaseDateErrorValidationText =
        _releaseDateText.isEmpty ? "Release Date cannot be empty" : "";
    _pictureErrorValidationText =
        _fileName.isEmpty ? "Picture cannot be empty" : "";
  }

  Future<void> createUserState() async {
    if (widget.mode != 0) {
      setState(() {
        _nameController.text = _user!.name;
      });
    }
  }

  Future<void> onTapChooseArtist(BuildContext context) async {
    // final result = await showGeneralDialog<Artist>(
    //     context: context,
    //     transitionDuration: const Duration(milliseconds: 300),
    //     // Adjust duration according to your needs
    //     transitionBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(
    //         opacity: CurvedAnimation(
    //           parent: animation,
    //           curve: Curves.linear,
    //         ),
    //         child: child,
    //       );
    //     },
    //     pageBuilder: (context, animation, secondaryAnimation) {
    //       return AddArtistForUser();
    //     });
    //
    // if (result != null) {
    //   setState(() {
    //     _artist = result;
    //   });
    // }
  }

  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New User";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit User";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "User Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _user = widget.user!;
    }
    _createUserState = createUserState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    double textBoxWidth = rss.u * 50;
    double textBoxHeight = rss.u * 13;
    return FutureBuilder<void>(
      future: _createUserState,
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

                  _buildChooseArtist(rss, onTapChooseArtist, textBoxWidth,
                      textBoxHeight, "Choose Artist"),
                  if (_artistErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _artistErrorValidationText),

                  SizedBox(height: rss.u * 5),

                  _buildDateTimePicker(
                      context,
                      rss,
                      textBoxWidth,
                      textBoxHeight,
                      _selectDateTime,
                      "Release Date",
                      _releaseDateText),

                  //
                  if (_releaseDateErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _releaseDateErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  _buildFilePicker(context, rss, textBoxWidth, textBoxHeight,
                      "Photo File", pickImageFile, _base64String, _fileName),
                  if (_pictureErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _pictureErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  if (_base64String.isNotEmpty) _buildImagePreview(rss),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildChooseArtist(RSS rss, Function onTap, double textBoxWidth,
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
              child: Row(
                children: [
                  if (_artist != null)
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: rss.u * 15,
                        width: rss.u * 15,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          image: DecorationImage(
                            image: NetworkImage(Artist.getUrlImg(
                                _artist!.picture, _artist!.id)),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(rss.u * 20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, rss.u * 1),
                              blurRadius: rss.u * 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 9,
                    child: Text(
                      _artist != null ? _artist!.name : "None are selected",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: rss.u * 7,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
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
          child: Image.network(_base64String, fit: BoxFit.fill),
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
    String fileSrc,
    String fileName,
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
                fileSrc.isNotEmpty ? fileName : "None are selected",
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
