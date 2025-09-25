import 'package:ai_therapy/View/home_view.dart';
import 'package:ai_therapy/core/theme.dart';
import 'package:ai_therapy/screens/onboarding/onboarding_screen.dart';
import 'package:ai_therapy/screens/splash/splash_sequence_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//import math

void main() async {
  //Ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  var firstTime = true;

  @override
  void initState() {
    if (box.read("firstTime") != null) {
      firstTime = box.read("firstTime");
    } else {
      box.write("firstTime", false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emma',
      debugShowCheckedModeBanner: false,
      theme: FreudTheme.light(),
      home: SplashSequenceScreen(isFirstTime: firstTime),
      getPages: [
        GetPage(
          name: OnboardingScreen.routeName,
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: HomeView.routeName,
          page: () => const HomeView(),
        ),
      ],
    );
  }
}
