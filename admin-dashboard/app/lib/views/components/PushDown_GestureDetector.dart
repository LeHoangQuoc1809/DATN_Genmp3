import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/rss.dart';

class PushdownGesturedetector extends StatefulWidget {
  PushdownGesturedetector({
    Key? key,
    required this.elevation,
    required this.child,
    required this.onTapDownElevation,
    required this.radius,
    required this.onTap,
    this.bgColor = const Color(0xFF48BB78),
    this.isEnable = true,

  }) : super(key: key);

  Widget child;
  double elevation;
  double onTapDownElevation;
  double radius;
  final onTap;
  Color bgColor;
  bool isEnable;

  @override
  State<PushdownGesturedetector> createState() =>
      _PushdownGesturedetectorState();
}

class _PushdownGesturedetectorState extends State<PushdownGesturedetector> {
  double elevation = 0,
      onTapDownElevation = 0;

  @override
  void initState() {
    super.initState();
    elevation = widget.elevation;
    onTapDownElevation = widget.onTapDownElevation;
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return AbsorbPointer(
      absorbing: !widget.isEnable,
      child: GestureDetector(
        onTapDown: (_) =>
            setState(() {
              elevation = onTapDownElevation;
            }),
        onTapUp: (_) =>
            setState(() {
              elevation = widget.elevation;
            }),
        onTapCancel: () =>
            setState(() {
              elevation = widget.elevation;
            }),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding:
            EdgeInsets.fromLTRB(rss.u * 5, rss.u * 2, rss.u * 5, rss.u * 2),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, elevation),
                  blurRadius: elevation,
                ),
              ],
            ),
            child: widget.child,
            // AutoSizeText(
            //   "Delete",
            //   style: GoogleFonts.roboto(
            //       fontSize: rss.u * 5,
            //       fontWeight: FontWeight.w500,
            //       color: const Color(0xFFFFFFFF)),
            // ),
          ),
        ),
      ),
    );
  }
}
