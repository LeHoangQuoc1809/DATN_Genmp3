import 'dart:async';

import 'package:app/configs/rss.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'PushDown_GestureDetector.dart';

class ActionsButtonRow extends StatefulWidget {
  ActionsButtonRow({
    Key? key,
    this.rss,
    this.onTapDelete,
    this.onTapEdit,
    this.onTapDetail,
    this.paddingAllRow,
    this.object,
  }) : super(key: key);

  final RSS? rss;
  final Future<void> Function(dynamic)? onTapDelete;
  final Future<void> Function(dynamic)? onTapEdit;
  final Future<void> Function(dynamic)? onTapDetail;
  final EdgeInsets? paddingAllRow;
  dynamic? object;

  @override
  State<ActionsButtonRow> createState() => _ActionsButtonRowState();
}

class _ActionsButtonRowState extends State<ActionsButtonRow> {
  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    //
    double boxWidth = rss.u * 15;
    double boxHeight = rss.u * 10;
    double textFontSize = rss.u * 5;
    FontWeight textFontWeight = FontWeight.w600;
    Color textColor = const Color(0xFFFFFFFF);
    //
    return Container(
      padding: widget.paddingAllRow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.onTapDelete != null)
            PushdownGesturedetector(
              elevation: rss.u * 1,
              onTapDownElevation: rss.u * 2,
              radius: rss.u * 8,
              onTap: () => widget.onTapDelete!(widget.object),
              bgColor: const Color(0xFFDA0707),
              child: Container(
                width: boxWidth,
                height: boxHeight,
                alignment: Alignment.center,
                child: Text(
                  "Delete",
                  style: GoogleFonts.roboto(
                    fontSize: textFontSize,
                    fontWeight: textFontWeight,
                    color: textColor,
                  ),
                ),
              ),
            ),
          if (widget.onTapEdit != null)
            SizedBox(
              width: rss.u * 2,
            ),
          if (widget.onTapEdit != null)
            PushdownGesturedetector(
              elevation: rss.u * 1,
              onTapDownElevation: rss.u * 2,
              radius: rss.u * 8,
              onTap: () => widget.onTapEdit!(widget.object),
              bgColor: const Color(0xFF088DD3),
              child: Container(
                alignment: Alignment.center,
                width: boxWidth,
                height: boxHeight,
                child: Text(
                  "Edit",
                  style: GoogleFonts.roboto(
                    fontSize: textFontSize,
                    fontWeight: textFontWeight,
                    color: textColor,
                  ),
                ),
              ),
            ),
          if (widget.onTapDetail != null)
            SizedBox(
              width: rss.u * 2,
            ),
          if (widget.onTapDetail != null)
            PushdownGesturedetector(
              elevation: rss.u * 1,
              onTapDownElevation: rss.u * 2,
              radius: rss.u * 8,
              onTap: () => widget.onTapDetail!(widget.object),
              bgColor: const Color(0xFFE6EBEF),
              child: Container(
                alignment: Alignment.center,
                width: boxWidth,
                height: boxHeight,
                child: Text(
                  "Detail",
                  style: GoogleFonts.roboto(
                    fontSize: textFontSize,
                    fontWeight: textFontWeight,
                    color: const Color(0xFF020228),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
