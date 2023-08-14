import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';
import 'package:shopping_app/widgets/custom_text.dart';

class CustomProductCard extends StatelessWidget {
  final String image;
  final String price;
  final String salePrice;
  final bool sale;
  final String title;

  const CustomProductCard(
      {super.key,
      required this.image,
      required this.price,
      required this.salePrice,
      required this.sale,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.grey,
      elevation: 6,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        // height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageContainer(
                height: 180, wight: double.infinity, radius: 8, image: image),
            10.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text('\$$price',
                      style: TextStyle(
                          decoration: sale ? TextDecoration.lineThrough : null,
                          fontSize: 16,
                          fontWeight:
                              sale ? FontWeight.normal : FontWeight.bold)),
                  const SizedBox(
                    width: 10,
                  ),
                  sale
                      ? CustomText(
                          text: "$salePrice\$",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.black)
                      : Container()
                ],
              ),
            ),
            5.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  textColor: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
