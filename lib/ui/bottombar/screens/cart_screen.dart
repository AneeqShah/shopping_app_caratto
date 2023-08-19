import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/bottom_bar_screen.dart';
import 'package:shopping_app/widgets/custom_button.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';
import 'package:shopping_app/widgets/custom_loader.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_text.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<DocumentSnapshot> cartItems = [];
  List<DocumentSnapshot> allProducts = [];
  List<int> sized = [];
  List<int> price = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCartItem();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const CustomText(
              text: "Cart",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textColor: Colors.black),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        bottomNavigationBar: user != null
            ? Container(
                height: 120,
                /**/
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                              text: "Total: ",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white),
                          CustomText(
                              text: "\$${grandTotal}",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white),
                        ],
                      ),
                      10.height,
                      CustomButton(
                          hight: 45,
                          width: double.infinity,
                          radius: 8,
                          text: "Go to Checkout",
                          size: 14,
                          textColor: Colors.white,
                          fontWeight: FontWeight.normal,
                          buttonColor: Colors.grey.shade800,
                          onTap: () {
                            _orderItems();
                          })
                    ],
                  ),
                ),
              )
            : null,
        backgroundColor: Colors.white,
        body: cartItems.isNotEmpty
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PhysicalModel(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 1,
                          color: Colors.grey,
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomImageContainer(
                                      height: 130,
                                      wight: 130,
                                      radius: 8,
                                      image: allProducts[i]["imageUrl"]),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomText(
                                          text: allProducts[i]["productName"],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          textColor: Colors.black),
                                      5.height,
                                      CustomText(
                                          text: "Size ${cartItems[i]["size"]}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          textColor: Colors.black),
                                      5.height,
                                      CustomText(
                                          text: "\$${price[i]}",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          textColor: Colors.black),
                                      10.height,
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (sized[i] - 1 >= 1) {
                                                sized[i]--;
                                                price[i] = int.parse(
                                                        allProducts[i]
                                                            ["price"]) *
                                                    sized[i];
                                                _calculatePrice();

                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              color: Colors.black,
                                              child: const Center(
                                                  child: Icon(
                                                CupertinoIcons.minus,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ),
                                          5.width,
                                          CustomText(
                                              text: "${sized[i]}",
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              textColor: Colors.black),
                                          5.width,
                                          InkWell(
                                            onTap: () {
                                              sized[i]++;
                                              price[i] = int.parse(
                                                      allProducts[i]["price"]) *
                                                  sized[i];
                                              _calculatePrice();
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              color: Colors.black,
                                              child: const Center(
                                                  child: Icon(
                                                CupertinoIcons.add,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Your cart is empty',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      'Start by browsing the product catalog and you will definitely find what you need',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SizedBox(
                    height: 50,
                    width: 210,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/');
                      },
                      child: const Text('Back to shopping'),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  User? user = FirebaseAuth.instance.currentUser;

  _getCartItem() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('items')
          .snapshots()
          .listen((QuerySnapshot snapshot) async {
        cartItems.clear();
        snapshot.docs.forEach((element) {
          allProducts.clear();
          cartItems.add(element);
          sized.add(1);
          setState(() {});
        });
        for (var item in cartItems) {
          await FirebaseFirestore.instance
              .collection('product')
              .where('productId', isEqualTo: item['productID'])
              .snapshots()
              .listen((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) {
              allProducts.add(element);
              price.add(int.parse(element["price"]));
              _calculatePrice();
              setState(() {});
            });
          });
        }
      });
    }
  }

  double totalPrice = 0;
  double grandTotal = 0;

  _calculatePrice() {
    totalPrice = 0;
    grandTotal = 0;
    double mtotal = 0;
    setState(() {});
    for (var i = 0; i <= cartItems.length - 1; i++) {
      mtotal = double.parse(allProducts[i]["price"].toString());
      totalPrice = mtotal * double.parse(sized[i].toString());
      setState(() {
        grandTotal = grandTotal + totalPrice;
      });
    }
  }

  _orderItems() async{
    // loadingTrue();
    try {
      String orderID = FirebaseFirestore.instance.collection("Orders").doc().id;
     await FirebaseFirestore.instance.collection("Orders").doc(orderID).set({
        'totalPrice': grandTotal,
        'totalItems': allProducts.length,
        "orderID": orderID,
        "orderBy": user!.uid,
        "orderDate": DateTime.now().millisecondsSinceEpoch,
        "status": "Pending"
      }).then((value)async {
        for (var i = 0; i <= allProducts.length - 1; i++) {
         await FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderID)
              .collection("products")
              .doc(allProducts[i]["productId"])
              .set({
            "productID": allProducts[i]["productId"],
            "productImage": allProducts[i]["imageUrl"],
            "productName": allProducts[i]["productName"],
            "quantity": sized[i],
            "amount": price[i],
            "size": cartItems[i]["size"]
          });
        }
      }).then((value) async{
       await FirebaseFirestore.instance
            .collection("cart")
            .doc(user!.uid)
            .collection('items')
            .snapshots()
            .listen((QuerySnapshot snapshot)async {
          snapshot.docs.forEach((element)async {
           await FirebaseFirestore.instance
                .collection("cart")
                .doc(user!.uid)
                .collection('items')
                .doc(element['productID'])
                .delete();
          });
        });
      }).then((value) {
        // loadingFalse();
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
