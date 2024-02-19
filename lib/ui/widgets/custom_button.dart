import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';

class CustomButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String? text;
  final double width;
  final double height;
  final TextStyle textStyle;
  final double borderRadius;
  final void Function() onPressed;
  final Alignment alignment;
  final Color? color;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.padding = const EdgeInsets.only(
      top: 10,
      left: 50,
      right: 50,
    ),
    this.text,
    this.width = double.maxFinite,
    this.height = double.maxFinite,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
    this.borderRadius = 0,
    this.alignment = Alignment.center,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: color ?? Palette.buttonGreen,
          fixedSize: Size(width, height),
        ),
        onPressed: onPressed,
        child: Text(
          text ?? "",
          style: textStyle,
        ),
      ),
    );
  }
}
