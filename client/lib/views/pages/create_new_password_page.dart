import 'dart:ffi';

import 'package:client/views/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/components.dart';

class CreateNewPasswordPage extends StatefulWidget {
  CreateNewPasswordPage({
    super.key,
  });

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  Map<String, String> errorTexts = {'Password': '', 'ConfirmPassword': ''};
  ValueNotifier<bool> passwordNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordNotifier.dispose();
    confirmPasswordNotifier.dispose();
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

  void handleConfirm() {
    final _password = passwordController.text.trim();
    final _confirmPassword = confirmPasswordController.text.trim();
    print('-----------------------------------handleConfirm-----------------------------------');
    setState(() {
      errorTexts['Password'] = _password.isEmpty
          ? 'Password cannot be empty'
          : _password.length < 8
              ? 'Password must have at least 8 characters'
              : '';
      errorTexts['ConfirmPassword'] = _confirmPassword.isEmpty
          ? 'Confirm Password cannot be empty'
          : _confirmPassword != _password
              ? 'Confirm Password do not match'
              : '';
    });
    // Kiểm tra nếu không có lỗi
    if (errorTexts.values.every((error) => error.isEmpty)) {
      print('-------------------Password: ${_password}-------------------');
      print('----------------------------------------------------------------------------------');
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(
        context: context,
        message: 'Password changed successfully',
        color: Colors.green.shade700!,
      );
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
    print('--------------------------------Build CreateNewPasswordPage-----------------------------------');
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          onDismissKeyboard(context);
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              25.w,
              0.h,
              25.w,
              0.h,
            ),
            width: 428.w,
            height: 924.h,
            color: const Color.fromARGB(255, 30, 30, 30),
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset(-0.w, -0.h),
                  // Di chuyển sang trái 25.w và lên trên 0.h
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: 80.h,
                    margin: EdgeInsets.fromLTRB(
                      0.w,
                      0.h,
                      0.w,
                      0.h,
                    ),
                    //color: Colors.greenAccent,
                    child: GestureDetector(
                      onTap: () {
                        clearTextError();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/bg-create-new-password.png",
                  width: 260.w,
                  height: 200.h,
                ),
                renderTitle(title: 'Create Password', marginTop: 0, fontSize: 30),
                renderTextField(
                    hintText: 'Password', controller: passwordController, isObscured: true, password: passwordNotifier),
                renderErrorText(errorText: 'Password'),
                renderTextField(
                    hintText: 'Confirm Password',
                    controller: confirmPasswordController,
                    isObscured: true,
                    password: confirmPasswordNotifier),
                renderErrorText(errorText: 'ConfirmPassword'),
                Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
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
      ),
    );
  }
}
