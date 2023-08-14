import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/products/all_products_screen.dart';
import 'package:shopping_app/widgets/category_card.dart';

import '../../../utils/constants.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            20.height,
            const CupertinoSearchTextField(),
            10.height,
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: allCategory.length,
                  itemBuilder: (context, i) {
                    return CategoryCard(
                      title: allCategory[i]["categoryName"],
                      image: allCategory[i]["imageUrl"],
                      onTap: () {
                        NavigationHelper.navPush(
                            context, const AllProductsScreen());
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  List<DocumentSnapshot> allCategory = [];

  _getCategories() {
    FirebaseFirestore.instance
        .collection("category")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        allCategory.add(element);
        setState(() {});
      });
    });
  }
}
