import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_button.dart';
import 'package:shopping_app/widgets/custom_loader.dart';
import 'package:shopping_app/widgets/custom_textfield.dart';

import '../../../navigation/navigation_helper.dart';
import '../../../widgets/custom_text.dart';
import '../bottom_bar_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<DocumentSnapshot> cartItems;
  final List<DocumentSnapshot> allProducts;
  final List<int> sized;
  final String totalPrice;
  final List<int> price;

  const OrderConfirmationScreen(
      {super.key,
      required this.cartItems,
      required this.allProducts,
      required this.sized,
      required this.price,
      required this.totalPrice});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  TextEditingController _city = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _comment = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const CustomText(
              text: "Confirm Order",
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
        body: Form(
            key: _key, child: SingleChildScrollView(child: _getUI(context))),
      ),
    );
  }

  Widget _getUI(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 450,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                    text: "Delivery address",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black),
                10.height,
                CustomTextField(
                    title: "Address",
                    controller: _address,
                    validator: (val) => val.isEmpty ? "Required" : null,
                    hint: "Enter Address"),
                10.height,
                CustomTextField(
                    title: "City",
                    controller: _city,
                    validator: (val) => val.isEmpty ? "Required" : null,
                    hint: "kohat"),
                10.height,
                CustomTextField(
                    title: "Comment",
                    controller: _comment,
                    validator: (val) => val.isEmpty ? "Required" : null,
                    hint: "entrance, floor, intercom"),
              ],
            ),
          ),
        ),
        20.height,
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                    text: "Order recipient",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black),
                10.height,
                CustomTextField(
                    title: "Name",
                    controller: _name,
                    validator: (val) => val.isEmpty ? "Required" : null,
                    hint: "Enter name"),
                10.height,
                CustomTextField(
                    title: "Phone",
                    controller: _phone,
                    validator: (val) => val.isEmpty ? "Required" : null,
                    hint: "+998 (xx) xxx-xxxx"),
              ],
            ),
          ),
        ),
        20.height,
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                    text: "Your Order",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                        text: "Total",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: Colors.black),
                    CustomText(
                        text: "\$${widget.totalPrice}",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
        20.height,
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: "Total Payable \$${widget.totalPrice}",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black),
                10.height,
                CustomButton(
                    hight: 50,
                    width: double.infinity,
                    radius: 8,
                    text: "Checkout",
                    size: 14,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    buttonColor: Colors.blue,
                    onTap: () {
                      if (!_key.currentState!.validate()) {
                        return;
                      }
                      if (widget.totalPrice.isNotEmpty) {
                        _orderItems();
                      } else {
                        Fluttertoast.showToast(msg: "add product in cart");
                      }
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  User? user = FirebaseAuth.instance.currentUser;

  _orderItems() async {
    loadingTrue();
    try {
      String orderID = FirebaseFirestore.instance.collection("Orders").doc().id;
      await FirebaseFirestore.instance.collection("Orders").doc(orderID).set({
        'totalPrice': widget.totalPrice,
        'totalItems': widget.allProducts.length,
        "orderID": orderID,
        "orderBy": user!.uid,
        "address": _address.text,
        "city": _city.text,
        "comment": _comment.text,
        "name": _name.text,
        "phone": _phone.text,
        "orderDate": DateTime.now().millisecondsSinceEpoch,
        "status": "Pending"
      }).then((value) async {
        for (var i = 0; i <= widget.allProducts.length - 1; i++) {
          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderID)
              .collection("products")
              .doc(widget.allProducts[i]["productId"])
              .set({
            "productID": widget.allProducts[i]["productId"],
            "productImage": widget.allProducts[i]["imageUrl"],
            "productName": widget.allProducts[i]["productName"],
            "quantity": widget.sized[i],
            "amount": widget.price[i],
            "size": widget.cartItems[i]["size"]
          });
        }
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("cart")
            .doc(user!.uid)
            .collection('items')
            .snapshots()
            .listen((QuerySnapshot snapshot) async {
          snapshot.docs.forEach((element) async {
            await FirebaseFirestore.instance
                .collection("cart")
                .doc(user!.uid)
                .collection('items')
                .doc(element['productID'])
                .delete();
          });
        });
      }).then((value) {
        loadingFalse();
        Fluttertoast.showToast(msg: "Order Placed");
        NavigationHelper.navStart(context, BottomBarScreen());
      });
    } on FirebaseException catch (e) {
      loadingFalse();
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  bool isLoading = false;

  loadingTrue() async {
    isLoading = true;
    setState(() {});
  }

  loadingFalse() async {
    isLoading = false;
    setState(() {});
  }
}
