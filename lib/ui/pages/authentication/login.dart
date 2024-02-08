import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/ui/widgets/custom_button.dart';
import 'package:watch_out/ui/widgets/custom_text_field.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/ui/widgets/social_media.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double leftPadd = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loginText(),
                  loginForm(),
                  forgotPassword(),
                  CustomButton(
                    onPressed: () {},
                    text: "Sign In",
                    height: 45,
                  ),
                ],
              ),
            ),
            const SocialMediaConnection(),
          ],
        ),
      ),
    );
  }

  Widget loginText() {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadd,
      ),
      child: Text(
        "Login to your account",
        style: TextStyle(
          fontSize: Font.loginFontSize,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget loginForm() {
    return Form(
      child: Column(
        children: const [
          CustomTextField(
            hinText: "Email",
            icon: Icon(
              Icons.mail,
              color: Colors.white,
            ),
          ),
          CustomTextField(
            hinText: "Password",
            icon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: EdgeInsets.only(left: leftPadd),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: RichText(
          text: TextSpan(
            text: "Forgot Password?",
            style: TextStyle(
              color: Palette.darkGreen,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ),
      ),
    );
  }
}
