import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_out/ui/pages/app_bar_pages/settings.dart';
import 'package:watch_out/ui/pages/authentication/login.dart';
import 'package:watch_out/ui/pages/authentication/signup.dart';
import 'package:watch_out/ui/pages/landing_page.dart';
import 'package:watch_out/ui/pages/main_pages/main_page.dart';
import 'constants/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WatchOut());
}

class WatchOut extends StatelessWidget {
  const WatchOut({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );
    return MaterialApp(
      title: "Watch Out",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LandingPage(),
        "/login": (context) => const LoginPage(),
        "/signUp": (context) => const SignUpPage(),
        "/mainPage": (context) => const MainPage(),
        "/settingsPage": (context) => const SettingsPage()
      },
    );
  }
}
