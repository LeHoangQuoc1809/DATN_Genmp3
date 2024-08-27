import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/rss.dart';

class InputBox extends StatefulWidget {
  InputBox({
    Key? key,
    this.label = "Label",
    this.width = 0,
    this.height = 0,
    this.padding = const EdgeInsets.all(0),
    required this.controller,
    this.requirement = false,
    this.errorText = "",
    this.isFlexibleHeight = false,
    this.isReadOnly = false,
  }) : super(key: key);

  String label;

  double width;

  double height;

  bool isReadOnly;

  final padding;

  bool requirement;

  String errorText;

  TextEditingController controller;

  bool isFlexibleHeight;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(0, rss.u * 3, 0, rss.u * 3),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: rss.u * 4),
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              widget.label,
              style: GoogleFonts.roboto(
                fontSize: rss.u * 7,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
          SizedBox(
            height: rss.u * 1,
          ),
          Container(
            width: double.infinity,
            height: rss.u *
                20 *
                (widget.isFlexibleHeight
                    ? (widget.controller.text.length / 58).toInt() + 1
                    : 1),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(rss.u * 8),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: rss.u * 0.5,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                  rss.u * 10,
                  rss.u * 5,
                  rss.u * 10,
                  rss.u * 5, // Added consistent bottom padding,
                ),
                border: InputBorder.none,
                hintText: "Your ${widget.label}",
                hintStyle: GoogleFonts.roboto(
                    color: const Color(0xFFA0AEC0),
                    fontSize: rss.u * 8,
                    fontWeight: FontWeight.normal),
                suffixIcon: widget.requirement && widget.controller.text.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: rss.u * 5,
                          bottom: rss.u * 5,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.asterisk,
                          size: rss.u * 6,
                          color: Colors.red,
                        ),
                      )
                    : null,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              readOnly: widget.isReadOnly,
              style: GoogleFonts.roboto(
                  color: const Color(0xFF2D3748),
                  fontSize: rss.u * 8,
                  fontWeight: FontWeight.normal),
              controller: widget.controller,
              onChanged: (text) => {
                setState(() {
                  widget.errorText = "";
                }),
              },
            ),
          ),
          SizedBox(
            height: rss.u * 1,
          ),
          if (widget.errorText.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: rss.u * 5),
              child: AutoSizeText(
                widget.errorText,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: rss.u * 5,
                  color: Colors.red.shade700,
                ),
              ),
            )
        ],
      ),
    );
  }
}
