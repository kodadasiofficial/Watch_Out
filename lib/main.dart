import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_out/ui/pages/authentication/login.dart';
import 'package:watch_out/ui/pages/authentication/signup.dart';
import 'constants/palette.dart';
import 'package:flutter/services.dart';

void main() {
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
        "/": (context) => const LoginPage(),
        "/signUp": (context) => const SignUpPage(),
      },
    );
  }
}
