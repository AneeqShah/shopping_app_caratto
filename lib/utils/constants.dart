import 'package:flutter/material.dart';

Color primaryColor = const Color(0xff3669C9);
Color textFieldBackGroundColor = const Color(0xffFAFAFA);
final bgColor = const Color.fromARGB(255, 236, 236, 236);

extension padding on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());
}
