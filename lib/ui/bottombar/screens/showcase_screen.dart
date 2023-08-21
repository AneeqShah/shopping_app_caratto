import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/bannerCategory/banner_categories.dart';
import 'package:shopping_app/ui/bottombar/screens/products/product_detail_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/story/story_screen.dart';
import 'package:shopping_app/widgets/banner_card.dart';
import 'package:shopping_app/widgets/custom_text.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_product_card.dart';
import '../../../widgets/link_button.dart';
import '../../../widgets/story_card.dart';

class ShowCaseScreen extends StatefulWidget {
  const ShowCaseScreen({super.key});

  @override
  State<ShowCaseScreen> createState() => _ShowCaseScreenState();
}

class _ShowCaseScreenState extends State<ShowCaseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBanners();
    _getStories();
    _getProducts();
  }

  List<DocumentSnapshot> filterList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Showcase",
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            CupertinoSearchTextField(
              onChanged: (value) {
                _filter(value);
                setState(() {});
              },
            ),
            10.height,
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allStories.length,
                itemBuilder: ((context, index) {
                  return StoryCircle(
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryScreen(
                            stories: allStories[index],
                          ),
                        ),
                      );
                    },
                    imgUrl: allStories[index]["imageUrl"],
                    title: allStories[index]["title"],
                  );
                }),
              ),
            ),
            10.height,
            const CustomText(
                text: "Popular Products",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.black),
            5.height,
            SizedBox(
              height: MediaQuery.of(context).size.height*0.35,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allProducts.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child:  InkWell(
                      onTap: (){
                        NavigationHelper.navPush(
                            context, ProductDetailScreen(productModel: allProducts[index],));
                      },
                      child: CustomProductCard(
                        image: allProducts[index]["imageUrl"],
                        price: allProducts[index]["price"],
                        salePrice: allProducts[index]["salePrice"],
                        sale: allProducts[index]["sale"],
                        title: allProducts[index]["productName"],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  filterList.isEmpty ? allBanners.length : filterList.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: InkWell(
                    onTap: () {
                      NavigationHelper.navPush(
                          context,
                          BannerCategory(
                              categoryList: filterList.isEmpty
                                  ? allBanners[i]["categories"]
                                  : filterList[i]["categories"]));
                    },
                    child: BannerCard(
                        image: filterList.isEmpty
                            ? allBanners[i]["imageUrl"]
                            : filterList[i]["imageUrl"],
                        title: filterList.isEmpty
                            ? allBanners[i]["bannerName"]
                            : filterList[i]["bannerName"],
                        description: filterList.isEmpty
                            ? allBanners[i]["description"]
                            : filterList[i]["description"]),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            LinkButton('About the sky in diamonds'),
            const SizedBox(height: 10),
            LinkButton('Contract offer'),
            const SizedBox(height: 10),
            LinkButton('Delivery terms'),
          ],
        ),
      ),
    );
  }

  List<DocumentSnapshot> allBanners = [];
  List<DocumentSnapshot> allStories = [];

  _getBanners() {
    FirebaseFirestore.instance
        .collection("banners")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      allBanners.clear();
      snapshot.docs.forEach((element) {
        allBanners.add(element);
        setState(() {});
      });
    });
  }

  _filter(String name) {
    filterList.clear();
    for (var item in allBanners) {
      var title = item['bannerName'].toString().toLowerCase();
      if (title.toLowerCase().toString().contains(name.toString())) {
        filterList.add(item);
        setState(() {});
      }
    }
  }

  _getStories() {
    FirebaseFirestore.instance
        .collection("status")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      allStories.clear();
      for (var element in snapshot.docs) {
        allStories.add(element);
        setState(() {});
      }
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
