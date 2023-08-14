import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_button.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';
import 'package:shopping_app/widgets/custom_text.dart';

class ProductDetailScreen extends StatefulWidget {
  var productModel;

  ProductDetailScreen({super.key, this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const CustomText(
            text: "Product Detail",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textColor: Colors.white),
        centerTitle: true,
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageContainer(
              height: 250,
              wight: double.infinity,
              radius: 0,
              image: widget.productModel["imageUrl"]),
          10.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: widget.productModel["productName"],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.productModel["sale"]
                        ? CustomText(
                            text: "${widget.productModel["salePrice"]}\$",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.black)
                        : SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('\$${widget.productModel["price"]}',
                        style: TextStyle(
                            decoration: widget.productModel["sale"]
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: 16,
                            fontWeight: widget.productModel["sale"]
                                ? FontWeight.normal
                                : FontWeight.bold)),
                  ],
                ),
                10.height,
                CustomButton(
                    hight: 50,
                    width: double.infinity,
                    radius: 6,
                    text: "Select Size",
                    size: 14,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    buttonColor: Colors.grey.shade700,
                    onTap: () {}),
                20.height,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: primaryColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.favorite_border),
                            CustomText(
                                text: "To Favourite",
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                textColor: Colors.black)
                          ],
                        ),
                      ),
                    ),
                    20.width,
                    Expanded(
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                            CustomText(
                                text: "add to Cart",
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                textColor: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                deliveryInfo("7 days"),
                Divider(),
                _row("Metal", widget.productModel["metal"]),
                10.height,
                _row("Style", widget.productModel["mainStone"]),
                10.height,
                _row("Brand", widget.productModel["brand"]),
                10.height,
                _row("Collection", widget.productModel["collection"]),
                10.height,
                _row("Metal Code", "999"),
                10.height,
                _row("Size", widget.productModel["size"].toString()),
                10.height,
                const CustomText(
                    text: "Description",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black),
                CustomText(
                    text: widget.productModel["description"],
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    textColor: Colors.black)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget deliveryInfo(String arrivalDate) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delivery_dining,
            size: 34,
          ),
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          'Delivery by courier (with fitting)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      subtitle: Text(
        'Delivery in $arrivalDate',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Free'),
        ],
      ),
    );
  }

  Widget _row(String title, String subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            textColor: Colors.grey.shade700),
        CustomText(
            text: subTitle,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textColor: Colors.black),
      ],
    );
  }
}
