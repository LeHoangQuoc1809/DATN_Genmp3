import 'dart:ui';

import 'package:client/models/static_data_model.dart';
import 'package:client/resources/colors.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/device_size_config.dart';
import '../../modelViews/modelViews_mng.dart';
import '../../models/user_model.dart';
import '../pages/forgot_password_page.dart';
import 'components.dart';

class FeatureDialogCreateNewPassword extends StatefulWidget {
  FeatureDialogCreateNewPassword({
    super.key,
    required this.onPasswordEntered,
  });

  final Function(String) onPasswordEntered;

  @override
  State<FeatureDialogCreateNewPassword> createState() => _FeatureDialogCreateNewPasswordState();
}

class _FeatureDialogCreateNewPasswordState extends State<FeatureDialogCreateNewPassword> {
  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  Map<String, String> errorTexts = {'Password': '', 'ConfirmPassword': ''};
  ValueNotifier<bool> passwordNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier<bool>(true);

  void clearTextError() {
    print('-----------------------------------clearTextError-----------------------------------');
    setState(() {
      errorTexts.forEach((key, value) {
        errorTexts[key] = '';
      });
    });
  }

  void handleOntapTextField({
    required String hintText,
  }) {
    print('-----------------------------------handleOntapTextField-----------------------------------');
    setState(() {
      String cleanedSpaceHintText = hintText.replaceAll(' ', ''); // Loại bỏ tất cả các khoảng trắng
      errorTexts[cleanedSpaceHintText] = '';
    });
  }

  void handleConfirm() {
    final _password = passwordController.text.trim();
    final _confirmPassword = confirmPasswordController.text.trim();
    print('-----------------------------------handleConfirm-----------------------------------');
    setState(() {
      errorTexts['Password'] = _password.isEmpty
          ? 'Password cannot be empty'
          : _password.length < 8
              ? 'Minimum 8 characters'
              : '';
      errorTexts['ConfirmPassword'] = _confirmPassword.isEmpty
          ? 'Confirm cannot be empty'
          : _confirmPassword != _password
              ? 'Confirm Password do not match'
              : '';
    });
    // Kiểm tra nếu không có lỗi
    if (errorTexts.values.every((error) => error.isEmpty)) {
      print('-------------------Password: ${_password}-------------------');
      print('----------------------------------------------------------------------------------');
      widget.onPasswordEntered(_password);
      Navigator.of(context).pop(_password);
    }
  }

