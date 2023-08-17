import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isFav = false;
  String selectedSize = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkFav();
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
                        : "Size Selected",
                    size: 14,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    buttonColor: Colors.grey.shade700,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            List availableSize =
                                widget.productModel["availability"];
                            return ListView.builder(
                                itemCount: availableSize.length,
                                itemBuilder: (context, i) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return InkWell(
                                      onTap: () {
                                        selectedSize = availableSize[i];
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(availableSize[i]),
                                            trailing:
                                                selectedSize == availableSize[i]
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.blue,
                                                      )
                                                    : const SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  });
                                });
                          });
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
                          _addToCart();
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
                _row("Size", widget.productModel["size"].toString()),
                10.height,
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

  _addToCart() {
    print(selectedSize);
  }
}
