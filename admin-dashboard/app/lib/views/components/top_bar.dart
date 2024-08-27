import 'package:app/configs/rss.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({Key? key, this.appBarHeight = kToolbarHeight}) : super(key: key);
  final double appBarHeight;

  void onpressedSettingIcon() {}

  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);
    TextStyle titleStyle = TextStyle(
      fontSize: rss.u * 7,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF2D3748),
    );
    return AppBar(
      toolbarHeight: appBarHeight,
      title: Container(
        child: Row(
          children: [
            Image.asset(
              "assets/images/favicon.png",
              width: rss.u * 18,
            ),
            SizedBox(
              width: rss.u * 3,
            ),
            AutoSizeText(
              "Admin-Dashboard",
              style: titleStyle,
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.gear,
            color: const Color(0xFF2D3748),
            size: rss.u * 8,
          ),
          onPressed: onpressedSettingIcon,
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appBarHeight); // AppBar's default height
}
