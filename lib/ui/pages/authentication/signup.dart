import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/ui/widgets/custom_button.dart';
import 'package:watch_out/ui/widgets/custom_text_field.dart';
import 'package:watch_out/ui/widgets/social_media.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  signUpText(),
                  signUpForm(),
                  CustomButton(
                    onPressed: () {},
                    text: "Create Account",
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 50,
                      right: 50,
                    ),
                  ),
                ],
              ),
            ),
            const SocialMediaConnection(
              isRegister: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpText() {
    return Column(
      children: [
        Text(
          "Sign Up Now",
          style: TextStyle(
            fontSize: Font.signUpFontSize,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 5),
        Text(
          "Create your account",
          style: TextStyle(
            fontSize: Font.createAccountFontSize,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget signUpForm() {
    return Form(
      child: Column(
        children: const [
          CustomTextField(
            hinText: "Name",
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
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
}
