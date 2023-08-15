import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';

class StoryCircle extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final function;
  final String? imgUrl;
  final String? title;

  const StoryCircle({
    super.key,
    @required this.function,
    @required this.imgUrl,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Stack(
          children: [
            CustomImageContainer(height: screenHeight / 6,
                wight: screenWidth / 5,
                radius: 5,
                image: imgUrl!),
            Positioned(
              left: 5,
              right: 5,
              bottom: 10,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 90),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}