import 'dart:ui';
import 'package:client/models/artist_model.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaddingAnimationWidget extends StatefulWidget {
  Function onTap;
  int miliDuration;
  double paddingAnimation;
  Widget child;

  PaddingAnimationWidget({
    super.key,
    required this.onTap,
    required this.miliDuration,
    this.paddingAnimation = 1,
    required this.child,
  });

  @override
  State<PaddingAnimationWidget> createState() => _PaddingAnimationWidgetState();
}

class _PaddingAnimationWidgetState extends State<PaddingAnimationWidget> {
  bool _isPressed = false;

  void _handleTap() {
    setState(() {
      _isPressed = true;
    });
    Future.delayed(Duration(milliseconds: widget.miliDuration), () {
      setState(() {
        _isPressed = false;
      });
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.miliDuration),
        padding: EdgeInsets.all(_isPressed ? widget.paddingAnimation : 0),
        child: widget.child,
      ),
    );
  }
}
