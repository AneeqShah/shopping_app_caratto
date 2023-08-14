import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Function onTap;
  const CategoryCard({super.key, required this.title, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomImageContainer(
                  height: 100, wight: 100, radius: 8, image: image),
            ),
          ],
        ),
      ),
    );
  }
}
