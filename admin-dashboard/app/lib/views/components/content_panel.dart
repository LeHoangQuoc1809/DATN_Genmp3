import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/rss.dart';
import '../../models/song.dart';
import 'actions_button_row.dart';

class ContentPanel extends StatefulWidget {
  final List<Song> songs;

  final Future<void> Function(Song)? onTapDelete;

  final Future<void> Function(Song)? onTapEdit;

  final Future<void> Function(Song)? onTapDetail;

  const ContentPanel({
    super.key,
    required this.songs,
    this.onTapDelete,
    this.onTapEdit,
    this.onTapDetail,
  });

  @override
  State<ContentPanel> createState() => _ContentPanelState();
}

class _ContentPanelState extends State<ContentPanel> {
  @override
  Widget build(BuildContext context) {
    RSS rss = RSS();
    rss.init(context);

    return Column(
      children: [
        // Header Row
        _buildTableHeaderRow(rss: rss, headers: headers),
        // Content Rows
        Expanded(
          child: ListView.builder(
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              return _buildTableContentRow(
                rss: rss,
                song: widget.songs[index],
                onTapDelete: widget.onTapDelete,
                onTapEdit: widget.onTapEdit,
                onTapDetail: widget.onTapDetail,
                bgColor: index % 2 == 0 ? const Color(0xc8eceff3) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  List<String> headers = Song.getFields()
    ..add("Actions");

  Widget _buildTableHeaderRow(
      {required RSS rss, required List<String> headers, Color? bgColor}) {
    return Container(
      padding: EdgeInsets.only(
        top: rss.u * 2,
        bottom: rss.u * 2,
      ),
      child: Row(
        children: headers.map((header) {
          int flex = 0;
          switch (header) {
            case "id":
              flex = 1;
              break;
            case "picture":
              flex = 3;
              break;
            case "name":
              flex = 6;
              break;
            case "LC":
              flex = 2;
              break;
            default:
              flex = 5;
              break;
          }
          return Expanded(
            flex: flex,
            child: Container(
              padding: EdgeInsets.all(rss.u * 2),
              alignment: header == "Actions" || header == "picture"
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Text(
                header.toUpperCase(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: rss.u * 8,
                  color: const Color(0xffA0AEC0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableContentRow({
    required RSS rss,
    required Song song,
    Future<void> Function(Song)? onTapDelete,
    Future<void> Function(Song)? onTapEdit,
    Future<void> Function(Song)? onTapDetail,
    Color? bgColor = Colors.transparent,
  }) {
    TextStyle styleContentRow = GoogleFonts.roboto(
      fontSize: rss.u * 7,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF2D3748),
    );
    EdgeInsets edgeInsets = EdgeInsets.only(left: rss.u * 5, right: rss.u * 5);
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: rss.u * 0.5,
            color: const Color(0xFFE2E8F0),
          ),
          SizedBox(
            height: rss.u * 5,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: rss.u * 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        Song.getUrlImg(song.picture, song.id),
                      ),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(
                        rss.u * 10), // optional, for rounded corners
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.id.toString(),
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.name,
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.artists?.map((artist) => artist.name).join(', ') ?? "",
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    song.listenCount.toString(),
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ActionsButtonRow(
                  onTapDelete: onTapDelete != null
                      ? (object) => onTapDelete!(object as Song)
                      : null,
                  onTapEdit: onTapEdit != null
                      ? (object) => onTapEdit!(object as Song)
                      : null,
                  onTapDetail: onTapDetail != null
                      ? (object) => onTapDetail!(object as Song)
                      : null,
                  object: song,
                  paddingAllRow: EdgeInsets.all(rss.u * 2),
                ),
              ),
            ],
          ),
          SizedBox(
            height: rss.u * 5,
          ),
        ],
      ),
    );
  }
}
