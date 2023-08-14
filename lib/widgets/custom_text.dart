import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign? textAlign;

  const CustomText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.fontWeight,
      required this.textColor,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: fontSize, color: textColor),
    );
  }
}
