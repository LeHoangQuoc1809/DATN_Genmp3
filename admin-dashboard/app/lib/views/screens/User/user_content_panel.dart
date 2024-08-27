import 'package:app/models/user.dart';
import 'package:app/views/components/circel_picture_component.dart';
import 'package:app/views/screens/Topic/topic_feature_dialog.dart';
import 'package:app/views/screens/User/user_feature_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/rss.dart';
import '../../../modelViews/modelViews_mng.dart';
import '../../../models/user.dart';
import '../../../models/song.dart';
import '../../../models/topic.dart';
import '../../../services/service_mng.dart';
import '../../components/PushDown_GestureDetector.dart';
import '../../components/actions_button_row.dart';
import '../../components/content_frame.dart';
import '../../components/suggestion_search_bar.dart';
import '../../components/warning_delete_dialog.dart';

class UserContentPanel extends StatefulWidget {
  RSS rss;

  UserContentPanel({super.key, required this.rss});

  @override
  State<UserContentPanel> createState() => _UserContentPanelState();
}

class _UserContentPanelState extends State<UserContentPanel> {
  List<User> _users = [];

  RSS rss = RSS();

  TextEditingController searchController = TextEditingController();

  Future loadData() async {
    List<User> users = await ModelviewsManager.userModelview.getAllUsers();
    for (User user in users) {
      user.userType = await ModelviewsManager.userTypeModelview
          .getUserTypeById(user.userTypeId);
    }
    setState(() {
      _users = users;
    });
  }

  void updateListViewContentForSearching(List<dynamic> newData, bool isaSsign) {
    setState(() {
      if (newData.isEmpty && isaSsign) {
        _users = [];
      } else if (isaSsign) {
        _users = newData.map((i) => i as User).toList();
      } else {
        loadData();
      }
    });
  }

  Future<bool> deleteUser(User user) async {
    print("deleteUser");
    // final data = await ServiceManager.userService.deleteTopicById(user.id);
    // if (data['message'] == "OK") {
    //   print("${user.id} was Deleted");
    // } else {
    //   print("MESSAGE: ${data["message"]}");
    // }
    return true;
  }

  Future<void> onTapDelete(User user) async {
    String constrainString = "Linking Songs: ";
    List<Song> songs = await ModelviewsManager.songModelviews.getAllSongs();
    //call api to get all songs of this topic
    if (songs.isEmpty) {
      constrainString += "NONE";
    }
    for (var song in songs) {
      constrainString += "\n - ${song.name} ";
    }
    final result = await showGeneralDialog<int>(
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return WarningDeleteDialog(
          title: "Do you want to delete this User?",
          rss: rss,
          object: user,
          isConstrained: songs.isEmpty ? false : true,
          confirmEvent: deleteUser(user),
          constrainedListWidget: Container(
            child: Text(
              constrainString,
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                fontSize: rss.u * 7,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
        );
      },
    );
    if (result != null) {
      if (result == 1) {
        print("Rebuild de load danh sach moi");
        await loadData();
        setState(() {});
      }
    }
  }

  Future<void> onTapEdit(User user) async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return UserFeatureDialog(
          rss: rss,
          user: user,
          mode: 1,
        );
      },
    );
    if (result != null) {
      if (result != 0) {
        print("Rebuild de load danh sach moi");

        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  Future<void> onTapDetail(User user) async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return UserFeatureDialog(
          rss: rss,
          user: user,
          mode: 2,
        );
      },
    );
    if (result != null) {
      if (result != 0) {
        print("Rebuild de load danh sach moi");

        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  Future<void> onTapCreateButton() async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      // Adjust duration according to your needs
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve:
                Curves.easeOutCubic, // Customize the animation curve as needed
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return UserFeatureDialog(
          rss: rss,
          //context: context,
          mode: 0,
          //loadData: loadData,
        );
      },
    );
    if (result != null) {
      if (result == 1) {
        print("Rebuild de load danh sach moi");
        await loadData(); // Reload data after deletion
        setState(() {});
      } else if (result == 0) {
        print("Khong lam gi het");
      }
    }
  }

  @override
  void initState() {
    rss = widget.rss;
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: rss.u * 30,
                  left: rss.u * 0,
                  right: rss.u * 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      //_buildCreateButton(rss),
                      SizedBox(
                        height: rss.u * 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Header Row
                            _buildTableHeaderRow(rss: rss, headers: headers),
                            // Content Rows
                            Expanded(
                              child: ListView.builder(
                                itemCount: _users.length,
                                itemBuilder: (context, index) {
                                  return _buildTableContentRow(
                                    rss: rss,
                                    user: _users[index],
                                    onTapDelete: onTapDelete,
                                    onTapEdit: onTapEdit,
                                    onTapDetail: onTapDetail,
                                    bgColor: index % 2 == 0
                                        ? const Color(0xc8eceff3)
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: rss.u * 100,
                  padding: EdgeInsets.only(
                    left: rss.u * 100,
                    right: rss.u * 100,
                  ),
                  child: SuggestionSearchBar(
                    controller: searchController,
                    data: _users,
                    searchExecutionEvent: updateListViewContentForSearching,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(RSS rss) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: rss.u * 3, top: rss.u * 5),
        child: PushdownGesturedetector(
          elevation: rss.u * 1,
          onTapDownElevation: rss.u * 0.2,
          radius: rss.u * 8,
          onTap: onTapCreateButton,
          child: Text(
            "Create New",
            style: GoogleFonts.roboto(
              fontSize: rss.u * 7,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  //##################################
  //_build Header And Content Row
  //#################################
  List<String> headers = User.getFields()

      //  ..add("Actions")
      ;

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
            case "name":
              flex = 4;
              break;
            case "email":
              flex = 6;
              break;
            case "phone":
              flex = 3;
              break;
            case "birthdate":
              flex = 3;
              break;
            case "picture":
              flex = 3;
              break;
            case "type":
              flex = 2;
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
    required User user,
    Future<void> Function(User)? onTapDelete,
    Future<void> Function(User)? onTapEdit,
    Future<void> Function(User)? onTapDetail,
    Color? bgColor = Colors.transparent,
  }) {
    TextStyle styleContentRow = GoogleFonts.roboto(
      fontSize: rss.u * 7,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF2D3748),
    );
    EdgeInsets edgeInsets = EdgeInsets.only(left: rss.u * 2, right: rss.u * 2);
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(rss.u * 5),
      ),
      child: Column(
        children: [
          SizedBox(
            height: rss.u * 5,
          ),
          Row(
            children: [
              CircelPictureComponent(
                rss: rss,
                flex: 3,
                src: User.getUrlImg(user.email),
                srcDefault: User.getUrlImg("av-none"),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    user.email.toString(),
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    user.name,
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    user.birthdate,
                    style: styleContentRow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    user.phone,
                    style: styleContentRow,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: edgeInsets,
                  child: Text(
                    user.userType!.name,
                    style: styleContentRow,
                  ),
                ),
              ),
              // Expanded(
              //   flex: 5,
              //   child: ActionsButtonRow(
              //     onTapDelete: onTapDelete != null
              //         ? (object) => onTapDelete!(object as User)
              //         : null,
              //     onTapEdit: onTapEdit != null
              //         ? (object) => onTapEdit!(object as User)
              //         : null,
              //     onTapDetail: onTapDetail != null
              //         ? (object) => onTapDetail!(object as User)
              //         : null,
              //     object: user,
              //     paddingAllRow: EdgeInsets.all(rss.u * 2),
              //   ),
              // ),
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
