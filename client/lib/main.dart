import 'package:client/provider/GlobalPlaySongSate.dart';
import 'package:client/views/components/ticker_provider.dart';
import 'package:client/views/pages/create_new_password_page.dart';
import 'package:client/views/pages/forgot_password_page.dart';
import 'package:client/views/pages/login_page.dart';
import 'package:client/views/pages/main_page.dart';
import 'package:client/views/pages/register_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'configs/device_size_config.dart';
import 'configs/ip_config.dart';
import 'helpers/shared_preferences_helper.dart';
import 'models/static_data_model.dart';
import 'models/user_model.dart';
import 'views/pages/onboarding_page.dart';

void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: 'AIzaSyDfHH26L-LLD2qcQ3DKeQhTqYasWN4ZNwY',
//       appId: '1:251377553162:android:7079b4644f11c92b5374f3',
//       messagingSenderId: 'project-251377553162',
//       projectId: 'genmp3-e64c3',
//     ),
//   );
  Future<void> initializeCurrentUser() async {
    User? user = await SharedPreferencesHelper.getUser();
    if (user != null) {
      StaticData.currentlyUser = user;
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeCurrentUser();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('vi'), // Vietnamese
        Locale('en'), // English
      ],
      path: 'assets/translations',
      child: CustomTickerProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final tickerProvider = CustomTickerProvider.of(context)!;
    print("--------------------------------Build MyApp--------------------------------------");
    return ScreenUtilInit(
      builder: (_, child) {
        return ChangeNotifierProvider(
          create: (context) => MusicPlayState(tickerProvider: tickerProvider),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StaticData.currentlyUser != null ? MainPage() : const OnboardingPage(),
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
          ),
        );
      },
      // Layout in figma 428,924
      designSize: Size(428, 924),
    );
  }
}
