import 'dart:ui';

import 'package:app/modelViews/modelViews_mng.dart';
import 'package:app/views/components/feature_dialog_frame.dart';
import 'package:app/views/screens/Song/MultipleAdd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/configs/rss.dart';
import 'package:app/models/album.dart';
import 'package:app/models/song.dart';
import 'package:app/services/service_mng.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:html';
import 'package:audioplayers/audioplayers.dart';
import '../../../models/artist.dart';
import '../../../models/genre.dart';
import '../../../models/topic.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/input_box.dart';
import 'add_artists_for_song.dart';
import 'choose_album.dart';

class SongFeatureDialog extends StatefulWidget {
  final RSS rss;
  final int mode;
  Song? song;

  SongFeatureDialog({
    super.key,
    required this.rss,
    required this.mode,
    this.song,
  });

  @override
  State<SongFeatureDialog> createState() => _SongFeatureDialogState();
}

class _SongFeatureDialogState extends State<SongFeatureDialog> {
  late Future<void> _createSongState;

  String _titleDialog = "";

  String _subtitleDialog = "";

  TextEditingController _nameController = TextEditingController();

  TextEditingController _lyricController = TextEditingController();

  String _nameErrorValidationText = "";

  String _artistErrorValidationText = "";

  String _mp3ErrorValidationText = "";

  String _pictureErrorValidationText = "";

  String _lyricErrorValidationText = "";

  String _lyricFileName = "";

  String _lyricBase64String = "";

  String _lyricBase64SRC = "";

  List<Topic> _topics = [];

  List<String> _topicNames = [];

  List<String> _genreNames = [];

  String _topicErrorValidationText = "";

  List<Genre> _genres = [];

  String _genreErrorValidationText = "";

  String _albumErrorValidationText = "";

  int _duration = 0;

  Map<String, String> _pictureFile = {"filename": "", "base64Data": ""};

  Map<String, String> _mp3File = {"filename": "", "base64Data": ""};

  List<Artist> _artists = [];

  Album? _album;

  String _imageSrc = "";

  String _audioSrc = "";

  late Song _song;

  int mode = 0;

  bool isNotError = false;

  bool isLoading = true;

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

