import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/configs/date_format_config.dart';
import 'package:client/views/pages/login_page.dart';
import 'package:client/views/pages/onboarding_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/device_size_config.dart';
import '../../helpers/shared_preferences_helper.dart';
import '../../modelViews/modelViews_mng.dart';
import '../../models/static_data_model.dart';
import '../../models/user_model.dart';
import '../../services/service_mng.dart';
import '../components/components.dart';
import '../components/feature_dialog.dart';
import 'package:http/http.dart' as http;

import 'forgot_password_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
    this.onBack,
    this.onLogout,
    this.onNavigateToForgotPassword,
  });

  final VoidCallback? onBack;
  final VoidCallback? onLogout;
  final VoidCallback? onNavigateToForgotPassword;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  String img = '';
  bool isSwipingRight = false;

  Future<void> _cropImage(File imgFile) async {
    if (imgFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        uiSettings: [
          AndroidUiSettings(
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
            ],
            toolbarTitle: '             Image Cropper',
            toolbarColor: Color.fromARGB(255, 30, 100, 100),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            showCropGrid: true,
            activeControlsWidgetColor: Color.fromARGB(255, 30, 100, 100),
            cropGridColor: Color.fromARGB(255, 30, 100, 100),
            cropFrameColor: Color.fromARGB(255, 30, 100, 100),
            cropFrameStrokeWidth: 10,
            cropStyle: CropStyle.rectangle,
          )
        ],
      );
      if (croppedFile != null) {
        imageCache.clear();
        setState(() {
          imageFile = File(croppedFile.path);
        });
        print('------------------------cropped-----------------------');
      } else {
        // User canceled the cropper
        print('------------------------No image cropped-----------------------');
      }
    }
  }

  Future<void> imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _cropImage(File(pickedFile.path));
    }
  }

  String base64String(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  Future<String> loadBase64StringPicture() async {
    // Xóa cache của hình ảnh cũ
    imageCache.clear();
    String base64 = "";
    String url = '${ServiceManager.imgUrl}user/${StaticData.currentlyUser?.picture}.png';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // base64 = "data:image/jpeg;base64,${base64Encode(response.bodyBytes)}";
      base64 = base64Encode(response.bodyBytes);
      print('--------------------------------Vừa get hình mới---------------------------------');
    } else {
      throw Exception('Failed to load image');
    }
    return base64;
  }

  Future<void> handleEditPhoto(BuildContext context) async {
    print("--------------------------------handleEditPhoto----------------------------------");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      await imageFromGallery();
      if (imageFile != null) {
        String newPictureBase64 = base64String(imageFile!);
        User? user = await ModelviewsManager.userModelview
            .updateUserPictureByEmail(email: StaticData.currentlyUser!.email, newPictureBase64: newPictureBase64);
        if (user != null) {
          imageCache.clear(); // Thêm dòng này để xóa cache hình ảnh
          StaticData.currentlyUser = user;
          img = await loadBase64StringPicture();
          print('-----------------------img-----------------------: ${img}');
          setState(() {});
        } else {
          showSnackBar(
            context: context,
            message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
            color: Colors.orange[700]!,
          );
        }
        print('-----------------------Đã thay đổi picture-----------------------');
      } else {
        print('-----------------------No image cropped or selected-----------------------');
      }
    } else {
      print('-----------------------No permission provided-----------------------');
    }
  }

  Future<void> handleSeeMore(BuildContext context) async {
    print("--------------------------------handleSeeMore----------------------------------");
    // Tải được hình rôi mới được see more
    if (img != '') {
      OverlayEntry? dialogOverlayEntry;
      dialogOverlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Container(
                margin: EdgeInsets.all(30),
                child: Center(
                  child: ClipOval(
                    child: img.isEmpty
                        ? CircularProgressIndicator()
                        : Image.memory(
                            base64Decode(img),
                            fit: BoxFit.cover, // Đảm bảo hình ảnh được bao phủ toàn bộ hình tròn
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      Overlay.of(context)!.insert(dialogOverlayEntry!);
    }
  }

  Future<void> handleEditName(BuildContext context) async {
    print("--------------------------------handleEditName----------------------------------");
    OverlayEntry? dialogOverlayEntry;
    dialogOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (dialogOverlayEntry != null) {
                  dialogOverlayEntry!.remove();
                  dialogOverlayEntry = null;
                }
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: FeatureDialogEditName(
                oldName: StaticData.currentlyUser!.name.toString(),
                onCancel: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)!.insert(dialogOverlayEntry!);
  }

  void handleEditBirthDate(BuildContext context) {
    print("--------------------------------handleEditBirthDate----------------------------------");
    DateTime? initDatetime = StaticData.currentlyUser?.birthdate;
    DateTime minDate = DateTime.utc(1, 1, 1, 0, 0, 0);
    DateTime maxDate = DateTime.utc(
        DateTime.now().year - 13, DateTime.now().month, DateTime.now().day, 1); // Ngày lớn nhất là đủ 13 tuổi
    DateTime? selectedDate = initDatetime;
    print("initDatetime: ${initDatetime}");
    print("minDate: ${minDate}");
    print("maxDate: ${maxDate}");
    // Kiểm tra nếu initDatetime trùng với minDate
    if (initDatetime != null &&
        initDatetime.year == minDate.year &&
        initDatetime.month == minDate.month &&
        initDatetime.day == minDate.day &&
        initDatetime.hour == minDate.hour &&
        initDatetime.minute == minDate.minute &&
        initDatetime.second == minDate.second) {
      initDatetime = initDatetime.add(Duration(hours: 23)); // Thêm một giờ để tránh trùng lặp hoàn toàn
      print("initDatetime (adjusted): ${initDatetime}");
    }
    OverlayEntry? cupertinoDatePickerOverlayEntry;
    cupertinoDatePickerOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (cupertinoDatePickerOverlayEntry != null) {
                    cupertinoDatePickerOverlayEntry!.remove();
                    cupertinoDatePickerOverlayEntry = null;
                  }
                },
                child: Container(
                  // color: Colors.transparent,
                  color: Colors.black.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0.h, 25.w, 0.h),
                  height: 300.h,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r),
                          color: Colors.grey.shade300,
                        ),
                        child: CupertinoDatePicker(
                          backgroundColor: Colors.grey.shade300,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: initDatetime,
                          minimumDate: minDate,
                          maximumDate: maxDate,
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              selectedDate = value;
                            });
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print('selectedDate: ${selectedDate}');
                          User? user = await ModelviewsManager.userModelview.updateUserBirthdateByEmail(
                              email: StaticData.currentlyUser!.email, newBirthdate: selectedDate!);
                          if (user != null) {
                            StaticData.currentlyUser = user;
                          } else {
                            showSnackBar(
                              context: context,
                              message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
                              color: Colors.orange[700]!,
                            );
                          }
                          if (cupertinoDatePickerOverlayEntry != null) {
                            cupertinoDatePickerOverlayEntry!.remove();
                            cupertinoDatePickerOverlayEntry = null;
                          }
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.r),
                            color: Colors.grey.shade300,
                          ),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: 'CenturyGothicBold',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context)!.insert(cupertinoDatePickerOverlayEntry!);
  }

  Future<void> handleEditPhone(BuildContext context) async {
    print("--------------------------------handleEditPhone----------------------------------");
    OverlayEntry? dialogOverlayEntry;
    dialogOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (dialogOverlayEntry != null) {
                  dialogOverlayEntry!.remove();
                  dialogOverlayEntry = null;
                }
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: FeatureDialogEditPhone(
                oldPhone: StaticData.currentlyUser!.phone.toString(),
                onCancel: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)!.insert(dialogOverlayEntry!);
  }

  Future<void> handleEditPassword(BuildContext context) async {
    print("--------------------------------handleEditName----------------------------------");
    OverlayEntry? dialogOverlayEntry;
    dialogOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (dialogOverlayEntry != null) {
                  dialogOverlayEntry!.remove();
                  dialogOverlayEntry = null;
                }
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: FeatureDialogEditPassword(
                onCancel: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                },
                onNavigateToForgotPassword: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                  widget.onNavigateToForgotPassword!();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ));
                  // Navigator.of(context, rootNavigator: true).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => ForgotPasswordPage(),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)!.insert(dialogOverlayEntry!);
  }

  Future<void> handleLogout() async {
    print("--------------------------------handleLogout----------------------------------");
    OverlayEntry? dialogOverlayEntry;
    dialogOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (dialogOverlayEntry != null) {
                  dialogOverlayEntry!.remove();
                  dialogOverlayEntry = null;
                }
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: FeatureDialogConfirmLogout(
                onConfirm: () async {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                  widget.onLogout!();
                  // xóa user khỏi StaticData
                  StaticData.currentlyUser = null;
                  // xóa user khỏi SharedPreferences
                  SharedPreferencesHelper.removeUser();

                  // Navigator.of(context).popUntil((r) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => LoginPage(),
                  //   ),
                  // );
                  // Xóa toàn bộ các trang hiện tại khỏi stack
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => OnboardingPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                    (Route<dynamic> route) => false,
                  );

                  // đoạn này là không cần thiết vì tại OnboardingPage đã có check để chuyển đến LoginPage
                  // Thêm trang LoginPage vào stack sau khi OnboardingPage đã được thêm
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => LoginPage(),
                  //   ),
                  // );
                },
                onCancel: () {
                  if (dialogOverlayEntry != null) {
                    dialogOverlayEntry!.remove();
                    dialogOverlayEntry = null;
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)!.insert(dialogOverlayEntry!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBase64StringPicture().then((image) {
      setState(() {
        img = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build ProfilePage--------------------------------');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        // onHorizontalDragUpdate: (details) {
        //   if (details.delta.dx < 0 &&
        //       !isSwipingRight &&
        //       details.globalPosition.dx > MediaQuery.of(context).size.width / 2) {
        //     // Vuốt từ phải sang trái
        //     widget.onBack!();
        //     isSwipingRight = true; // Đánh dấu đã xử lý vuốt từ phải sang trái
        //   }
        // },
        // onHorizontalDragEnd: (details) {
        //   isSwipingRight = false; // Đặt lại biến đánh dấu khi kết thúc vuốt ngang
        // },
        child: Container(
          width: double.infinity,
          // color: Color.fromRGBO(22, 26, 35, 1),
          color: Color.fromARGB(255, 41, 41, 42),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Color.fromARGB(255, 30, 100, 100),
                    height: 120.h,
                    alignment: Alignment.center,
                    child: Text(
                      "profile_page_my_profile".tr(),
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      130.w,
                      5.h,
                      0.w,
                      0.h,
                    ),
                    // color: Colors.red,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      StaticData.currentlyUser!.name,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      130.w,
                      5.h,
                      0.w,
                      0.h,
                    ),
                    // color: Colors.red,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      StaticData.currentlyUser!.email,
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      15.w,
                      60.h,
                      15.w,
                      5.h,
                    ),
                    child: Text(
                      // 'Thông tin tài khoản'
                      'Account information',
                      style: TextStyle(
                        fontFamily: 'CenturyGothicRegular',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      15.w,
                      0.h,
                      15.w,
                      0.h,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      10.w,
                      10.h,
                      10.w,
                      10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Color.fromARGB(255, 30, 100, 100),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            handleEditName(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 200.w,
                                  // color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    StaticData.currentlyUser!.name.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ❯",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0.w,
                            10.h,
                            0.w,
                            10.h,
                          ),
                          color: Colors.grey,
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            handleEditBirthDate(context);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Birthdate",
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormatConfig.DateFormatForDisplayNoTime(
                                      StaticData.currentlyUser!.birthdate.toString()),
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  " ❯",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0.w,
                            10.h,
                            0.w,
                            10.h,
                          ),
                          color: Colors.grey,
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            handleEditPhone(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 120.w,
                                  // color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    StaticData.currentlyUser!.phone == null
                                        ? 'Set up now'
                                        // 'Thiết lập ngay'
                                        : StaticData.currentlyUser!.phone.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ❯",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0.w,
                            10.h,
                            0.w,
                            10.h,
                          ),
                          color: Colors.grey,
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            handleEditPassword(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontFamily: 'CenturyGothicRegular',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  // width: 150.w,
                                  // color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    // '✶✶✶✶✶✶',
                                    // '********',
                                    // '★ ★ ★ ★ ★ ★ ',
                                    '⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆⋆',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothicRegular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ❯",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    height: 59.h,
                    margin: EdgeInsets.fromLTRB(
                      15.w,
                      0.h,
                      15.w,
                      0.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Color.fromARGB(255, 30, 100, 100),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // lấy ngôn ngữ hiện tại
                        final currentlyLocale = context.locale.toString();
                        if (currentlyLocale == 'en') {
                          context.setLocale(
                            const Locale('vi'),
                          );
                        } else {
                          context.setLocale(
                            const Locale('en'),
                          );
                        }
                      },
                      child: Text(
                        'Change language',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 59.h,
                    margin: EdgeInsets.fromLTRB(
                      15.w,
                      0.h,
                      15.w,
                      0.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Color.fromARGB(255, 30, 100, 100),
                    ),
                    child: TextButton(
                      onPressed: handleLogout,
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  )
                ],
              ),
              Positioned(
                top: 90.h,
                left: 15.w,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                    border: Border.all(
                      color: Color.fromARGB(255, 41, 41, 42),
                      width: 4,
                    ),
                    color: Color.fromARGB(255, 41, 41, 42),
                  ),
                ),
              ),
              Positioned(
                top: 90.h,
                left: 15.w,
                child: GestureDetector(
                  onTap: () {
                    handleSeeMore(context);
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                      border: Border.all(
                        color: Color.fromARGB(255, 41, 41, 42),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      // child: CachedNetworkImage(
                      //   imageUrl: img,
                      //   // Sử dụng phương thức getUrlImg từ class User
                      //   placeholder: (context, url) => CircularProgressIndicator(),
                      //   // Widget loading khi đang tải hình ảnh
                      //   errorWidget: (context, url, error) => Icon(Icons.error), // Widget hiển thị khi có lỗi xảy ra
                      //   color: StaticData.currentlyUser?.picture == 'av-none' ? Colors.white : null,
                      // ),
                      // child: Image.network(
                      //   key: UniqueKey(),
                      //   img,
                      //   // width: 100.w,
                      //   // height: 100.w,
                      //   color: StaticData.currentlyUser?.picture == 'av-none' ? Colors.white : null,
                      //   fit: BoxFit.cover, // Đảm bảo hình ảnh được bao phủ toàn bộ hình tròn
                      // ),
                      child: img.isEmpty
                          ? CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 255, 255),
                            )
                          : Image.memory(
                              base64Decode(img),
                              fit: BoxFit.cover, // Đảm bảo hình ảnh được bao phủ toàn bộ hình tròn
                            ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 160.h,
                left: 88.w,
                child: GestureDetector(
                  onTap: () {
                    handleEditPhoto(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                      // color: Color(0x8395959F),
                      color: Color.fromRGBO(100, 100, 100, 0.8),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Color.fromRGBO(22, 26, 35, 1),
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
