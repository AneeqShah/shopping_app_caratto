import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_image_container.dart';

import '../../../../widgets/custom_text.dart';

class OrderDetailScreen extends StatefulWidget {
  final String productID;

  const OrderDetailScreen({super.key, required this.productID});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const CustomText(
            text: "Order Detail",
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
            itemCount: allProducts.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: PhysicalModel(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  elevation: 8.0,
                  shadowColor: Colors.grey.shade50,
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImageContainer(
                              height: 130,
                              wight: 130,
                              radius: 8,
                              image: allProducts[i]["productImage"]),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: allProducts[i]["productName"],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.black),
                              CustomText(
                                  text: "Quantity: ${allProducts[i]["quantity"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  textColor: Colors.black),
                              CustomText(
                                  text: "Size: ${allProducts[i]["size"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  textColor: Colors.black),
                              CustomText(
                                  text: "\$${allProducts[i]["amount"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  textColor: Colors.black),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  List<DocumentSnapshot> allProducts = [];

  _getOrderDetails() {
    FirebaseFirestore.instance
        .collection("Orders")
        .doc(widget.productID)
        .collection("products")
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