  void pickLyricFile() {
    pickFile(
      accept: 'text/plain',
      onFilePicked: (file) {
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) async {
          if (reader.readyState == FileReader.DONE) {
            final String result = reader.result as String;
            final String base64String =
                base64Encode(utf8.encode(result)); // Convert to UTF-8 first

            print("result:${result}");
            setState(() {
              _lyricController.text = result;
              _lyricBase64SRC = result;
              _lyricFileName = file.name;
              _lyricBase64String = base64String;
              _lyricErrorValidationText = "";
            });
          }
        });
        reader.readAsText(file);
      },
    );
  }

  void pickMP3File() {
    pickFile(
      accept: 'audio/mpeg',
      onFilePicked: (file) {
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          if (reader.readyState == FileReader.DONE) {
            final String fileContent = reader.result as String;
            // Extract the base64 data from the Data URL
            final String base64String = fileContent.split(',').last;
            final dataUrl = 'data:audio/mpeg;base64,$base64String';
            AudioElement audioElement = AudioElement()
              ..src = reader.result as String;
            audioElement.onLoadedMetadata.listen((event) {
              setState(() {
                _duration = audioElement.duration.toInt();
                _audioSrc = dataUrl;
                _mp3File['base64Data'] = base64String;
                _mp3File['filename'] = file.name;
                _mp3ErrorValidationText = "";
              });
            });
          }
        });

        reader.readAsDataUrl(file);
      },
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
            final String base64String = result.split(',').last;
            setState(() {
              _imageSrc = result;
              _pictureFile = {
                "filename": file.name,
                "base64Data": base64String,
              };
              _pictureErrorValidationText = "";
            });
          }
        });
        reader.readAsDataUrl(file);
      },
    );
  }

  Future<void> showDialogAndUpdateState<T>({
    required BuildContext context,
    required Widget Function(BuildContext) pageBuilder,
    required Function(T) onUpdate,
  }) async {
    final result = await showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) =>
          pageBuilder(context),
    );

    if (result != null) {
      setState(() {
        onUpdate(result);
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
        await createNewEntry();
      } else if (widget.mode == 1) //Edit mode
      {
        await editEntry();
      }
      Navigator.of(context).pop(1); //return 1 to reload the List
    } else {
      setState(() {
        createSongState();
      });
    }
  }

  Future<void> editEntry() async {
    int durationInt = _duration;
    Duration dur = Duration(seconds: durationInt);
    List<int> topicIds = await getTopicIdsByNames();
    List<int> genreIds = await getGenreIdsByNames();
    Song? newSong = await ModelviewsManager.songModelviews.updateSong(
      id: _song.id,
      pictureBase64: _pictureFile["base64Data"].toString(),
      mp3Base64: _mp3File["base64Data"].toString(),
      lyric: _lyricController.text,
      lyricBase64: _lyricBase64String,
      topicIds: topicIds,
      genreIds: genreIds,
      duration: "0${dur.toString().split('.').first}",
      album_id: _album!.id,
      name: _nameController.text,
      artist_ids: _artists.map((artist) => artist.id).toList(),
      picture: _pictureFile["filename"].toString().split('.').first,
    );
  }

  Future<void> createNewEntry() async {
    int durationInt = _duration;
    Duration dur = Duration(seconds: durationInt);
    List<int> topicIds = await getTopicIdsByNames();
    List<int> genreIds = await getGenreIdsByNames();
    Song? newSong = await ModelviewsManager.songModelviews.createSong(
      pictureBase64: _pictureFile["base64Data"].toString(),
      mp3Base64: _mp3File["base64Data"].toString(),
      lyric: _lyricBase64SRC,
      lyricBase64: _lyricBase64String,
      duration: "0${dur.toString().split('.').first}",
      album_id: _album!.id,
      name: _nameController.text,
      artist_ids: _artists.map((artist) => artist.id).toList(),
      picture: _pictureFile["filename"].toString().split('.').first,
      topicIds: topicIds,
      genreIds: genreIds,
    );
  }

  bool areInputsValid() {
    return _nameErrorValidationText.isEmpty &&
        _pictureErrorValidationText.isEmpty &&
        _mp3ErrorValidationText.isEmpty &&
        _artistErrorValidationText.isEmpty &&
        _albumErrorValidationText.isEmpty;
  }

  void validateSongInputs() {
    _nameErrorValidationText =
        _nameController.text.isEmpty ? "Name cannot be empty" : "";
    _artistErrorValidationText = _artists.isEmpty ? "Please select Artist" : "";
    _albumErrorValidationText = _album == null ? "Please select Album" : "";
    _mp3ErrorValidationText =
        _mp3File["filename"]!.isEmpty ? "Please select MP3 File" : "";
    _pictureErrorValidationText =
        _pictureFile["filename"]!.isEmpty ? "Please select Picture File" : "";
  }

  Future<String> loadBase64StringLyric() async {
    String base64 = "";
    String url = Song.getUrlLyric(_song.id);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
      print("base64:$base64");
    } else {
      throw Exception('Failed to load Lyric');
    }
    return base64;
  }

  Future<String> loadBase64StringMp3() async {
    String base64 = "";
    String url = Song.getUrlMp3(_song.id);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
    } else {
      throw Exception('Failed to load mp3');
    }
    return base64;
  }

  Future<String> loadBase64StringPicture() async {
    String base64 = "";
    String url = Song.getUrlImg(_song.picture, _song.id);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      base64 = base64Encode(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
    return base64;
  }

  Future<Album?> getAlbumFromApi() async {
    final result =
        await ServiceManager.albumService.getAlbumById(_song.album_id);
    if (result["message"] == "OK") {
      return Album.fromJson(result["data"]);
    }
    return null;
  }

  Future<List<int>> getGenreIdsByNames() async {
    List<int> genreIds = [];
    List<Genre> allGenres =
        await ModelviewsManager.genreModelview.getAllGenres();
    for (var genre in allGenres) {
      if (_genreNames.contains(genre.name)) {
        genreIds.add(genre.id);
      }
    }
    return genreIds;
  }

  Future<List<int>> getTopicIdsByNames() async {
    List<int> topicIds = [];
    List<Topic> allTopics =
        await ModelviewsManager.topicModelviews.getAllTopics();
    for (var topic in allTopics) {
      if (_topicNames.contains(topic.name)) {
        topicIds.add(topic.id);
      }
    }
    return topicIds;
  }

  Future<void> createSongState() async {
    if (widget.mode != 0) {
      final results = await Future.wait([
        getAlbumFromApi(),
        loadBase64StringPicture(),
        loadBase64StringMp3(),
        loadBase64StringLyric(),
      ]);

      setState(() {
        _nameController.text = _song.name;
        _lyricController.text = _song.lyric;
        _artists = _song.artists;

        _album = results[0] as Album?;
        _pictureFile = {
          "filename": _song.picture,
          "base64Data": results[1] as String,
        };
        _mp3File = {
          "filename": "${_song.name}.mp3",
          "base64Data": results[2] as String,
        };
        _genres = _song.genres;
        _genreNames = _genres.map((g) => g.name).toList();
        _topics = _song.topics;
        _topicNames = _topics.map((t) => t.name).toList();
        //_lyricBase64SRC = results[3] as String;
        _lyricBase64String = results[3] as String;
        _lyricFileName = "${_song.id}.txt";

        _imageSrc = "data:image/jpeg;base64,${results[1]}";
        _audioSrc = 'data:audio/mpeg;base64,${results[2]}';
      });
    }
  }

  // State initialization
  @override
  void initState() {
    //Prepare State
    mode = widget.mode;
    switch (mode) {
      case 0:
        _titleDialog = "Create New Song";
        _subtitleDialog = "Fill out the form, then click confirm";
        break;
      case 1:
        _titleDialog = "Edit Song";
        _subtitleDialog = "Click confirm when all is corrected";
      case 2:
        _titleDialog = "Song Details";
        _subtitleDialog = "Hmm... Details!";
    }
    if (widget.mode != 0) {
      _song = widget.song!;
    }
    _createSongState = createSongState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = widget.rss;
    return FutureBuilder<void>(
      future: _createSongState,
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
          double textBoxWidth = rss.u * 50;
          double textBoxHeight = rss.u * 13;
          return FeatureDialog(
            rss: rss,
            title: _titleDialog,
            subTittle: _subtitleDialog,
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
                    controller: _lyricController,
                    label: "Lyric",
                    isFlexibleHeight: true,
                    isReadOnly: true,
                  ),
                  SizedBox(height: rss.u * 5),
                  _buildArtistSelection(
                      context, rss, textBoxWidth, textBoxHeight),
                  if (_artistErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _artistErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  _buildAlbumSelection(
                      context, rss, textBoxWidth, textBoxHeight),
                  if (_albumErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _albumErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  _buildFilePicker(
                      context,
                      rss,
                      textBoxWidth,
                      textBoxHeight,
                      "Lyric File",
                      pickLyricFile,
                      _lyricBase64String,
                      _lyricFileName),
                  if (_lyricErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _lyricErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  _buildRecommendedProbabilityList(
                    context: context,
                    rss: rss,
                    textBoxWidth: textBoxWidth,
                    textBoxHeight: textBoxHeight,
                    label: "Add Topic",
                    onTap: () {
                      showDialogAndUpdateState<List<String>>(
                        context: context,
                        pageBuilder: (context) => MultipleAdd(
                          data: _topicNames,
                          base64String: _lyricBase64String,
                          type: "topic",
                        ),
                        onUpdate: (selectedItems) {
                          if (selectedItems != null) {
                            setState(() {
                              _topicNames = selectedItems;
                              _topicErrorValidationText = "";
                            });
                          }
                        },
                      );
                    },
                    fileName: _lyricFileName,
                    objects: _topics,
                    stringDisplay: _topicNames
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''),
                  ),
                  SizedBox(height: rss.u * 5),
                  _buildFilePicker(
                      context,
                      rss,
                      textBoxWidth,
                      textBoxHeight,
                      "MP3 File",
                      pickMP3File,
                      _audioSrc,
                      _mp3File["filename"] ?? ""),
                  if (_mp3ErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _mp3ErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  _buildRecommendedProbabilityList(
                    context: context,
                    rss: rss,
                    textBoxWidth: textBoxWidth,
                    textBoxHeight: textBoxHeight,
                    label: "Add Genre",
                    onTap: () {
                      showDialogAndUpdateState<List<String>>(
                        context: context,
                        pageBuilder: (context) => MultipleAdd(
                          data: _genreNames,
                          base64String: _mp3File['base64Data'].toString(),
                          type: "genre",
                        ),
                        onUpdate: (selectedItems) {
                          if (selectedItems != null) {
                            setState(() {
                              _genreNames = selectedItems;
                              _genreErrorValidationText = "";
                            });
                          }
                        },
                      );
                    },
                    fileName: _mp3File["filename"].toString(),
                    objects: _genres,
                    stringDisplay: _genreNames
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''),
                  ),
                  SizedBox(height: rss.u * 5),
                  _buildFilePicker(
                      context,
                      rss,
                      textBoxWidth,
                      textBoxHeight,
                      "Photo File",
                      pickImageFile,
                      _imageSrc,
                      _pictureFile["filename"] ?? ""),
                  if (_pictureErrorValidationText.isNotEmpty)
                    _buildErrorText(rss, _pictureErrorValidationText),
                  SizedBox(height: rss.u * 5),
                  if (_imageSrc.isNotEmpty) _buildImagePreview(rss),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRecommendedProbabilityList({
    required BuildContext context,
    required RSS rss,
    required double textBoxWidth,
    required double textBoxHeight,
    required String label,
    required Function onTap,
    required String fileName,
    required List<dynamic> objects,
    required String stringDisplay,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          AbsorbPointer(
            absorbing: fileName.isEmpty,
            child: PushdownGesturedetector(
              bgColor: fileName.isEmpty
                  ? const Color(0x7B388681)
                  : const Color(0xFF4FD1C5),
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
                stringDisplay.isNotEmpty
                    ? stringDisplay.replaceAll(']', '').replaceAll('[', '')
                    : "None are selected",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: rss.u * (objects.isNotEmpty ? 7 : 7),
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

  Widget _buildArtistSelection(BuildContext context, RSS rss,
      double textBoxWidth, double textBoxHeight) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          PushdownGesturedetector(
            elevation: rss.u * 1,
            onTapDownElevation: rss.u * 2,
            radius: rss.u * 10,
            bgColor: const Color(0xFF4FD1C5),
            onTap: () {
              showDialogAndUpdateState<List<Artist>>(
                context: context,
                pageBuilder: (context) => AddArtistsForSong(artists: _artists),
                onUpdate: (artists) {
                  print("onUpdate: ${artists}");
                  _artists = artists;
                  if (artists.isNotEmpty) {
                    _artistErrorValidationText = "";
                    _album = null;
                  }
                },
              );
            },
            child: TextContentBox(
              width: textBoxWidth,
              height: textBoxHeight,
              text: "Artist",
            ),
          ),
          SizedBox(width: rss.u * 5),
          Expanded(
            child: Container(
              height: rss.u * 16,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                  rss.u * 5, rss.u * 2, rss.u * 5, rss.u * 2),
              decoration: BoxDecoration(
                border: Border.all(
                    width: rss.u * 0.5, color: const Color(0xFF4FD1C5)),
                borderRadius: BorderRadius.circular(rss.u * 10),
              ),
              child: _artists.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: rss.u * 5,
                        children: _artists.map((artist) {
                          return Container(
                            width: rss.u * 12,
                            height: rss.u * 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(Artist.getUrlImg(
                                    artist.picture, artist.id)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Text(
                      "None are selected",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w300,
                        fontSize: rss.u * 6,
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

  Widget _buildAlbumSelection(BuildContext context, RSS rss,
      double textBoxWidth, double textBoxHeight) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          AbsorbPointer(
            absorbing: _artists.isEmpty,
            child: PushdownGesturedetector(
              elevation: rss.u * 1,
              onTapDownElevation: rss.u * 2,
              radius: rss.u * 10,
              bgColor: _artists.isEmpty
                  ? const Color(0x7B388681)
                  : const Color(0xFF4FD1C5),
              onTap: () {
                showDialogAndUpdateState<Album>(
                  context: context,
                  pageBuilder: (context) => ChooseAlbum(artists: _artists),
                  onUpdate: (alb) {
                    _album = alb;
                    if (alb != null) {
                      _albumErrorValidationText = "";
                    }
                  },
                );
              },
              child: TextContentBox(
                width: textBoxWidth,
                height: textBoxHeight,
                text: "Album",
              ),
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
                _album != null ? _album!.name : "None are selected",
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
          if (label == "MP3 File") ...[
            Expanded(
              child: fileSrc.isNotEmpty
                  ? CustomMusicPlayer(
                      audioUrl: fileSrc,
                    )
                  : Container(
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
                        "None are selected",
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
          ] else ...[
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
          ]
        ],
      ),
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

  Widget _buildImagePreview(RSS rss) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: rss.u * 120,
          height: rss.u * 120,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: rss.u * 5),
          child: Image.network(_imageSrc, fit: BoxFit.fill),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _imageSrc = "";
                _pictureFile["base64Data"] = "";
                _pictureFile["filename"] = "";
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
          fontSize: rss.u * 8,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

class CustomMusicPlayer extends StatefulWidget {
  final String audioUrl;

  CustomMusicPlayer({required this.audioUrl});

  @override
  _CustomMusicPlayerState createState() => _CustomMusicPlayerState();
}

class _CustomMusicPlayerState extends State<CustomMusicPlayer> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 0.1;
  bool isPlaying = false;

  @override
  void didUpdateWidget(covariant CustomMusicPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the audio URL has changed
    if (oldWidget.audioUrl != widget.audioUrl) {
      _initializeAudioPlayer(
          widget.audioUrl); // Reinitialize the audio player with the new URL
    }
  }

  // Method to initialize or reinitialize the audio player
  void _initializeAudioPlayer(String url) {
    // Stop the current audio player
    _audioPlayer.stop();
    // Reset the state variables
    setState(() {
      _duration = Duration.zero;
      _position = Duration.zero;
      isPlaying = false;
    });

    if (url.isNotEmpty) {
      _audioPlayer.setSourceUrl(url).then((_) async {
        // Get the duration of the audio file
        final duration = await _audioPlayer.getDuration();
        if (mounted) {
          setState(() {
            _duration = duration as Duration; // Update the duration state
          });
        }

        // Listen for duration changes
        _audioPlayer.onDurationChanged.listen((Duration d) {
          if (mounted) {
            setState(() {
              _duration = d; // Update the duration state
            });
          }
        });

        // Listen for position changes
        _audioPlayer.onPositionChanged.listen((Duration p) {
          if (mounted) {
            setState(() {
              _position = p; // Update the position state
            });
          }
        });
      }).catchError((error) {
        print('Error setting URL: $error'); // Handle error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer(
        widget.audioUrl); // Initialize the audio player with the initial URL
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(widget.audioUrl), volume: 0.1);
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: rss.u * 8,
              ),
              onPressed: _playPause,
            ),
            Expanded(
              flex: 6,
              child: Slider(
                activeColor: const Color(0xFF4FD1C5),
                inactiveColor: Colors.grey,
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  });
                },
              ),
            ),
            Text(_formatDuration(_position)),
            const Text('/'),
            Text(_formatDuration(_duration)),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.volume_down),
            ),
            Expanded(
              child: Slider(
                activeColor: const Color(0xFF4FD1C5),
                inactiveColor: Colors.grey,
                value: _volume,
                min: 0,
                max: 1,
                onChanged: (double value) {
                  setState(() {
                    _volume = value;
                    _audioPlayer.setVolume(_volume);
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.volume_up),
            ),
          ],
        ),
      ],
    );
  }
}
