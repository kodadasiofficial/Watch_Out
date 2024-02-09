import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/firebase/auth.dart';
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
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
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
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  signUpText(),
                  signUpForm(),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        AuthService().signUp(context, nameController.text,
                            emailController.text, passController.text);
                      }
                    },
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
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hinText: "Name",
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Email field cannot be empty";
              } else {
                return null;
              }
            },
            controller: nameController,
          ),
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
}
