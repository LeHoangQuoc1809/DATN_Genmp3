import 'package:flutter/material.dart';

class FeatureTopicState {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _nameErrorValidationText = "", _descriptionErrorValidationText = "";

  FeatureTopicState();

  get descriptionErrorValidationText => _descriptionErrorValidationText;

  set descriptionErrorValidationText(value) {
    _descriptionErrorValidationText = value;
  }

  String get nameErrorValidationText => _nameErrorValidationText;

  set nameErrorValidationText(String value) {
    _nameErrorValidationText = value;
  }

  TextEditingController get descriptionController => _descriptionController;

  set descriptionController(TextEditingController value) {
    _descriptionController = value;
  }

  TextEditingController get nameController => _nameController;

  set nameController(TextEditingController value) {
    _nameController = value;
  }
}
