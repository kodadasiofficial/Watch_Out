import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';

class CustomTextField extends StatelessWidget {
  final double horPadd;
  final double vertPadd;
  final String? hinText;
  final Icon? icon;

  const CustomTextField({
    super.key,
    this.horPadd = 50,
    this.vertPadd = 15,
    this.hinText,
    this.icon,
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
        decoration: InputDecoration(
            prefixIcon: icon,
            filled: true,
            fillColor: Palette.lightGreen,
            hintText: hinText,
            border: const UnderlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
