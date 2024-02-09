import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/firebase/personal_infos.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool controlCurrentUser() {
    return _auth.currentUser != null;
  }

  Future<void> signUp(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool res = await PersonalInfos().savePersonalInfos(context, name, email);
      if (res) {
        Navigator.pushNamed(context, "/mainPage");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        CustomSnackBar.showSnackBar(context, "This account is already exist");
      } else {
        CustomSnackBar.showSnackBar(
            context, "Something get wrong. Please try again");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Something get wrong. Please try again");
    }
  }

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, "/mainPage");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBar.showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        CustomSnackBar.showSnackBar(
            context, "Wrong password provided for that user.");
      } else {
        CustomSnackBar.showSnackBar(
            context, "Your email or password are wrong");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(context, "Your email or password are wrong");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        var data = user.providerData[0];
        bool isEmailExist = await PersonalInfos().isEmailExist(data.email);

        if (!isEmailExist) {
          bool res = await PersonalInfos().savePersonalInfos(
            context,
            data.displayName,
            data.email,
          );
          if (res) {
            Navigator.pushNamed(context, "/mainPage");
          }
        } else {
          Navigator.pushNamed(context, "/mainPage");
        }
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Something went wrong. Please try again.");
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CustomSnackBar.showSnackBar(
          context, "Password reset email sended to your mail.");
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Reset email can't send. Please try again.");
    }
  }
}
