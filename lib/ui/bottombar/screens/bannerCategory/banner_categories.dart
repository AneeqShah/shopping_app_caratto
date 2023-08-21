import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';

import '../../../../navigation/navigation_helper.dart';
import '../../../../widgets/category_card.dart';
import '../products/all_products_screen.dart';

class BannerCategory extends StatefulWidget {
  final String categoryList;

  const BannerCategory({super.key, required this.categoryList});

  @override
  State<BannerCategory> createState() => _BannerCategoryState();
}

class _BannerCategoryState extends State<BannerCategory> {
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Category",
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
                            context,
                            AllProductsScreen(
                              productID: allCategory[i]['categoryId'],
                            ));
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

  _getCategories() async {

      var a = await FirebaseFirestore.instance
          .collection("category")
          .doc(widget.categoryList)
          .get();
      allCategory.add(a);
      setState(() {});

  }
}
