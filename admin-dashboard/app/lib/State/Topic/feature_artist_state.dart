import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FeatureArtistState {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String nameErrorValidationText = "", _descriptionErrorValidationText = "";
  Map<String, String> file = {"filename": "", "base64Data": ""};

  FeatureArtistState();

  get descriptionErrorValidationText => _descriptionErrorValidationText;

  set descriptionErrorValidationText(value) {
    _descriptionErrorValidationText = value;
  }
}
