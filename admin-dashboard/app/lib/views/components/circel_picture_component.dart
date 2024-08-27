import 'package:flutter/material.dart';

import '../../configs/rss.dart';
import 'package:http/http.dart' as http;

class CircelPictureComponent extends StatefulWidget {
  String src;
  RSS rss;
  int flex;
  String srcDefault;

  CircelPictureComponent(
      {super.key,
      required this.rss,
      required this.flex,
      required this.src,
      this.srcDefault = ""});

  @override
  State<CircelPictureComponent> createState() => _CircelPictureComponentState();
}

class _CircelPictureComponentState extends State<CircelPictureComponent> {
  RSS rss = RSS();
  int flex = 3;
  bool isChecked = false;

  Future testGetPicture() async {
    try {
      final response = await http.get(Uri.parse(widget.src));
      if (response.statusCode == 200) {
        setState(() {
          isChecked = true;
        });
      }
    } catch (e) {
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rss = widget.rss;
    flex = widget.flex;
    testGetPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: rss.u * 25,
          width: rss.u * 25,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            image: DecorationImage(
              image: NetworkImage(isChecked ? widget.src : widget.srcDefault),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(rss.u * 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, rss.u * 1),
                blurRadius: rss.u * 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
