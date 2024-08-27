import 'package:app/configs/rss.dart';
import 'package:flutter/material.dart';

class ContentFrame extends StatefulWidget {
  Widget child;

  ContentFrame({super.key, required this.child});

  @override
  State<ContentFrame> createState() => _ContentFrameState();
}

class _ContentFrameState extends State<ContentFrame> {
  RSS rss = RSS();

  @override
  Widget build(BuildContext context) {
    rss.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(rss.u * 5, 0, rss.u * 5, rss.u * 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(rss.u * 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, rss.u * 1),
            blurRadius: rss.u * 1,
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
