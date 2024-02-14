import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';

class CustomTextField extends StatelessWidget {
  final double horPadd;
  final double vertPadd;
  final String? hinText;
  final Icon? icon;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextEditingController? controller;
  final double borderRadius;
  final int lineCount;

  const CustomTextField({
    super.key,
    this.horPadd = 50,
    this.vertPadd = 15,
    this.borderRadius = 0,
    this.hinText,
    this.icon,
    this.validator,
    this.isPassword = false,
    this.controller,
    this.lineCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horPadd,
        right: horPadd,
        top: vertPadd,
      ),
      child: TextFormField(
        minLines: lineCount,
        maxLines: lineCount,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon,
          filled: true,
          fillColor: Palette.lightGreen,
          hintText: hinText,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }
}
