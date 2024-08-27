import 'package:app/configs/rss.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureDialog extends StatefulWidget {
  final RSS rss;

  final String title;

  final String subTittle;

  final Function confirmEvent;

  final Widget child;

  const FeatureDialog({
    super.key,
    required this.rss,
    required this.title,
    required this.confirmEvent,
    this.subTittle = "",
    required this.child,
  });

  @override
  State<FeatureDialog> createState() => _FeatureDialogState();
}

class _FeatureDialogState extends State<FeatureDialog> {
  void onPressedConfirm(BuildContext context) async {
    widget.confirmEvent();
  }

  // State initialization
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return AlertDialog(
      title: buildTitle(rss),
      content: Container(
        width: rss.u * 200,
        height: rss.u * 200,
        child: widget.child,
      ),
      actions: <Widget>[
        buildCancelButton(rss),
        buildConfirmButton(rss),
      ],
    );
  }

  Widget buildTitle(RSS rss) {
    return Container(
      width: rss.u * 150,
      height: rss.u * 35,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: rss.u * 18,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF4FD1C5)),
          ),
          Text(
            widget.subTittle,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.normal,
                fontSize: rss.u * 4,
                color: const Color(0xFFA0AEC0)),
          ),
        ],
      ),
    );
  }

  Widget buildCancelButton(RSS rss) {
    return Container(
      width: rss.u * 35,
      height: rss.u * 15,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rss.u * 8),
            side:
                BorderSide(color: const Color(0xFF4FD1C5), width: rss.u * 0.5),
          ),
        ),
        child: Text(
          'Cancel',
          style: GoogleFonts.roboto(
              fontSize: rss.u * 6,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4FD1C5)),
        ),
        onPressed: () {
          Navigator.of(context).pop(0);
        },
      ),
    );
  }

  Widget buildConfirmButton(RSS rss) {
    return Container(
      width: rss.u * 35,
      height: rss.u * 15,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF4FD1C5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rss.u * 8),
          ),
        ),
        child: Text(
          'Confirm',
          style: GoogleFonts.roboto(
              fontSize: rss.u * 6,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFFFFFF)),
        ),
        onPressed: () {
          onPressedConfirm(context);
        },
      ),
    );
  }
}
