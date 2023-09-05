import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_button.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';
import 'package:shopping_app/widgets/custom_text.dart';

import '../../../../navigation/navigation_helper.dart';
import '../../../../widgets/custom_product_card.dart';
import '../../../../widgets/scroll_wheel_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  var productModel;

  ProductDetailScreen({super.key, this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFav = false;
  String selectedSize = "";
  List allSizes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkFav();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const CustomText(
            text: "Product Detail",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textColor: Colors.black),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
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
                        : const SizedBox(),
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
                    text: selectedSize == ""
                        ? "Select Available Size"
                        : "Size Selected ${selectedSize}",
                    size: 14,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    buttonColor: Colors.grey.shade700,
                    onTap: () {
                      allSizes = widget.productModel["size"];
                      setState(() {});
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor:
                            const Color.fromARGB(255, 225, 225, 225),
                        context: context,
                        builder: (ctx) => Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45,
                                  color:
                                      const Color.fromARGB(255, 211, 211, 211),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                          child: Text(
                                        'Size / Availability',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text(
                                          'Choose',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: ListView.builder(
                                      itemCount: allSizes.length,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () {
                                            selectedSize = allSizes[i]["size"];
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      text: allSizes[i]["size"],
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      textColor: Colors.black),
                                                  CustomText(
                                                      text:
                                                          "In Stock: ${allSizes[i]["inStock"]}",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      textColor: Colors.black)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                20.height,
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (user != null) {
                            if (isFav) {
                              _deleteFav();
                            } else {
                              _addToFav();
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Need to login");
                          }
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: primaryColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.grey),
                              10.width,
                              CustomText(
                                  text: isFav ? "Remove" : "To Favourite",
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  textColor: Colors.black)
                            ],
                          ),
                        ),
                      ),
                    ),
                    20.width,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (user != null) {
                            _addToCart();
                          } else {
                            Fluttertoast.showToast(msg: "Need to login");
                          }
                        },
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
                    ),
                  ],
                ),
                const Divider(),
                deliveryInfo("7 days"),
                const Divider(),
                _row("Metal", widget.productModel["metal"]),
                10.height,
                _row("Style", widget.productModel["style"]),
                10.height,
                _row("Brand", widget.productModel["brand"]),
                10.height,
                _row("Collection", widget.productModel["collection"]),
                10.height,
                _row("Metal Code", widget.productModel["metalCode"].toString()),
                10.height,
                // _row("Size", widget.productModel["size"][0]["size"].toString()),
                // 10.height,
                _row("Gender", widget.productModel["gender"].toString()),
                10.height,
                _row("MainStone", widget.productModel["mainStone"].toString()),
                10.height,
                _row("Metal Color",
                    widget.productModel["metalColor"].toString()),
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
                    textColor: Colors.black),
                10.height,
                const CustomText(
                    text: "Related Products",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black),
                10.height,
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: allProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            NavigationHelper.navPush(
                                context,
                                ProductDetailScreen(
                                  productModel: allProducts[i],
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: CustomProductCard(
                              image: allProducts[i]["imageUrl"],
                              price: allProducts[i]["price"],
                              salePrice: allProducts[i]["salePrice"],
                              sale: allProducts[i]["sale"],
                              title: allProducts[i]["productName"],
                            ),
                          ),
                        );
                      }),
                ),
                20.height,


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
        children: const [
          Icon(
            Icons.delivery_dining,
            size: 34,
          ),
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          'Delivery by courier',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      subtitle: Text(
        'Delivery in ${widget.productModel['deliveryDate']}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("\$${widget.productModel['deliveryCharges']}"),
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

  User? user = FirebaseAuth.instance.currentUser;

  _addToFav() {
    FirebaseFirestore.instance
        .collection("favourites")
        .doc(user!.uid)
        .collection("products")
        .doc(widget.productModel["productId"])
        .set({
      'producdID': widget.productModel["productId"],
      'uid': user!.uid,
    }).then((value) {
      isFav = true;
      setState(() {});
    });
  }

  _checkFav() async {
    if (user != null) {
      var a = await FirebaseFirestore.instance
          .collection("favourites")
          .doc(user!.uid)
          .collection("products")
          .doc(widget.productModel["productId"])
          .get();
      if (a.exists) {
        isFav = true;
        setState(() {});
      }
    }
  }

  _deleteFav() async {
    await FirebaseFirestore.instance
        .collection("favourites")
        .doc(user!.uid)
        .collection("products")
        .doc(widget.productModel["productId"])
        .delete()
        .then((value) {
      isFav = false;
      setState(() {});
    });
  }

  _addToCart() async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(user!.uid)
        .collection("items")
        .doc(widget.productModel["productId"])
        .set({
      "productID": widget.productModel["productId"],
      "size": selectedSize,
    }).then((value) {
      Fluttertoast.showToast(msg: "Added to Cart");
    });
  }

  List<DocumentSnapshot> allProducts = [];

  _getProducts() {
    FirebaseFirestore.instance
        .collection("product")
        .limit(3)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      allProducts.clear();
      snapshot.docs.forEach((element) {
        allProducts.add(element);
        setState(() {});
      });
    });
  }
}
