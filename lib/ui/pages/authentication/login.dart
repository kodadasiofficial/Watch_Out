import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/ui/widgets/custom_button.dart';
import 'package:watch_out/ui/widgets/custom_text_field.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';
import 'package:watch_out/ui/widgets/social_media.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double leftPadd = 50;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        AuthService().signIn(
                            context, emailController.text, passController.text);
                      }
                    },
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

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Palette.buttonGreen,
        content: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
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
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hinText: "Email",
            icon: const Icon(
              Icons.mail,
              color: Colors.white,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Email field cannot be empty";
              } else if (!EmailValidator.validate(value!)) {
                return "Please write a valid email";
              } else {
                return null;
              }
            },
            controller: emailController,
          ),
          CustomTextField(
            hinText: "Password",
            isPassword: true,
            icon: const Icon(
              Icons.lock,
              color: Colors.white,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Password field cannot be empty";
              } else if (value!.length <= 6) {
                return "Password length must be more than six";
              } else {
                return null;
              }
            },
            controller: passController,
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
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (emailController.text.isEmpty) {
                  CustomSnackBar.showSnackBar(
                      context, "Email field cannot be empty");
                } else if (!EmailValidator.validate(emailController.text)) {
                  CustomSnackBar.showSnackBar(
                      context, "Please write a valid email");
                } else {
                  AuthService().resetPassword(context, emailController.text);
                }
              },
          ),
        ),
      ),
    );
  }
}
