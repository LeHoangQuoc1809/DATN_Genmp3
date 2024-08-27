import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/rss.dart';

class WarningDeleteDialog extends StatefulWidget {
  final RSS rss;
  final String title;
  final dynamic object;
  bool isConstrained;
  bool canBeDeleted;
  final confirmEvent;
  Widget constrainedListWidget;

  WarningDeleteDialog({
    Key? key,
    required this.rss,
    required this.title,
    required this.object,
    this.isConstrained = false,
    this.constrainedListWidget = const Text(""),
    required this.confirmEvent,
    this.canBeDeleted = true,
  }) : super(key: key);

  @override
  State<WarningDeleteDialog> createState() => _WarningDeleteDialogState();
}

class _WarningDeleteDialogState extends State<WarningDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return AlertDialog(
      title: Container(
        height: rss.u * 20,
        width: rss.u * 150,
        child: AutoSizeText(
          widget.title,
          maxLines: 2,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: rss.u * 30,
            color: Colors.red,
          ),
        ),
      ),
      titlePadding:
          EdgeInsets.fromLTRB(rss.u * 5, rss.u * 12, rss.u * 5, rss.u * 0),
      content: Container(
        width: rss.u * 150,
        height: widget.isConstrained ? rss.u * 45 : rss.u * 30,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                widget.object.name,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: rss.u * 10,
                  color: const Color(0xFF2D3748),
                ),
                minFontSize: rss.u * 0.5 * 5,
                stepGranularity: rss.u * 0.5,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
              SizedBox(
                height: rss.u * 5,
              ),
              widget.constrainedListWidget,
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          width: rss.u * 35,
          height: rss.u * 15,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                // Specifies the shape of the button's border
                borderRadius: BorderRadius.circular(rss.u * 8),
                // Rounded corners with a radius of 8
                side: BorderSide(
                  color: Colors.red, // Color of the border
                  width: rss.u * 0.5, // Width of the border
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                fontSize: rss.u * 6,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
        ),
        if (widget.canBeDeleted)
          Container(
            width: rss.u * 35,
            height: rss.u * 15,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  // Specifies the shape of the button's border
                  borderRadius: BorderRadius.circular(rss.u * 8),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.roboto(
                  fontSize: rss.u * 6,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
              onPressed: () {
                confirmEvent(context);
              },
            ),
          ),
      ],
    );
  }

  void confirmEvent(BuildContext context) async {
    await widget.confirmEvent(widget.object);
    Navigator.of(context).pop(1);
  }
}
