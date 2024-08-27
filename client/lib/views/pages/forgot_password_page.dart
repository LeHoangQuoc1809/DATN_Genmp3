import 'package:client/views/pages/otp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../modelViews/modelViews_mng.dart';
import '../../models/user_model.dart';
import '../components/components.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController(text: '');
  String errorEmail = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void handleSend() async {
    print('-----------------------------------handleSend-----------------------------------');
    onDismissKeyboard(context);
    final _email = emailController.text;
    setState(() {
      errorEmail = _email.isEmpty
          ? 'Email cannot be empty'
          : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)
              ? 'Invalid email'
              : '';
    });
    // Kiểm tra nếu không có lỗi
    if (errorEmail.isEmpty) {
      print('-------------------Email: ${_email}-------------------');
      print('---------------------------------------------------------------------------------');
      User? existingUserByEmail = await ModelviewsManager.userModelview.getUserByEmail(email: _email);
      if (existingUserByEmail == null) {
        // Email chưa được đăng ký
        setState(() {
          errorEmail = 'Email is not registered';
        });
      } else {
        // Email đã được đăng ký
        bool isSend = await ModelviewsManager.userModelview.sendEmailForForgotPassword(user: existingUserByEmail);
        if (isSend) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                user: existingUserByEmail,
                email: _email,
                isForgotPassword: true,
              ),
            ),
          );
        } else {
          setState(() {
            errorEmail =
                'An OTP request has already been made from a different server. Please wait before requesting a new OTP.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build ForgotPasswordPage-----------------------------------');
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
                // Transform.translate(
                //   offset: Offset(-25.w, -0.h),
                //   // Di chuyển sang trái 25.w và lên trên 0.h
                //   child: Container(
                //     alignment: Alignment.bottomLeft,
                //     height: 80.h,
                //     margin: EdgeInsets.fromLTRB(
                //       25.w,
                //       0.h,
                //       0.w,
                //       0.h,
                //     ),
                //     // color: Colors.greenAccent,
                //     child: Row(
                //       children: [
                //         Container(
                //           alignment: Alignment.bottomLeft,
                //           // color: Colors.black,
                //           child: GestureDetector(
                //             onTap: () {
                //               Navigator.pop(context);
                //             },
                //             child: Icon(
                //               Icons.arrow_back,
                //               size: 32.w,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //         Expanded(
                //           child: Container(
                //             alignment: Alignment.bottomCenter,
                //             // color: Colors.red,
                //             child: Text(
                //               'Forgot The Password',
                //               style: TextStyle(
                //                 fontFamily: 'CenturyGothicRegular',
                //                 fontSize: 23.sp,
                //                 fontWeight: FontWeight.bold,
                //                 color: const Color.fromARGB(255, 255, 255, 255),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                  "assets/images/bg-forgot-password.png",
                  // width: 260.w,
                  // height: 200.h,
                  width: 260.w,
                  height: 250.h,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 0.h,
                  ),
                  width: double.infinity,
                  height: 89.h,
                  alignment: Alignment.center,
                  // color: Colors.redAccent,
                  //alignment: Alignment.topCenter,
                  child: Text(
                    'Forgot The Password',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'CenturyGothicRegular',
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 0.h,
                  ),
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
                          'assets/images/ic-email.png',
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
                            setState(() {
                              errorEmail = '';
                            });
                          },
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40), // giới hạn số lượng ký tự là 40
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // Loại bỏ khoảng trắng
                          ],
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
                            hintText: 'Email',
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
                          ),
                          controller: emailController,
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
                ),
                Container(
                  // height: 23.h,
                  alignment: Alignment.topLeft,
                  //color: Colors.green,
                  margin: EdgeInsets.fromLTRB(
                    48.w,
                    0.h,
                    48.w,
                    0.h,
                  ),
                  child: Text(
                    errorEmail,
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
