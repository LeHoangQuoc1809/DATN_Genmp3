import 'package:flutter/material.dart';

class RSS {
  late double _screenWidth;
  late double _screenHeight;
  late double _blockSizeHorizontal;
  late double _blockSizeVertical;

  late double _safeAreaHorizontal;
  late double _safeAreaVertical;
  late double _safeBlockHorizontal;
  late double _safeBlockVertical;
  late double _u;

  RSS();

  double get screenWidth => _screenWidth;

  double get u => _u;

  void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;
    _u = (_screenWidth + _screenHeight) / 1000;
    _safeAreaHorizontal = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    _safeAreaVertical = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
  }

  double get screenHeight => _screenHeight;

  double get blockSizeHorizontal => _blockSizeHorizontal;

  double get blockSizeVertical => _blockSizeVertical;

  double get safeAreaHorizontal => _safeAreaHorizontal;

  double get safeAreaVertical => _safeAreaVertical;

  double get safeBlockHorizontal => _safeBlockHorizontal;

  double get safeBlockVertical => _safeBlockVertical;
}
