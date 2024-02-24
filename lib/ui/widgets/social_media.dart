import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/backend/firebase/auth.dart';

class SocialMediaConnection extends StatelessWidget {
  final bool isRegister;

  const SocialMediaConnection({
    Key? key,
    this.isRegister = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            isRegister ? "-Or Connect With-" : "-Or Sign In With-",
            style: TextStyle(
              fontSize: Font.loginFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => AuthService().signInWithGoogle(context),
                icon: Image.asset("assets/images/google.png"),
              ),
              const SizedBox(width: 30),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/facebook.png"),
              ),
              const SizedBox(width: 30),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/apple.png"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: isRegister
                      ? "Already have an account? "
                      : "Don't you have an account? ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Font.loginFontSize,
                  ),
                ),
                TextSpan(
                  text: isRegister ? "Sign In" : "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Font.loginFontSize,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => isRegister
                        ? Navigator.pushNamed(context, "/login")
                        : Navigator.pushNamed(context, "/signUp"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
