import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/album.dart';
import '../models/artist.dart';

class FeatureSongState {
  TextEditingController nameController = TextEditingController();
  TextEditingController lyricController = TextEditingController();
  int id = -1;
  String nameErrorValidationText = "";
  String artistErrorValidationText = "";
  String mp3ErrorValidationText = "";
  String pictureErrorValidationText = "";
  String albumErrorValidationText = "";
  int duration = 0;
  Map<String, String> pictureFile = {"filename": "", "base64Data": ""};
  Map<String, String> mp3File = {"filename": "", "base64Data": ""};
  List<Artist> artists = [];

  List<Album> albumsOfArtists = [];

  Album? album;

  FeatureSongState();

  // Copy constructor
  FeatureSongState.copy(FeatureSongState original) {
    nameController.text = original.nameController.text;
    lyricController.text = original.lyricController.text;
    id = original.id;
    nameErrorValidationText = original.nameErrorValidationText;
    artistErrorValidationText = original.artistErrorValidationText;
    mp3ErrorValidationText = original.mp3ErrorValidationText;
    pictureErrorValidationText = original.pictureErrorValidationText;
    albumErrorValidationText = original.albumErrorValidationText;
    duration = original.duration;
    pictureFile = Map<String, String>.from(original.pictureFile);
    mp3File = Map<String, String>.from(original.mp3File);
    artists = List<Artist>.from(original.artists);
    albumsOfArtists = List<Album>.from(original.albumsOfArtists);
    album = original.album;
  }

  @override
  String toString() {
    return 'FeatureSongState{pictureFile: $pictureFile, mp3File: $mp3File}';
  }
}
