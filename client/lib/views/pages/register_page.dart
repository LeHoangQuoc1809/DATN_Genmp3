import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:client/configs/date_format_config.dart';
import 'package:client/configs/device_size_config.dart';
import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/modelViews/user_modelView.dart';
import 'package:client/models/static_data_model.dart';
import 'package:client/models/user_model.dart';
import 'package:client/views/pages/login_page.dart';
import 'package:client/views/pages/main_page.dart';
import 'package:client/views/pages/otp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import 'package:client/resources/images.dart' as image_constants;
import 'package:client/resources/colors.dart' as color_constants;
import 'package:google_fonts/google_fonts.dart';

import '../components/components.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController(text: '');
  final fullNameController = TextEditingController(text: '');
  final dateOfBirthController = TextEditingController(text: '');

  // final phoneController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  bool isOTPSent = false;
  String generatedOTP = "";
  Map<String, String> errorTexts = {
    'Email': '',
    'FullName': '',
    'DateOfBirth': '',
    // 'Phone': '',
    'Password': '',
    'ConfirmPassword': '',
  };

  // String errorTextEmail = '';
  // String errorTextFullName = '';
  // String errorTextDateOfBirth = '';
  // String errorTextPhone = '';
  // String errorTextPassword = '';
  // String errorTextConfirmPassword = '';
  ValueNotifier<bool> emailNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> passwordNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier<bool>(true);
  DateTime selectedDate = DateTime.now();
  String dateOfBirth = 'Date Of Birth';

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    dateOfBirthController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailNotifier.dispose();
    passwordNotifier.dispose();
    confirmPasswordNotifier.dispose();
    super.dispose();
  }

  Future<void> _selecteDate({
    required BuildContext context,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(DateTime.now().year - 60),
      lastDate: DateTime(DateTime.now().year - 18),
      barrierDismissible: false,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // dateOfBirth = DateFormatConfig.DateFormatForDisplay(selectedDate.toString());
        dateOfBirth = DateFormat('dd-MM-yyyy').format(selectedDate).toString();
        dateOfBirthController.text = dateOfBirth;
        errorTexts['DateOfBirth'] = '';
      });
    }
  }

  void clearTextField() {
    print('-----------------------------------clearTextField-----------------------------------');
    setState(() {
      emailController.text = '';
      fullNameController.text = '';
      dateOfBirthController.text = '';
      // phoneController.text = '';
      passwordController.text = '';
      confirmPasswordController.text = '';
    });
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

  Future<void> handleSignUp() async {
    onDismissKeyboard(context);
    final _email = emailController.text.trim().toLowerCase();
    final _fullName = fullNameController.text.trim();
    final _dateOfBirth = dateOfBirthController.text.trim();
    // final _phone = phoneController.text.trim();
    final _password = passwordController.text.trim();
    final _confirmPassword = confirmPasswordController.text.trim();
    print('-----------------------------------handleSignUp-----------------------------------');
    setState(() {
      errorTexts['Email'] = _email.isEmpty
          ? 'Email cannot be empty'
          : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)
              ? 'Invalid email'
              : '';
      errorTexts['FullName'] = _fullName.isEmpty ? 'Full Name cannot be empty' : '';
      errorTexts['DateOfBirth'] = _dateOfBirth == 'Date Of Birth' ? 'Date Of Birth cannot be empty' : '';
      // errorTexts['Phone'] = _phone.isEmpty
      //     ? 'Phone number cannot be empty'
      //     : _phone.length < 10
      //         ? 'Phone number must be 10 characters'
      //         : '';
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
      print('-------------------Tất cả đã hợp lệ, create user thôi-----------------------------');
      print('----------------------------------------------------------------------------------');
      print('-------------------Email: ${_email}-------------------');
      print('----------------------------------------------------------------------------------');
      print('-------------------Full Name: ${_fullName}-------------------');
      print('----------------------------------------------------------------------------------');
      print('-------------------Date Of Birth: ${_dateOfBirth}-------------------');
      print('----------------------------------------------------------------------------------');
      // print('-------------------Phone: ${_phone}-------------------');
      // print('----------------------------------------------------------------------------------');
      print('-------------------Password: ${_password}-------------------');
      print('----------------------------------------------------------------------------------');
      User? existingUserByEmail = await ModelviewsManager.userModelview.getUserByEmail(email: _email);
      if (existingUserByEmail != null) {
        setState(() {
          errorTexts['Email'] = 'Email already exists';
        });
        print("existingUserByEmail: ${existingUserByEmail}");
      }
      // User? existingUserByPhone = await ModelviewsManager.userModelview.getUserByPhone(phone: _phone);
      // if (existingUserByPhone != null) {
      //   setState(() {
      //     errorTexts['Phone'] = 'Phone already exists';
      //   });
      //   print("existingUserByPhone: ${existingUserByPhone}");
      // }
      if (existingUserByEmail == null
          // && existingUserByPhone == null

          ) {
        DateTime userDateOfBirth = DateFormatConfig.DateFormatForCreateUser(_dateOfBirth);
        print('userDateOfBirth: $userDateOfBirth');
        User user = User(
            email: _email,
            name: _fullName,
            birthdate: userDateOfBirth,
            phone: null,
            // _phone,
            password: _password,
            picture: 'av-none',
            user_type_id: 1);
        print('User: $user');
        bool isCreated = await ModelviewsManager.userModelview.validateUserForClient(pictureBase64: '', user: user);
        if (isCreated) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                user: user,
                isForgotPassword: false,
              ),
            ),
          );
        } else {
          showSnackBar(
            context: context,
            message:
                'An OTP request has already been made from a different server. Please wait before requesting a new OTP.',
            color: Colors.orange[700]!,
          );
        }
      }
    }
  }

  void handleSignin() {
    print('-----------------------------------handleSignin-----------------------------------');
    clearTextError();
    clearTextField();
    Navigator.pop(context);
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

  Widget renderTextButton({
    required String text,
    required Function function,
  }) {
    return Container(
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
        onPressed: () {
          function();
        },
        child: Text(
          text,
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
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
    String imagePath = '';
    switch (hintText) {
      case 'Email':
        imagePath = 'ic-email.png';
        break;
      case 'Full Name':
        imagePath = 'ic-full-name.png';
        break;
      case 'Phone':
        imagePath = 'ic-phone.png';
        break;
      case 'Password':
        imagePath = 'ic-password.png';
        break;
      default:
        imagePath = 'ic-password.png';
        break;
    }
    List<TextInputFormatter> inputFormatters = [];
    if (hintText == 'Phone') {
      inputFormatters = [
        LengthLimitingTextInputFormatter(10), // Giới hạn số lượng ký tự là 10
        FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
      ];
    } else {
      inputFormatters = [
        LengthLimitingTextInputFormatter(40), // Giới hạn số lượng ký tự là 40
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Loại bỏ khoảng trắng
      ];
      hintText == 'Full Name' ? inputFormatters.removeAt(1) : null;
    }

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
              'assets/images/${imagePath}',
              width: 16.w,
              height: 16.h,
              color: Color.fromRGBO(255, 255, 255, 0.27),
            ),
          ),
          Expanded(
            child: TextField(
              onTap: () {
                handleOntapTextField(hintText: hintText);
              },
              maxLines: 1,
              inputFormatters: inputFormatters,
              keyboardType: hintText == 'Phone' ? TextInputType.number : TextInputType.text,
              obscureText: password.value,
              // Ẩn mật khẩu nếu `_isObscured` là true
              decoration: InputDecoration(
                // errorText: errorTexts[hintText.replaceAll(' ', '')],
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
                border: const OutlineInputBorder(
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

  Widget renderSelectedDate({
    required TextEditingController controller,
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
              'assets/images/ic-date-of-birth.png',
              width: 16.w,
              height: 16.h,
              color: Color.fromRGBO(255, 255, 255, 0.27),
            ),
          ),
          Expanded(
              child: TextButton(
            onPressed: () {
              _selecteDate(context: context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                dateOfBirthController.text,
                style: TextStyle(
                  fontFamily: 'CenturyGothicRegular',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )),
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

  Widget renderTextButtonSignIn() {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
      ),
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have account?',
            style: GoogleFonts.mulish(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextButton(
            onPressed: handleSignin,
            child: Text(
              'Sign In',
              style: GoogleFonts.mulish(
                color: Color.fromARGB(255, 124, 238, 255),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateOfBirthController.text = dateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build RegisterPage-----------------------------------');
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
            height: MediaQuery.of(context).size.height,
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
                    // color: Colors.greenAccent,
                    child: GestureDetector(
                      onTap: () {
                        clearTextError();
                        clearTextField();
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
                  "assets/images/bg-register.png",
                  // width: 325.w,
                  // height: 254.h,
                  // width: 400.w,
                  // height: 260.h,
                  width: 200.w,
                ),
                renderTitle(title: 'Begin Registration', marginTop: 0, fontSize: 30),
                // renderTitle(title: 'Sign Up Free', marginTop: 0, fontSize: 30),
                renderTextField(
                  hintText: 'Email',
                  controller: emailController,
                  isObscured: false,
                  password: emailNotifier,
                ),
                renderErrorText(errorText: 'Email'),
                renderTextField(
                  hintText: 'Full Name',
                  controller: fullNameController,
                  isObscured: false,
                  password: emailNotifier,
                ),
                renderErrorText(errorText: 'FullName'),
                renderSelectedDate(controller: dateOfBirthController),
                renderErrorText(errorText: 'DateOfBirth'),
                // renderTextField(
                //   hintText: 'Phone',
                //   controller: phoneController,
                //   isObscured: false,
                //   password: emailNotifier,
                // ),
                // renderErrorText(errorText: 'Phone'),
                renderTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  isObscured: true,
                  password: passwordNotifier,
                ),
                renderErrorText(errorText: 'Password'),
                renderTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  isObscured: true,
                  password: confirmPasswordNotifier,
                ),
                renderErrorText(errorText: 'ConfirmPassword'),
                Spacer(),
                renderTextButton(text: 'Sign Up', function: handleSignUp),
                renderTextButtonSignIn(),
                // Expanded(
                //   child: Container(
                //     color: Colors.red,
                //     child: ListView(
                //       children: [
                //         Image.asset(
                //           "assets/images/bg-register.png",
                //           // width: 325.w,
                //           // height: 254.h,
                //           width: 325.w,
                //           height: 150.h,
                //         ),
                //         // renderTitle(title: 'Sign Up Free', marginTop: 0, fontSize: 44),
                //         renderTextField(
                //           hintText: 'Email',
                //           controller: emailController,
                //           isObscured: false,
                //           password: emailNotifier,
                //         ),
                //         renderErrorText(errorText: 'Email'),
                //         renderTextField(
                //           hintText: 'Full Name',
                //           controller: fullNameController,
                //           isObscured: false,
                //           password: emailNotifier,
                //         ),
                //         renderErrorText(errorText: 'FullName'),
                //         renderSelectedDate(controller: dateOfBirthController),
                //         renderErrorText(errorText: 'DateOfBirth'),
                //         renderTextField(
                //           hintText: 'Phone',
                //           controller: phoneController,
                //           isObscured: false,
                //           password: emailNotifier,
                //         ),
                //         renderErrorText(errorText: 'Phone'),
                //         renderTextField(
                //           hintText: 'Password',
                //           controller: passwordController,
                //           isObscured: true,
                //           password: passwordNotifier,
                //         ),
                //         renderErrorText(errorText: 'Password'),
                //         renderTextField(
                //           hintText: 'Confirm Password',
                //           controller: confirmPasswordController,
                //           isObscured: true,
                //           password: confirmPasswordNotifier,
                //         ),
                //         renderErrorText(errorText: 'ConfirmPassword'),
                //         renderTextButton(text: 'Sign Up', function: handleSignUp),
                //         renderTextButtonSignIn(),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
