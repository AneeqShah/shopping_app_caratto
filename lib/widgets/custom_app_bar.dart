import 'package:flutter/material.dart';


customAppBar(
    BuildContext context, {
      required String text,
      required VoidCallback onPress,
    }) {
  return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        onPressed: () => onPress(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 23,
        ),
      )
  );
}