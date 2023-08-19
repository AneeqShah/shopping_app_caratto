import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/order/order_detail_screen.dart';

import '../../../../widgets/custom_order_card.dart';
import '../../../../widgets/custom_text.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const CustomText(
            text: "Order History",
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: allOrder.length,
            itemBuilder: (context, i) {
              String order = "${allOrder[i]["orderDate"]}";
              DateTime time =
                  DateTime.fromMillisecondsSinceEpoch(allOrder[i]["orderDate"]);
              return CustomOrderCard(
                status: allOrder[i]["status"],
                orderID: "${order.substring(6)}",
                orderDate: '${time.day}/${time.month}/${time.year}',
                quantity: "${allOrder[i]["totalItems"]}",
                totalPrice: "${allOrder[i]["totalPrice"]}",
                onTap: () {
                  NavigationHelper.navPush(
                      context,
                      OrderDetailScreen(
                        productID: allOrder[i]["orderID"],
                      ));
                },
              );
            }),
      ),
    );
  }

  List<DocumentSnapshot> allOrder = [];

  _getOrder() {
    FirebaseFirestore.instance
        .collection("Orders")
        .where("orderBy", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        allOrder.add(element);
        setState(() {});
      });
    });
  }
}
