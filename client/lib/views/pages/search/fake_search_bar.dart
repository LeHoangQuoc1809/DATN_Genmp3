import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/device_size_config.dart';
import '../../../models/genre_model.dart';
import '../../../models/song_model.dart';
import '../../../models/topic_model.dart';
import 'loading_tag_display.dart';

class FakeSearchBar extends StatefulWidget {
  Function onTap;

  FakeSearchBar({super.key, required this.onTap});

  @override
  State<FakeSearchBar> createState() => _FakeSearchBarState();
}

class _FakeSearchBarState extends State<FakeSearchBar> {
  bool _isPressed = false;

  void _handleTap() {
    setState(() {
      _isPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _isPressed = false;
      });
      print("on Search Tap");
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          padding: EdgeInsets.all(_isPressed ? 2 : 0),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 217, 217),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, _isPressed ? 1 : 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                    15.w,
                    0.h,
                    7.w,
                    0.h,
                  ),
                  child: Image.asset(
                    'assets/images/ic-search1.png',
                    width: 26.w,
                    height: 26.h,
                    color: const Color.fromARGB(255, 138, 154, 157),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Songs, Artists & More',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'CenturyGothicRegular',
                      color: const Color.fromARGB(255, 138, 154, 157),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
