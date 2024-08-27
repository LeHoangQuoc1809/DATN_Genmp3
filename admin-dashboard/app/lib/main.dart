import 'package:flutter/material.dart';

import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth <= 640)
      {
        widget = MobileLayout();
      }
      else if( constraints.maxWidth <= 1024)
      {
        widget = TabletLayout();
      }
      else
      {
        widget = DesktopLayout();
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget ,
        );


    },);
  }
}
