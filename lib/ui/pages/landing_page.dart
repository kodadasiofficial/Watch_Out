import 'package:flutter/material.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/ui/pages/authentication/login.dart';
import 'package:watch_out/ui/pages/main_pages/main_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AuthService().controlCurrentUser()) {
      return const MainPage();
    }
    return const LoginPage();
  }
}
