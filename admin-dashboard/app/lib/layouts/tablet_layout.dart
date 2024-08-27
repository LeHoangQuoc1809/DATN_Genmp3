import 'package:flutter/material.dart';

class TabletLayout extends StatefulWidget {
  const TabletLayout({super.key});

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "TABLET LAYOUT",
      ),
    );
  }
}

