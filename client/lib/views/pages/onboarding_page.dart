import 'package:client/configs/device_size_config.dart';
import 'package:client/views/pages/login_page.dart';
import 'package:client/views/pages/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _checkAppState(BuildContext context) async {
    final isOnboardingCompleted = await _isOnboardingCompleted();
    if (isOnboardingCompleted) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<bool> _isOnboardingCompleted() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool('isOnboardingCompleted');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _markOnboardingCompleted() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = prefs.setBool('isOnboardingCompleted', true);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkAppState(context);
    print('--------------------------------Build OnboardingPage-----------------------------');
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: 428.w,
            height: 924.h,
            child: Image.asset(
              "assets/images/bg-onboarding.png",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 64.h,
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
                // Navigator.pop(context);
                _markOnboardingCompleted();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                'onboarding_text_button'.tr(),
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
    );
  }
}
