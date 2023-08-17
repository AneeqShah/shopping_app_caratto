import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCartItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        text: "\$${allProducts[i]["price"]}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        textColor: Colors.black),
                                    10.height,
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (sized[i] -1 >= 1) {
                                              sized[i]--;
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
    );
  }

  User? user = FirebaseAuth.instance.currentUser;

  _getCartItem() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('items')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        cartItems.clear();
        snapshot.docs.forEach((element) {
          allProducts.clear();
          cartItems.add(element);
          sized.add(1);
          setState(() {});
        });
        for (var item in cartItems) {
          FirebaseFirestore.instance
              .collection('product')
              .where('productId', isEqualTo: item['productID'])
              .snapshots()
              .listen((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) {
              allProducts.add(element);
              setState(() {});
            });
          });
        }
      });
    }
  }
}
