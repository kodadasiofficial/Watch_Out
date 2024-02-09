import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String text) {
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
}
