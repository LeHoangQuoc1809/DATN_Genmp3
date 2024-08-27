import 'dart:async';
import 'dart:convert';

import 'package:client/configs/device_size_config.dart';
import 'package:client/modelViews/modelViews_mng.dart';
import 'package:client/models/static_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../helpers/shared_preferences_helper.dart';
import '../../models/user_model.dart';
import '../components/components.dart';
import 'create_new_password_page.dart';
import 'main_page.dart';

class OtpPage extends StatefulWidget {
  OtpPage({super.key, this.user = null, this.email = '', required this.isForgotPassword});

  User? user;
  String email;
  bool isForgotPassword;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String errorOTP = '';
  int focusIndex = 0;
  List<TextEditingController> OTP_controlerList = [];
  late List<FocusNode> _focusNodes;
  bool isFilled = false;
  int seconds = 0;
  late Timer _timer;
  bool isButtonEnabled = false;

  void _addListeners() {
    for (int i = 0; i < OTP_controlerList.length; i++) {
      OTP_controlerList[i].addListener(() {
        // if (OTP_controlerList[i].text.isNotEmpty && i < OTP_controlerList.length - 1) {
        //   FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        // } else if (OTP_controlerList[i].text.isEmpty && i > 0) {
        //   FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        // }
        // tính hiệu bật tắc nút Send
        setState(() {
          isFilled = true;
          for (var controller in OTP_controlerList) {
            if (controller.text.isEmpty) {
              isFilled = false;
              break;
            }
          }
        });
      });
    }
  }

  void _onOtpChanged({
    required String value,
    required int index,
  }) {
    if (value.isNotEmpty && index < OTP_controlerList.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    // Check if it's the last OTP field
    if (index == OTP_controlerList.length - 1 && value.isNotEmpty) {
      // Unfocus the last field to dismiss keyboard
      _focusNodes[index].unfocus();
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in OTP_controlerList) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          isButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void handleResend() async {
    print('-----------------------------------handleResend-----------------------------------');
    onDismissKeyboard(context);
    if (!widget.isForgotPassword) {
      // Gọi lại api để nhận otp mới từ create user
      bool isCreated =
          await ModelviewsManager.userModelview.validateUserForClient(pictureBase64: '', user: widget.user!);
      if (!isCreated) {
        showSnackBar(
          context: context,
          message:
              'An OTP request has already been made from a different server. Please wait before requesting a new OTP.',
          color: Colors.orange[700]!,
        );
      } else {
        setState(() {
          seconds = widget.isForgotPassword ? 300 : 180;
          isButtonEnabled = false;
        });
        _startTimer();
      }
    } else {
      // Gọi lại api để nhận otp mới từ forgot password
      bool isSend = await ModelviewsManager.userModelview.sendEmailForForgotPassword(user: widget.user!);
      if (!isSend) {
        showSnackBar(
          context: context,
          message:
              'An OTP request has already been made from a different server. Please wait before requesting a new OTP.',
          color: Colors.orange[700]!,
        );
      } else {
        setState(() {
          seconds = widget.isForgotPassword ? 300 : 180;
          isButtonEnabled = false;
        });
        _startTimer();
      }
    }
  }

  Future<void> handleSend() async {
    print('-----------------------------------handleSend-----------------------------------');
    String otp = '';
    OTP_controlerList.forEach((controller) {
      otp += controller.text;
    });
    print('OTP: $otp');
    if (!widget.isForgotPassword) {
      // create user
      User? user = await ModelviewsManager.verifyModelview.otpResendForCreateUser(user: widget.user!, otp: otp);
      if (user != null) {
        // user tồn tại tức là otp đúng và đã create thành công
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(
          context: context,
          message: 'Congratulations! Your account is now active. Log in to start using it',
          color: Colors.green.shade700!,
        );
        // // user tồn tại tức là otp đúng và đã create thành công, gán cho static data
        // StaticData.currentlyUser = user;
        // print("StaticData.currentlyUser: ${StaticData.currentlyUser}");
        // // lưu user vào SharedPreferencesHelper
        // SharedPreferencesHelper.setUser(user);
        // //
        // Navigator.of(context).popUntil((r) => false);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MainPage(),
        //   ),
        // );
      } else {
        // otp sai, cần nhập lại
        setState(() {
          errorOTP = "Wrong OTP, please check again.";
        });
      }
    } else {
      // forgot the password
      bool isTrue = await ModelviewsManager.verifyModelview.otpResendForForgotPassword(user: widget.user!, otp: otp);
      if (isTrue) {
        // Otp đã đúng
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordPage(),
          ),
        );
      } else {
        // otp sai, cần nhập lại
        setState(() {
          errorOTP = "Wrong OTP, please check again.";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    OTP_controlerList = List.generate(6, (index) => TextEditingController());
    _addListeners();
    seconds = widget.isForgotPassword ? 300 : 180;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build OtpPage-----------------------------------');
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
                    //color: Colors.greenAccent,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          errorOTP = '';
                        });
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
                  "assets/images/bg-otp.png",
                  width: 325.w,
                  height: 254.h,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 15.h,
                  ),
                  child: Text(
                    'Enter the 6-digit code we sent to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CenturyGothicRegular',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(200, 255, 255, 255),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.h,
                  ),
                  child: Text(
                    widget.isForgotPassword ? widget.email : widget.user!.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CenturyGothicRegular',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // color: const Color.fromARGB(255, 255, 255, 255),
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
                  ),
                  // color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      OTP_controlerList.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: 30.w,
                          child: TextField(
                            onTap: () {
                              setState(() {
                                errorOTP = '';
                              });
                            },
                            onChanged: (text) {
                              _onOtpChanged(value: text, index: index);
                              // setState(() {
                              //   focusIndex++;
                              // });
                            },
                            // enabled: index == focusIndex || index == focusIndex + 1,
                            autofocus: index == 0,
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textInputAction:
                                index < OTP_controlerList.length - 1 ? TextInputAction.next : TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                9.w,
                                0.h,
                                0.w,
                                0.h,
                              ),
                              fillColor: Colors.grey,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: OTP_controlerList[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
                  ),
                  child: Text(
                    errorOTP,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10.h,
                  ),
                  padding: EdgeInsets.only(
                    right: 50.h,
                  ),
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        '$seconds',
                        style: TextStyle(
                          fontFamily: 'CenturyGothicRegular',
                          fontSize: 16.sp,
                          color: Color.fromARGB(200, 255, 255, 255),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: isButtonEnabled
                            ? () {
                                handleResend();
                              }
                            : null,
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            fontFamily: 'CenturyGothicRegular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isButtonEnabled ? Color.fromARGB(200, 255, 255, 255) : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isFilled,
                  child: Container(
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
                      onPressed: handleSend,
                      child: Text(
                        'Send',
                        style: GoogleFonts.mulish(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
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
