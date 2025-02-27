import 'package:expense_tracker_app/screens/home_screen.dart';
import 'package:expense_tracker_app/screens/onboarding_screen.dart';
import 'package:expense_tracker_app/services/database_helper.dart';
import 'package:expense_tracker_app/services/notification_service.dart';
import 'package:expense_tracker_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await NotificationService.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  runApp(MyApp(seenOnboarding: seenOnboarding));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: seenOnboarding ? const HomeScreen() : OnboardingScreen(),
    );
  }
}