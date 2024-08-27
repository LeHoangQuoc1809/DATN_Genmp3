import 'dart:io';

import 'package:client/configs/date_format_config.dart';
import 'package:client/configs/device_size_config.dart';
import 'package:client/configs/ip_config.dart';
import 'package:client/helpers/shared_preferences_helper.dart';
import 'package:client/models/user_model.dart';
import 'package:client/views/components/feature_dialog.dart';
import 'package:client/views/pages/forgot_password_page.dart';
import 'package:client/views/pages/onboarding_page.dart';
import 'package:client/views/pages/register_page.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:client/resources/images.dart' as image_constants;
import 'package:client/resources/colors.dart' as color_constants;
import 'package:google_fonts/google_fonts.dart';

import '../../modelViews/modelViews_mng.dart';
import '../../models/static_data_model.dart';
import '../../models/user_model.dart';
import '../components/components.dart';
import 'main_page.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginWithPassword = false;
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  Map<String, String> errorTexts = {'Email': '', 'Password': ''};

  // String errorTextEmail = '';
  // String errorTextPassword = '';
  ValueNotifier<bool> emailNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> passwordNotifier = ValueNotifier<bool>(true);
  bool _rememberMe = false;
  String? _sessionId;
  late SharedPreferences _prefs;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNotifier.dispose();
    passwordNotifier.dispose();
    super.dispose();
  }

  Future<void> fetchAdditionalUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me?personFields=birthdays,phoneNumbers'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('User Data: $data');
    } else {
      print('Failed to fetch user info: ${response.statusCode}');
    }
  }

  Future<void> handleLoginWithGoogle(BuildContext context) async {
    print('-----------------------------------handleLoginWithGoogle-----------------------------------');
    String _email = '';
    String _displayName = '';
    DateTime _birthDate = DateTime.now();
    String? _phone;
    String? _password = '';
    String _imageUrl = '';
    String _picture = '';
    String pictureBase64 = '';
    try {
      print('-----------------------step 1-----------------------');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
          // 'https://www.googleapis.com/auth/user.phonenumbers.read',
          'https://www.googleapis.com/auth/user.birthday.read',
        ],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        print('googleUser: ${googleUser}');
        // Lấy displayName và email từ googleUser
        _displayName = googleUser.displayName ?? '';
        print("_displayName: ${_displayName}");
        _email = googleUser.email ?? '';
        print("_email: ${_email}");
        // kiểm tra nếu email này đã được tạo user hay chưa rồi thì tiến hành
        // vào app, chưa thì tiến hành tạo
        User? existingUserByEmail = await ModelviewsManager.userModelview.getUserByEmail(email: _email);
        if (existingUserByEmail != null) {
          // đã create
          // gọi
          StaticData.currentlyUser = existingUserByEmail;
          print("StaticData.currentlyUser: ${StaticData.currentlyUser}");
          // lưu user vào SharedPreferencesHelper
          SharedPreferencesHelper.setUser(existingUserByEmail);
          //
          Navigator.of(context).popUntil((r) => false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        } else {
          // Lấy imageUrl từ googleUser
          _imageUrl = googleUser.photoUrl ?? '';
          print("_imageUrl: ${_imageUrl}");
          // Nếu có _imageUrl, thực hiện tải hình ảnh về và encode thành base64
          if (_imageUrl.isNotEmpty) {
            final response = await http.get(Uri.parse(_imageUrl));
            if (response.statusCode == 200) {
              // Encode hình ảnh thành base64
              pictureBase64 = base64Encode(response.bodyBytes);
              print("pictureBase64: ${pictureBase64}");
            } else {
              print('Failed to load image: ${response.statusCode}');
            }
          }

          print('-----------------------step 2-----------------------');
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          print('googleAuth: ${googleAuth}');
          print('googleAuth.idToken: ${googleAuth.idToken}');
          // Fetch user profile from Google People API để lấy thông tin về birthdate
          try {
            final response = await http.get(
              Uri.parse('https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,birthdays'),
              headers: await googleUser.authHeaders,
            );

            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('User info: $data');

              // Lấy ngày sinh
              final birthdays = data['birthdays'];
              if (birthdays != null && birthdays.isNotEmpty) {
                final firstBirthday = birthdays[0];
                final date = firstBirthday['date'];
                if (date != null) {
                  final year = date['year'];
                  final month = date['month'];
                  final day = date['day'];
                  if (year != null && month != null && day != null) {
                    _birthDate = DateTime(year, month, day);
                    print('_birthDate: $_birthDate');
                  }
                }
              }

              // Xử lý ảnh đại diện
              _picture = pictureBase64.isEmpty ? 'av-none' : _email;
              print("_picture: ${_picture}");

              // Yêu cầu tạo mật khẩu cho user khi đăng nhập bằng google
              await showDialog(
                  context: context,
                  barrierDismissible: false, // Không cho phép đóng dialog khi bấm ra ngoài
                  builder: (BuildContext context) {
                    return FeatureDialogCreateNewPassword(
                      onPasswordEntered: (enteredPassword) {
                        setState(() {
                          _password = enteredPassword;
                        });
                      },
                    );
                  });

              // Kiểm tra tra _password đã được nhập hay chưa, nếu rồi tạo user, ngược lại không làm gì
              print('_password: ${_password}');
              if (_password != '') {
                // Tạo đối tượng User
                User user = User(
                  email: _email,
                  name: _displayName,
                  birthdate: _birthDate,
                  phone: null,
                  password: _password!,
                  picture: _picture,
                  user_type_id: 1,
                );
                print('user: ${user}');

                // Gọi hàm create user từ modelView
                User? userResponse = await ModelviewsManager.userModelview
                    .createUserForLoginWithGoogle(pictureBase64: pictureBase64, user: user);
                print('userResponse: ${userResponse}');
                if (userResponse != null) {
                  // tạo user thành công
                  StaticData.currentlyUser = userResponse;
                  print("StaticData.currentlyUser: ${StaticData.currentlyUser}");
                  // lưu user vào SharedPreferencesHelper
                  SharedPreferencesHelper.setUser(userResponse);
                  //
                  Navigator.of(context).popUntil((r) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                } else {
                  // tạo user thất bại
                  showSnackBar(
                    context: context,
                    message: 'Lỗi tạo user thất bại',
                    color: Colors.orange[700]!,
                  );
                }
              }
            } else {
              print('Failed to fetch user info: ${response.statusCode}');
              print('Response body: ${response.body}');
              print('Response headers: ${response.headers}');
              showSnackBar(
                context: context,
                message: 'Failed to fetch user info để lấy birthdate',
                color: Colors.orange[700]!,
              );
            }
          } catch (e) {
            print('Exception occurred: $e');
            showSnackBar(
              context: context,
              message: 'Error fetching user info',
              color: Colors.orange[700]!,
            );
          }
        }
      }
      await googleSignIn.signOut();
    } catch (e) {
      print('Google Sign-In Error: $e');
      showSnackBar(
        context: context,
        message:
            'Một cái gì đó không hoạt động. Điều này có thể là do lỗi kỹ thuật mà chúng tôi đang cố gắng giải quyết.: $e',
        color: Colors.orange[700]!,
      );
    }
  }

  Future<void> handleLoginWithFacebook(BuildContext context) async {
    // String _email = '';
    // String _name = '';
    // DateTime _birthDate = DateTime.now();
    // String? _phone;
    // String _imageUrl = '';
    // String _picture = '';
    // String pictureBase64 = '';
    // print('-----------------------------------handleLoginWithFacebook-----------------------------------');
    // try {
    //   print('-----------------------step 1-----------------------');
    //   final LoginResult result = await FacebookAuth.instance.login(
    //     // permissions: ['email'], // Request email
    //     permissions: ['email', 'user_birthday'], // Request email and user birthday
    //   );
    //   if (result.status == LoginStatus.success) {
    //     final AccessToken accessToken = result.accessToken!;
    //     // Dùng accessToken để xác thực hoặc lấy thông tin người dùng
    //     final userData = await FacebookAuth.instance.getUserData();
    //     print('userData: ${userData}');
    //     // Lấy name và email từ userData
    //     _name = userData['name'] ?? '';
    //     print("_name: ${_name}");
    //     _email = userData['email'] ?? '';
    //     print("_email: ${_email}");
    //     _imageUrl = userData['picture']['data']['url'] ?? '';
    //     print("_imageUrl: ${_imageUrl}");
    //     // Kiểm tra và chuyển đổi birthDate từ String sang DateTime
    //     if (userData.containsKey('birthday')) {
    //       String birthDateStr = userData['birthday'] ?? '';
    //       print("_birthDate (raw): ${birthDateStr}");
    //       if (birthDateStr.isNotEmpty) {
    //         try {
    //           _birthDate = DateFormat("MM/dd/yyyy").parse(birthDateStr);
    //           print("_birthDate: ${_birthDate}");
    //         } catch (e) {
    //           print("Failed to parse birthDate: $e");
    //         }
    //       } else {
    //         print("_birthDate: Không có ngày sinh");
    //       }
    //     } else {
    //       print("_birthDate: Trường ngày sinh không tồn tại");
    //     }
    //     if (_email.isEmpty) {
    //       // Gọi hàm dialog để yêu cầu nhập thông tin cần thiết của 1 user
    //       await showDialog(
    //           context: context,
    //           barrierDismissible: false, // Không cho phép đóng dialog khi bấm ra ngoài
    //           builder: (BuildContext context) {
    //             return FeatureDialogEmail(
    //               title: "Completed, next please provide us with your email.",
    //               hintTextEmail: "Enter your email",
    //               onEmailEntered: (enteredEmail) {
    //                 setState(() {
    //                   _email = enteredEmail;
    //                 });
    //               },
    //             );
    //           });
    //     }
    //     // Nếu có _imageUrl, thực hiện tải hình ảnh về và encode thành base64
    //     if (_imageUrl.isNotEmpty) {
    //       final response = await http.get(Uri.parse(_imageUrl));
    //       if (response.statusCode == 200) {
    //         // Encode hình ảnh thành base64
    //         pictureBase64 = base64Encode(response.bodyBytes);
    //         print("pictureBase64: ${pictureBase64}");
    //       } else {
    //         print('Failed to load image: ${response.statusCode}');
    //       }
    //     }
    //     // Xử lý ảnh đại diện
    //     _picture = pictureBase64.isEmpty ? 'av-none' : _email;
    //     print("_picture: ${_picture}");
    //   } else {
    //     print("Facebook login failed: ${result.status} - ${result.message}");
    //     // Handle login failure
    //   }
    // } catch (e, stackTrace) {
    //   print("Exception during Facebook login: $e");
    //   print("StackTrace: $stackTrace");
    //   // Handle exceptions
    // }
    showSnackBar(
      context: context,
      message:
          'Một cái gì đó không hoạt động. Điều này có thể là do lỗi kỹ thuật mà chúng tôi đang cố gắng giải quyết.',
      color: Colors.orange[700]!,
    );
  }

  Future<void> handleLoginWithApple(BuildContext context) async {
    print('-----------------------------------handleLoginWithApple-----------------------------------');
    showSnackBar(
      context: context,
      message:
          'Một cái gì đó không hoạt động. Điều này có thể là do lỗi kỹ thuật mà chúng tôi đang cố gắng giải quyết.',
      color: Colors.orange[700]!,
    );
  }

  void handleLoginWithPassword() {
    print('-----------------------------------handleLoginWithPassword-----------------------------------');
    setState(() {
      isLoginWithPassword = true;
      print('isLoginWithPassword: ${isLoginWithPassword}');
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

  void clearTextError() {
    print('-----------------------------------clearTextError-----------------------------------');
    setState(() {
      errorTexts.forEach((key, value) {
        errorTexts[key] = '';
      });
    });
  }

  void clearTextField() {
    print('-----------------------------------clearTextField-----------------------------------');
    setState(() {
      emailController.text = '';
      passwordController.text = '';
    });
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _connectWebSocket({required String email}) async {
    try {
      print('Vừa vào _connectWebSocket');
      String ip = IpConfig.ip.substring(7);
      print('ip:{$ip}');
      // final WebSocket socket = await WebSocket.connect('ws://192.168.0.106:8000/api/v0/websockets/websocket/$email');
      final WebSocket socket = await WebSocket.connect('ws://$ip/api/v0/websockets/websocket/$email');
      print('WebSocket connected successfully');

      socket.listen((data) {
        print('Data received from WebSocket: $data');
        try {
          final message = jsonDecode(data);
          print('Parsed message: $message');
          if (message['type'] == 'logout' && message['session_id'] == _sessionId) {
            print('Logout message detected');
            _logout(); // Xử lý đăng xuất khi nhận thông báo từ server
          }
        } catch (e) {
          print('Error parsing message: $e');
        }
      }, onDone: () {
        print('WebSocket connection closed, reconnecting...');
        _connectWebSocket(email: email); // Tự động kết nối lại khi kết nối bị đóng
      }, onError: (error) {
        print('WebSocket error: $error');
      });
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  Future<void> _logout() async {
    // Xóa thông tin phiên đăng nhập
    await _prefs.remove('session_id');
    // xóa user khỏi StaticData
    StaticData.currentlyUser = null;
    // xóa user khỏi SharedPreferences
    SharedPreferencesHelper.removeUser();
    //
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => OnboardingPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> handleLogin() async {
    // Kiểm tra xem _prefs đã được khởi tạo chưa
    if (!_prefs.containsKey('session_id')) {
      await _initializePrefs();
    }
    final _email = emailController.text.toLowerCase();
    final _password = passwordController.text;
    print('-----------------------------------handleLogin-----------------------------------');
    setState(() {
      errorTexts['Email'] = _email.isEmpty
          ? 'Email cannot be empty'
          : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)
              ? 'Invalid email'
              : '';
      errorTexts['Password'] = _password.isEmpty
          ? 'Password cannot be empty'
          : _password.length < 8
              ? 'Password must have at least 8 characters'
              : '';
    });
    // Kiểm tra nếu không có lỗi
    if (errorTexts.values.every((error) => error.isEmpty)) {
      print('---------------Tất cả đã được fill, gửi yêu cầu đăng nhập thôi-------------------');
      print('---------------------------------------------------------------------------------');
      print('-------------------Email: ${_email}-------------------');
      print('---------------------------------------------------------------------------------');
      print('-------------------Password: ${_password}-------------------');
      print('---------------------------------------------------------------------------------');
      User? userForLogin =
          await ModelviewsManager.userModelview.getUserForLoginWithPassword(email: _email, password: _password);
      if (userForLogin != null) {
        // tồn tại user tức là đăng nhập đúng email và mật khẩu
        String? sessionId = await ModelviewsManager.userModelview.loginWithPassword(email: _email, password: _password);
        await _prefs.setString('session_id', sessionId!);
        // Mở kết nối WebSocket
        print('Đang gọi _connectWebSocket');
        await _connectWebSocket(email: _email);
        print('Đã gọi _connectWebSocket');
        //
        StaticData.currentlyUser = userForLogin;
        // lưu user vào SharedPreferencesHelper
        SharedPreferencesHelper.setUser(userForLogin);
        //
        Navigator.of(context).popUntil((r) => false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        // sai email hoặc mật khẩu
        setState(() {
          errorTexts['Password'] = "Wrong email or password!";
        });
      }
    }
    // if (_email.isEmpty) {
    //   setState(() {
    //     errorTexts['Email'] = 'Email cannot be empty';
    //   });
    // } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)) {
    //   setState(() {
    //     errorTexts['Email'] = 'Email invalid';
    //   });
    // }
    // if (_password.isEmpty) {
    //   setState(() {
    //     errorTexts['Password'] = 'Password cannot be empty';
    //   });
    // } else if (_password.length < 8) {
    //   setState(() {
    //     errorTexts['Password'] = 'Password must have at least 8 characters';
    //   });
    // } else {}
  }

  void handleForgotThePassword() async {
    print('-----------------------------------handleForgotThePassword-----------------------------------');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(),
        ));
  }

  Future<void> handleSignUp() async {
    print('-----------------------------------handleSignUp-----------------------------------');
    clearTextError();
    clearTextField();
    setState(() {
      isLoginWithPassword = false;
    });
    // Sử dụng hàm setState để chờ animation hoàn thành
    // Đảm bảo animation đã hoàn thành trước khi gọi Navigator.push
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
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
      alignment: isLoginWithPassword ? Alignment.center : null,
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

  Widget renderButtonWith({
    required String icon,
    required VoidCallback function,
  }) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 19.h,
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
                65.w,
                0.h,
                15.w,
                0.h,
              ),
              child: Image.asset(
                'assets/images/ic-${icon}.png',
                width: 33.w,
                height: 33.h,
                color: Colors.transparent,
              ),
            ),
            Text(
              'Continue with ${icon[0].toUpperCase() + icon.substring(1)}',
              style: GoogleFonts.mulish(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget render___or____() {
    return Container(
      height: 58.h,
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 12.w,
            ),
            width: 150.w, // Width of VerticalDivider
            height: 1.h, // Height of VerticalDivider
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Text(
            'or',
            style: GoogleFonts.mulish(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 12.w,
            ),
            width: 150.w, // Width of VerticalDivider
            height: 1.h, // Height of VerticalDivider
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }

  Widget renderTextButton({
    required String text,
    required Function function,
  }) {
    return Container(
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

  Widget renderCheckboxRememberMe() {
    return Container(
      height: 46.h,
      //color: Colors.redAccent,
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(-14.w, -13.h),
        // Di chuyển sang trái 14.w và lên trên 13.h
        child: CheckboxListTile(
          title: Transform.translate(
            offset: Offset(-15.w, 0.h),
            // Di chuyển sang trái 15.w
            child: Text(
              "Remember me",
              style: TextStyle(
                fontFamily: 'CenturyGothicRegular',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          value: _rememberMe,
          onChanged: (newValue) {
            setState(() {
              _rememberMe = newValue!;
              print('--------------------_rememberMe--------------------------${_rememberMe}------------------------');
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color.fromARGB(255, 6, 160, 181),
        ),
      ),
    );
  }

  Widget renderTextButtonForgotThePassword() {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
      ),
      height: 40.h,
      // color: Colors.green,
      child: TextButton(
        onPressed: handleForgotThePassword,
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
    );
  }

  Widget render___OrContinueWith____() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.h,
      ),
      height: 20.h,
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 9.w,
            ),
            width: 101.w, // Width of VerticalDivider
            height: 1.h, // Height of VerticalDivider
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Text(
            'or continue with',
            style: TextStyle(
              fontFamily: 'CenturyGothicRegular',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 9.w,
            ),
            width: 101.w, // Width of VerticalDivider
            height: 1.h, // Height of VerticalDivider
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }

  Widget renderTextButtonSignUp() {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
      ),
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: GoogleFonts.mulish(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextButton(
            onPressed: handleSignUp,
            child: Text(
              'Sign Up',
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
    _initializePrefs();
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------Build LoginPage----------------------------------');
    return Scaffold(
      resizeToAvoidBottomInset: false, // Tắt tính năng đẩy component khi bật bàn phím
      // appBar: AppBar(
      //   toolbarHeight: 38.h ,
      //   leading: IconButton(
      //     onPressed: () {
      //       if (isLoginWithPassword) {
      //         setState(() {
      //           isLoginWithPassword = false;
      //         });
      //       } else {
      //         Navigator.pop(context);
      //       }
      //     },
      //     icon: Icon(
      //       Icons.arrow_back,
      //       size: 32.w ,
      //     ),
      //     color: Colors.white,
      //   ),
      //   backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      // ),
      body: GestureDetector(
        onTap: () {
          onDismissKeyboard(context);
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                25.w,
                0.h,
                25.w,
                0.h,
              ),
              width: 428.w,
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
                          if (isLoginWithPassword) {
                            setState(() {
                              isLoginWithPassword = false;
                            });
                            clearTextError();
                            clearTextField();
                          } else {
                            Navigator.pop(context);
                          }
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
                    !isLoginWithPassword ? "assets/images/logo.png" : "assets/images/bg-login-with-password.png",
                    width: !isLoginWithPassword ? 325.w : 260.w,
                    height: !isLoginWithPassword ? 254.h : 200.h,
                  ),
                  if (!isLoginWithPassword) ...[
                    renderTitle(title: 'Let’s get you in', marginTop: 20, fontSize: 44),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20.h,
                      ),
                      width: double.infinity.w,
                      //color: Colors.green,
                      child: Column(
                        children: [
                          renderButtonWith(icon: 'google', function: () => handleLoginWithGoogle(context)),
                          renderButtonWith(icon: 'facebook', function: () => handleLoginWithFacebook(context)),
                          renderButtonWith(icon: 'apple', function: () => handleLoginWithApple(context)),
                          render___or____(),
                          renderTextButton(text: 'Log in with a password', function: handleLoginWithPassword),
                          renderTextButtonSignUp(),
                        ],
                      ),
                    ),
                  ] else ...[
                    renderTitle(title: 'Login to your account', marginTop: 0, fontSize: 30),
                    renderTextField(
                      hintText: 'Email',
                      controller: emailController,
                      isObscured: false,
                      password: emailNotifier,
                    ),
                    renderErrorText(errorText: 'Email'),
                    renderTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscured: true,
                      password: passwordNotifier,
                    ),
                    renderErrorText(errorText: 'Password'),
                    renderCheckboxRememberMe(),
                    renderTextButton(text: 'Log in', function: handleLogin),
                    renderTextButtonForgotThePassword(),
                    render___OrContinueWith____(),
                    Container(
                      height: 50.h,
                      margin: EdgeInsets.only(
                        top: 35.h,
                      ),
                      padding: EdgeInsets.fromLTRB(
                        20.w,
                        0.h,
                        20.w,
                        0.h,
                      ),
                      //color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 30, 30, 30),
                              shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                              border: Border.all(
                                color: const Color.fromARGB(255, 219, 231, 232),
                                width: 0.2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await handleLoginWithGoogle(context);
                              },
                              icon: Image.asset(
                                'assets/images/ic-google.png',
                                width: 30.w,
                                height: 30.h,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 30, 30, 30),
                              shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                              border: Border.all(
                                color: const Color.fromARGB(255, 219, 231, 232),
                                width: 0.2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await handleLoginWithFacebook(context);
                              },
                              icon: Image.asset(
                                'assets/images/ic-facebook.png',
                                width: 30.w,
                                height: 30.h,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 30, 30, 30),
                              shape: BoxShape.circle, // Đặt hình dạng của container thành hình tròn
                              border: Border.all(
                                color: const Color.fromARGB(255, 219, 231, 232),
                                width: 0.2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                handleLoginWithApple(context);
                              },
                              icon: Image.asset(
                                'assets/images/ic-apple.png',
                                width: 30.w,
                                height: 30.h,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    renderTextButtonSignUp(),
                  ]
                ],
              ),
            ),
            AnimatedPositioned(
              top: !isLoginWithPassword ? 476.h : 793.h,
              left: !isLoginWithPassword ? 90.w : 86.w,
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceOut,
              child: GestureDetector(
                onTap: () async {
                  await handleLoginWithGoogle(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0.w,
                    0.h,
                    0.w,
                    0.h,
                  ),
                  child: Image.asset(
                    'assets/images/ic-google.png',
                    width: !isLoginWithPassword ? 33.w : 30.w,
                    height: !isLoginWithPassword ? 33.h : 30.h,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              top: !isLoginWithPassword ? 554.h : 793.h,
              left: !isLoginWithPassword ? 90.w : 199.w,
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceOut,
              child: GestureDetector(
                onTap: () async {
                  await handleLoginWithFacebook(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0.w,
                    0.h,
                    0.w,
                    0.h,
                  ),
                  child: Image.asset(
                    'assets/images/ic-facebook.png',
                    width: !isLoginWithPassword ? 33.w : 30.w,
                    height: !isLoginWithPassword ? 33.h : 30.h,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              // top: !isLoginWithPassword ? 632.h  : 793.h ,
              // left: !isLoginWithPassword ? 90.w  : 312.w ,
              top: !isLoginWithPassword ? 629.h : 791.h,
              left: !isLoginWithPassword ? 90.w : 311.w,
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceOut,
              child: GestureDetector(
                onTap: () async {
                  handleLoginWithApple(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0.w,
                    0.h,
                    0.w,
                    0.h,
                  ),
                  child: Image.asset(
                    'assets/images/ic-apple.png',
                    width: !isLoginWithPassword ? 33.w : 30.w,
                    height: !isLoginWithPassword ? 33.h : 30.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
