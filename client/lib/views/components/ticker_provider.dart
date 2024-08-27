import 'package:flutter/material.dart';

class CustomTickerProvider extends StatefulWidget {
  final Widget child;

  CustomTickerProvider({required this.child});

  @override
  _CustomTickerProviderState createState() => _CustomTickerProviderState();

  static _CustomTickerProviderState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CustomTickerProviderState>();
  }
}

class _CustomTickerProviderState extends State<CustomTickerProvider> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
