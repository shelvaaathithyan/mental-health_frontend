import 'package:ai_therapy/Controllers/user_controller.dart';
import 'package:ai_therapy/View/home_view.dart';
import 'package:ai_therapy/core/theme.dart';
import 'package:ai_therapy/screens/auth/signin/signin_screen.dart';
import 'package:ai_therapy/screens/auth/signup/signup_screen.dart';
import 'package:ai_therapy/screens/dashboard/mental_health_dashboard_screen.dart';
import 'package:ai_therapy/screens/dashboard/stats/stats_screen.dart';
import 'package:ai_therapy/screens/mindful_hours/mindful_hours_screen.dart';
import 'package:ai_therapy/screens/mindful_hours/mindful_hours_stats_screen.dart';
import 'package:ai_therapy/screens/mood_tracker/mood_tracker_screen.dart';
import 'package:ai_therapy/screens/onboarding/onboarding_screen.dart';
import 'package:ai_therapy/screens/splash/splash_sequence_screen.dart';
import 'package:ai_therapy/screens/therapy_chatbot/therapy_chatbot_screen.dart';
import 'package:ai_therapy/screens/sleep_quality/sleep_quality_overview_screen.dart';
import 'package:ai_therapy/screens/mood_tracker/mood_tracker_screen.dart';

import 'package:ai_therapy/screens/onboarding/assessment/assessment_flow_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/sleep_quality/sleep_quality_history_screen.dart';
import 'screens/sleep_quality/sleep_quality_tips_screen.dart';
import 'screens/journal/journal_overview_screen.dart';
import 'screens/journal/journal_stats_screen.dart';
import 'screens/journal/journal_new_screen.dart';
import 'screens/journal/journal_voice_screen.dart';
import 'screens/journal/journal_text_screen.dart';
import 'screens/journal/journal_detail_screen.dart';
import 'screens/stress/stress_level_screen.dart';
import 'screens/stress/stress_level_input_screen.dart';
import 'screens/stress/stress_select_stressors_screen.dart';
import 'Controllers/journal_controller.dart';
import 'screens/profile/profile_screen.dart';

//import math

void main() async {
  //Ensure flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  Get.put(UserController(), permanent: true);
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
    // Ensure controllers are registered early
    Get.put(JournalController(), permanent: true);
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
          name: SignInScreen.routeName,
          page: () => const SignInScreen(),
        ),
        GetPage(
          name: SignUpScreen.routeName,
          page: () => const SignUpScreen(),
        ),
        GetPage(
          name: AssessmentFlowScreen.routeName,
          page: () => const AssessmentFlowScreen(),
        ),
        GetPage(
          name: MoodTrackerScreen.routeName,
          page: () => const MoodTrackerScreen(),
        ),
        GetPage(name: HomeView.routeName, page: () => const HomeView()),
        GetPage(
          name: MentalHealthDashboardScreen.routeName,
          page: () => const MentalHealthDashboardScreen(),
        ),
        // Alias route for dashboard navigation
        GetPage(
          name: '/dashboard',
          page: () => const HomeView(),
        ),
        GetPage(name: ProfileScreen.routeName, page: () => const ProfileScreen()),
        GetPage(
          name: StatsScreen.routeName,
          page: () => const StatsScreen(),
        ),
        GetPage(
          name: MindfulHoursScreen.routeName,
          page: () => const MindfulHoursScreen(),
        ),
        GetPage(
          name: MoodTrackerScreen.routeName,
          page: () => const MoodTrackerScreen(),
        ),
        GetPage(
          name: MindfulHoursStatsScreen.routeName,
          page: () => const MindfulHoursStatsScreen(),
        ),
        GetPage(
          name: TherapyChatbotScreen.routeName,
          page: () => const TherapyChatbotScreen(),
        ),
        GetPage(
          name: SleepQualityOverviewScreen.routeName,
          page: () => const SleepQualityOverviewScreen(),
        ),
        GetPage(
          name: SleepQualityHistoryScreen.routeName,
          page: () => const SleepQualityHistoryScreen(),
        ),
        GetPage(
          name: SleepQualityTipsScreen.routeName,
          page: () => const SleepQualityTipsScreen(),
        ),
        GetPage(name: JournalOverviewScreen.routeName, page: () => const JournalOverviewScreen()),
        GetPage(name: JournalStatsScreen.routeName, page: () => const JournalStatsScreen()),
        GetPage(name: JournalNewScreen.routeName, page: () => const JournalNewScreen()),
        GetPage(name: JournalVoiceScreen.routeName, page: () => const JournalVoiceScreen()),
        GetPage(name: JournalTextScreen.routeName, page: () => const JournalTextScreen()),
        GetPage(name: JournalDetailScreen.routeName, page: () => const JournalDetailScreen()),
        // Stress management
        GetPage(name: StressLevelScreen.routeName, page: () => const StressLevelScreen()),
        GetPage(name: StressLevelInputScreen.routeName, page: () => const StressLevelInputScreen()),
        GetPage(name: SelectStressorsScreen.routeName, page: () => const SelectStressorsScreen()),
      ],
    );
  }
}