  Widget renderTitle({
    required String title,
    required double marginTop,
    required double fontSize,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: marginTop.h,
      ),
      width: double.infinity,
      height: 89.h,
      // color: Colors.redAccent,
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'CenturyGothicRegular',
          fontSize: fontSize.sp,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  Widget renderTextField({
    required String hintText,
    required TextEditingController controller,
    required bool isObscured,
    required ValueNotifier<bool> password,
  }) {
    return Container(
      // margin: EdgeInsets.only(
      //   bottom: 23.h ,
      // ),
      width: double.infinity,
      height: 59.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color.fromARGB(255, 219, 231, 232),
          width: 0.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              16.w,
              0.h,
              16.w,
              0.h,
            ),
            child: Image.asset(
              isObscured ? 'assets/images/ic-password.png' : 'assets/images/ic-email.png',
              width: 16.w,
              height: 16.h,
              color: Color.fromRGBO(255, 255, 255, 0.27),
            ),
            // SvgPicture.string(
            //   isObscured ? image_constants.icSvgPassword : image_constants.icSvgEmail,
            //   width: 16.w ,
            //   height: 16.h ,
            // ),
          ),
          Expanded(
            child: TextField(
              onTap: () {
                handleOntapTextField(hintText: hintText);
              },
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40), // giới hạn số lượng ký tự là 40
                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Loại bỏ khoảng trắng
              ],
              obscureText: password.value,
              // Ẩn mật khẩu nếu `_isObscured` là true
              decoration: InputDecoration(
                // errorText: '123',
                contentPadding: EdgeInsets.fromLTRB(
                  0.w,
                  0.h,
                  0.w,
                  0.h,
                ),
                fillColor: Colors.transparent,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'CenturyGothicRegular',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(15.0.sp),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: isObscured
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            password.value = !password.value;
                            print(
                                '------------password------------------------${password.value}---------------------------');
                          });
                        },
                        child: Icon(password.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      )
                    : null,
              ),
              controller: controller,
              style: TextStyle(
                fontFamily: 'CenturyGothicRegular',
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderErrorText({
    required String errorText,
  }) {
    return Container(
      height: 23.h,
      alignment: Alignment.topLeft,
      //color: Colors.green,
      margin: EdgeInsets.only(
        left: 48.w,
      ),
      child: Text(
        errorTexts[errorText].toString(),
        style: TextStyle(
          color: Colors.orange[700],
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDismissKeyboard(context);
      },
      child: AlertDialog(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            // "Completed, next please create your password",
            "Create Password",
            style: TextStyle(
              fontFamily: 'CenturyGothicBold',
              fontSize: 30.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: Container(
          padding: EdgeInsets.fromLTRB(
            0.w,
            0.h,
            0.w,
            0.h,
          ),
          width: 1.w,
          height: 230.h,
          color: const Color.fromARGB(255, 30, 30, 30),
          // color: Colors.transparent,
          child: Column(
            children: [
              renderTextField(
                  hintText: 'Password', controller: passwordController, isObscured: true, password: passwordNotifier),
              renderErrorText(errorText: 'Password'),
              renderTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  isObscured: true,
                  password: confirmPasswordNotifier),
              renderErrorText(errorText: 'ConfirmPassword'),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 0.h,
                ),
                width: 377.w,
                height: 59.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 160, 181),
                  borderRadius: BorderRadius.circular(35.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 6, 160, 181).withOpacity(0.3), // Màu và độ mờ của bóng
                      spreadRadius: 5, // Bán kính phát tán của bóng
                      blurRadius: 3, // Độ mờ của bóng
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: handleConfirm,
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.mulish(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
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

class FeatureDialogEditName extends StatefulWidget {
  FeatureDialogEditName({super.key, required this.oldName, required this.onCancel});

  String oldName;
  final VoidCallback onCancel;

  @override
  State<FeatureDialogEditName> createState() => _FeatureDialogEditNameState();
}

class _FeatureDialogEditNameState extends State<FeatureDialogEditName> {
  String oldname = '';
  String trimmedName = '';
  final nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldname = widget.oldName;
    trimmedName = widget.oldName;
    nameController.text = widget.oldName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDismissKeyboard(context);
      },
      child: AlertDialog(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Edit Name',
            // style: TextStyle(
            //   fontFamily: 'CenturyGothicBold',
            //   fontSize: 30.sp,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.black,
            // ),
            style: TextStyle(
              fontFamily: 'CenturyGothicBold',
              fontSize: 30.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: Container(
          height: 130.h,
          width: 1.w,
          // color: Colors.lightBlueAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {
                      trimmedName = value.trim();
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40), // giới hạn số lượng ký tự là 40
                  ],
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      0.w,
                      -15.h,
                      0.w,
                      0.h,
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  // style: TextStyle(
                  //   fontFamily: 'CenturyGothicRegular',
                  //   fontSize: 15.sp,
                  //   fontWeight: FontWeight.bold,
                  //   color: Colors.black,
                  // ),
                  style: TextStyle(
                    fontFamily: 'CenturyGothicRegular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '40 characters only',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Spacer(),
              Container(
                height: 42.h,
                // color: Colors.red,
                child: Row(
                  children: [
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          // color: Colors.deepPurple.shade900,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: widget.onCancel,
                    ),
                    TextButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: trimmedName != oldname && trimmedName != ''
                              // ? Colors.deepPurple.shade900
                              // : Colors.deepPurple.shade200,
                              ? Colors.white
                              : Colors.white30,
                        ),
                      ),
                      onPressed: (trimmedName != oldname && trimmedName != '')
                          ? () async {
                              User? user = await ModelviewsManager.userModelview
                                  .updateUserByName(email: StaticData.currentlyUser!.email, newName: trimmedName);
                              if (user != null) {
                                StaticData.currentlyUser = user;
                              } else {
                                showSnackBar(
                                  context: context,
                                  message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
                                  color: Colors.orange[700]!,
                                );
                              }
                              widget.onCancel();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              // Visibility(
              //   visible: trimmedName != oldname && trimmedName != '',
              //   // Chỉ hiển thị nút "Confirm" khi đã thay đổi name và name khác rỗng
              //   child: Container(
              //     // color: Colors.red,
              //     child: Row(children: [
              //       Spacer(),
              //       TextButton(
              //         child: Text('Cancel'),
              //         onPressed: widget.onCancel,
              //       ),
              //       TextButton(
              //         child: Text('Confirm'),
              //         onPressed: () async {
              //           print('email: hoangquoc18092002@gmail.com');
              //           print('trimmedName: ${trimmedName}');
              //           User? user = await ModelviewsManager.userModelview
              //               .updateUserByName(email: 'hoangquoc18092002@gmail.com', newName: trimmedName);
              //           if (user != null) {
              //             StaticData.currentlyUser = user;
              //           } else {}
              //           widget.onCancel();
              //         },
              //       ),
              //     ]),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureDialogEditPhone extends StatefulWidget {
  FeatureDialogEditPhone({super.key, required this.oldPhone, required this.onCancel});

  String oldPhone;
  final VoidCallback onCancel;

  @override
  State<FeatureDialogEditPhone> createState() => _FeatureDialogEditPhoneState();
}

class _FeatureDialogEditPhoneState extends State<FeatureDialogEditPhone> {
  String oldPhone = '';
  String newPhone = '';
  final phoneController = TextEditingController(text: '');
  String errorPhone = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.oldPhone != 'null') {
      phoneController.text = widget.oldPhone;
      oldPhone = widget.oldPhone;
      newPhone = widget.oldPhone;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDismissKeyboard(context);
      },
      child: AlertDialog(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Edit Phone Number',
            // style: TextStyle(
            //   fontFamily: 'CenturyGothicBold',
            //   fontSize: 25.sp,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.black,
            // ),
            style: TextStyle(
              fontFamily: 'CenturyGothicBold',
              fontSize: 25.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: Container(
          height: 140.h,
          width: 1.w,
          // color: Colors.lightBlueAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70.h,
                // color: Colors.red,
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {
                      newPhone = value.trim();
                      errorPhone = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10), // Giới hạn số lượng ký tự là 10
                    FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                  ],
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      0.w,
                      -25.h,
                      0.w,
                      0.h,
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  controller: phoneController,
                  // style: TextStyle(
                  //   fontFamily: 'CenturyGothicRegular',
                  //   fontSize: 15.sp,
                  //   fontWeight: FontWeight.bold,
                  //   color: Colors.black,
                  // ),
                  style: TextStyle(
                    fontFamily: 'CenturyGothicRegular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Text(
                errorPhone,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Spacer(),
              Container(
                height: 42.h,
                // color: Colors.red,
                child: Row(
                  children: [
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          // color: Colors.deepPurple.shade900,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: widget.onCancel,
                    ),
                    TextButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: (newPhone != oldPhone && newPhone.length == 10) ||
                                  (newPhone != oldPhone && newPhone.isEmpty)
                              // ? Colors.deepPurple.shade900
                              // : Colors.deepPurple.shade200,
                              ? Colors.white
                              : Colors.white30,
                        ),
                      ),
                      onPressed:
                          (newPhone != oldPhone && newPhone.length == 10) || (newPhone != oldPhone && newPhone.isEmpty)
                              ? () async {
                                  if (newPhone.length == 10) {
                                    // thay đổi phone
                                    User? existingUserByPhone =
                                        await ModelviewsManager.userModelview.getUserByPhone(phone: newPhone);
                                    if (existingUserByPhone != null) {
                                      setState(() {
                                        errorPhone = 'Phone already exists';
                                      });
                                      print("existingUserByPhone: ${existingUserByPhone}");
                                    } else {
                                      User? user = await ModelviewsManager.userModelview.updateUserPhoneByEmail(
                                          email: StaticData.currentlyUser!.email, newPhone: newPhone);
                                      if (user != null) {
                                        StaticData.currentlyUser = user;
                                      } else {
                                        showSnackBar(
                                          context: context,
                                          message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
                                          color: Colors.orange[700]!,
                                        );
                                      }
                                      widget.onCancel();
                                    }
                                  } else if (newPhone.isEmpty) {
                                    // xóa phone
                                    User? user = await ModelviewsManager.userModelview
                                        .updateUserPhoneByEmail(email: StaticData.currentlyUser!.email, newPhone: null);
                                    if (user != null) {
                                      StaticData.currentlyUser = user;
                                    } else {
                                      showSnackBar(
                                        context: context,
                                        message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
                                        color: Colors.orange[700]!,
                                      );
                                    }
                                    widget.onCancel();
                                  }
                                }
                              : null,
                    ),
                  ],
                ),
              ),
              // Visibility(
              //   visible: phone != oldPhone && phone.length == 10,
              //   // Chỉ hiển thị nút "Confirm" khi đã thay đổi phone và khi đủ 10 ký tự
              //   child: Container(
              //     // color: Colors.red,
              //     child: Row(
              //       children: [
              //         Spacer(),
              //         TextButton(
              //           child: Text('Cancel'),
              //           onPressed: widget.onCancel,
              //         ),
              //         TextButton(
              //           child: Text('Confirm'),
              //           onPressed: () async {
              //             if (phone.length == 10) {
              //               User? existingUserByPhone =
              //               await ModelviewsManager.userModelview.getUserByPhone(phone: phone);
              //               if (existingUserByPhone != null) {
              //                 setState(() {
              //                   errorPhone = 'Phone already exists';
              //                 });
              //                 print("existingUserByPhone: ${existingUserByPhone}");
              //               } else {
              //
              //               }
              //             }
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureDialogEditPassword extends StatefulWidget {
  FeatureDialogEditPassword({
    super.key,
    required this.onCancel,
    required this.onNavigateToForgotPassword,
  });

  VoidCallback onCancel;

  VoidCallback onNavigateToForgotPassword;

  @override
  State<FeatureDialogEditPassword> createState() => _FeatureDialogEditPasswordState();
}

class _FeatureDialogEditPasswordState extends State<FeatureDialogEditPassword> {
  final oldPasswordController = TextEditingController(text: '');
  final newPasswordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  Map<String, String> errorTexts = {'OldPassword': '', 'NewPassword': '', 'ConfirmPassword': ''};
  ValueNotifier<bool> oldPasswordNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> newPasswordNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier<bool>(true);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void clearTextError() {
    print('-----------------------------------clearTextError-----------------------------------');
    setState(() {
      errorTexts.forEach((key, value) {
        errorTexts[key] = '';
      });
    });
  }

  void handleOntapTextField({
    required String hintText,
  }) {
    print('-----------------------------------handleOntapTextField-----------------------------------');
    setState(() {
      String cleanedSpaceHintText = hintText.replaceAll(' ', ''); // Loại bỏ tất cả các khoảng trắng
      errorTexts[cleanedSpaceHintText] = '';
    });
  }

  Future<void> handleConfirm() async {
    final _oldPassword = oldPasswordController.text.trim();
    final _newPassword = newPasswordController.text.trim();
    final _confirmPassword = confirmPasswordController.text.trim();
    print('-----------------------------------handleConfirm-----------------------------------');
    String? currentlyPassword =
        await ModelviewsManager.userModelview.getPasswordByEmail(email: StaticData.currentlyUser!.email);
    print("currentlyPassword: ${currentlyPassword}");
    setState(() {
      errorTexts['OldPassword'] = _oldPassword.isEmpty
          ? 'Old Password cannot be empty'
          : _oldPassword != currentlyPassword
              ? 'Wrong password!'
              : '';
      errorTexts['NewPassword'] = _newPassword.isEmpty
          ? 'New Password cannot be empty'
          : _newPassword.length < 8
              ? 'Minimum 8 characters'
              : '';
      errorTexts['ConfirmPassword'] = _confirmPassword.isEmpty
          ? 'Confirm cannot be empty'
          : _confirmPassword != _newPassword
              ? 'Confirm Password do not match'
              : '';
    });
    // Kiểm tra nếu không có lỗi
    if (errorTexts.values.every((error) => error.isEmpty)) {
      print('-------------------NewPassword: ${_newPassword}-------------------');
      print('----------------------------------------------------------------------------------');
      User? user = await ModelviewsManager.userModelview
          .updateUserPasswordByEmail(email: StaticData.currentlyUser!.email, newPassword: _newPassword);
      if (user != null) {
        StaticData.currentlyUser = user;
        showSnackBar(
          context: context,
          message: 'Password changed successfully',
          color: Colors.green.shade700!,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
          color: Colors.orange[700]!,
        );
      }
      widget.onCancel();
    }
  }

  void handleForgotThePassword() {
    print('-----------------------------------handleForgotThePassword-----------------------------------');
    widget.onNavigateToForgotPassword();
  }

  Widget renderTitle({
    required String title,
    required double marginTop,
    required double fontSize,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: marginTop.h,
      ),
      width: double.infinity,
      height: 89.h,
      // color: Colors.redAccent,
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'CenturyGothicRegular',
          fontSize: fontSize.sp,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  Widget renderTextField({
    required String hintText,
    required TextEditingController controller,
    required bool isObscured,
    required ValueNotifier<bool> password,
  }) {
    return Container(
      // margin: EdgeInsets.only(
      //   bottom: 23.h ,
      // ),
      width: double.infinity,
      height: 59.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color.fromARGB(255, 219, 231, 232),
          width: 0.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              16.w,
              0.h,
              16.w,
              0.h,
            ),
            child: Image.asset(
              isObscured ? 'assets/images/ic-password.png' : 'assets/images/ic-email.png',
              width: 16.w,
              height: 16.h,
              color: Color.fromRGBO(255, 255, 255, 0.27),
            ),
            // SvgPicture.string(
            //   isObscured ? image_constants.icSvgPassword : image_constants.icSvgEmail,
            //   width: 16.w ,
            //   height: 16.h ,
            // ),
          ),
          Expanded(
            child: TextField(
              focusNode: hintText == 'Old Password' ? _focusNode : null,
              onTap: () {
                handleOntapTextField(hintText: hintText);
              },
              onChanged: (string) {
                handleOntapTextField(hintText: hintText);
              },
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40), // giới hạn số lượng ký tự là 40
                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Loại bỏ khoảng trắng
              ],
              obscureText: password.value,
              // Ẩn mật khẩu nếu `_isObscured` là true
              decoration: InputDecoration(
                // errorText: '123',
                contentPadding: EdgeInsets.fromLTRB(
                  0.w,
                  0.h,
                  0.w,
                  0.h,
                ),
                fillColor: Colors.transparent,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'CenturyGothicRegular',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(15.0.sp),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: isObscured
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            password.value = !password.value;
                            print(
                                '------------password------------------------${password.value}---------------------------');
                          });
                        },
                        child: Icon(password.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      )
                    : null,
              ),
              controller: controller,
              style: TextStyle(
                fontFamily: 'CenturyGothicRegular',
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderErrorText({
    required String errorText,
  }) {
    return Container(
      height: 23.h,
      alignment: Alignment.topLeft,
      // color: Colors.green,
      margin: EdgeInsets.only(
        left: 48.w,
      ),
      child: Text(
        errorTexts[errorText].toString(),
        style: TextStyle(
          color: Colors.orange[700],
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDismissKeyboard(context);
      },
      child: AlertDialog(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            // "Completed, next please create your password",
            "Edit Password",
            style: TextStyle(
              fontFamily: 'CenturyGothicBold',
              fontSize: 30.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: Container(
          padding: EdgeInsets.fromLTRB(
            0.w,
            0.h,
            0.w,
            0.h,
          ),
          width: 1.w,
          // height: 290.h,
          height: 315.h,
          color: const Color.fromARGB(255, 30, 30, 30),
          // color: Colors.transparent,
          child: Column(
            children: [
              renderTextField(
                  hintText: 'Old Password',
                  controller: oldPasswordController,
                  isObscured: true,
                  password: oldPasswordNotifier),
              renderErrorText(errorText: 'OldPassword'),
              renderTextField(
                  hintText: 'New Password',
                  controller: newPasswordController,
                  isObscured: true,
                  password: newPasswordNotifier),
              renderErrorText(errorText: 'NewPassword'),
              renderTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  isObscured: true,
                  password: confirmPasswordNotifier),
              renderErrorText(errorText: 'ConfirmPassword'),
              Spacer(),
              GestureDetector(
                onTap: () {
                  handleForgotThePassword();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 25.h,
                  // color: Colors.red,
                  child: Text(
                    'Forgot the password?',
                    style: TextStyle(
                      fontFamily: 'CenturyGothicRegular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 57, 192, 212),
                    ),
                  ),
                ),
              ),
              Container(
                height: 42.h,
                // color: Colors.red,
                child: Row(
                  children: [
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicBold',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      onPressed: widget.onCancel,
                    ),
                    TextButton(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'CenturyGothicBold',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        onPressed: () {
                          handleConfirm();
                        }
                        // (newPhone != oldPhone && newPhone.length == 10)
                        //     ? () async {
                        //   if (newPhone.length == 10) {
                        //     User? existingUserByPhone =
                        //     await ModelviewsManager.userModelview.getUserByPhone(phone: newPhone);
                        //     if (existingUserByPhone != null) {
                        //       setState(() {
                        //         errorPhone = 'Phone already exists';
                        //       });
                        //       print("existingUserByPhone: ${existingUserByPhone}");
                        //     } else {
                        //       User? user = await ModelviewsManager.userModelview.updateUserPhoneByEmail(
                        //           email: StaticData.currentlyUser!.email, newPhone: newPhone);
                        //       if (user != null) {
                        //         StaticData.currentlyUser = user;
                        //       } else {
                        //         // showSnackBar(
                        //         //     context: context,
                        //         //     message: 'Đã có lỗi xảy ra xin vui lòng thử lại sau vài phút!',
                        //         //     color: Colors.orange[700]!);
                        //       }
                        //       widget.onCancel();
                        //     }
                        //   }
                        // }
                        //
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureDialogConfirmLogout extends StatefulWidget {
  FeatureDialogConfirmLogout({super.key, required this.onConfirm, required this.onCancel});

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  State<FeatureDialogConfirmLogout> createState() => _FeatureDialogConfirmLogoutState();
}

class _FeatureDialogConfirmLogoutState extends State<FeatureDialogConfirmLogout> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.white,
      // backgroundColor: Colors.grey.shade300,
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          'Log Out',
          // style: TextStyle(
          //   fontFamily: 'CenturyGothicBold',
          //   fontSize: 30.sp,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.black,
          // ),
          style: TextStyle(
            fontFamily: 'CenturyGothicBold',
            fontSize: 30.sp,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      content: Container(
        height: 100.h,
        width: 1.w,
        // color: Colors.lightBlueAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Do you really want to log out?",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'CenturyGothicRegular',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            Spacer(),
            Container(
              // color: Colors.red,
              height: 42.h,
              child: Row(
                children: [
                  Spacer(),
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'CenturyGothicBold',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        // color: Colors.deepPurple.shade900,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: widget.onCancel,
                  ),
                  TextButton(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'CenturyGothicBold',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        // color: Colors.deepPurple.shade900,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: widget.onConfirm,
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: phone != oldPhone && phone.length == 10,
            //   // Chỉ hiển thị nút "Confirm" khi đã thay đổi phone và khi đủ 10 ký tự
            //   child: Container(
            //     // color: Colors.red,
            //     child: Row(
            //       children: [
            //         Spacer(),
            //         TextButton(
            //           child: Text('Cancel'),
            //           onPressed: widget.onCancel,
            //         ),
            //         TextButton(
            //           child: Text('Confirm'),
            //           onPressed: () async {
            //             if (phone.length == 10) {
            //               User? existingUserByPhone =
            //               await ModelviewsManager.userModelview.getUserByPhone(phone: phone);
            //               if (existingUserByPhone != null) {
            //                 setState(() {
            //                   errorPhone = 'Phone already exists';
            //                 });
            //                 print("existingUserByPhone: ${existingUserByPhone}");
            //               } else {
            //
            //               }
            //             }
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
