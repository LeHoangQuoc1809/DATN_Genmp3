import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EffectTap extends StatefulWidget {
  final Widget child;

  final Function onTap;

  double radius;

  int miliDuration;

  Color color;

  Color toColor;

  double paddingAll;

  EffectTap({
    Key? key,
    required this.child,
    required this.onTap,
    this.radius = 0,
    this.miliDuration = 200,
    this.color = Colors.transparent,
    this.paddingAll = 0,
    this.toColor = Colors.transparent,
  }) : super(key: key);

  @override
  _EffectTapState createState() => _EffectTapState();
}

class _EffectTapState extends State<EffectTap> {
  bool _isTapped = false;

  Timer _tapTimer = Timer(Duration(milliseconds: 40), () {});

  @override
  void dispose() {
    _tapTimer.cancel(); // Hủy bỏ timer khi dispose widget
    super.dispose();
  }

  void _startTapAnimation() {
    setState(() {
      _isTapped = true;
    });
    _tapTimer = Timer(Duration(milliseconds: widget.miliDuration ~/ 5), () {
      setState(() {
        _isTapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _startTapAnimation();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.miliDuration),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: _isTapped ? widget.toColor : widget.color,
        ),
        padding: EdgeInsets.all(widget.paddingAll.r),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
