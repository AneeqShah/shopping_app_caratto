import 'package:advstory/advstory.dart';
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
  static String collectionDbName = 'status';

//TODO: add possibility get data from any API
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);

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
            allStories.isNotEmpty
                ? SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: AdvStory(
                      storyCount: allStories.length - (allStories.length - 1),
                      storyBuilder: (storyIndex) => Story(
                        contentCount: allStories.length ,
                        contentBuilder: (contentIndex) => ImageContent(
                          url: allStories[contentIndex]["imageUrl"],
                          footer: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    text: allStories[contentIndex]["title"],
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    textColor: Colors.white),
                                CustomText(
                                    text: allStories[contentIndex]
                                        ["description"],
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    textColor: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      trayBuilder: (index) =>
                          AdvStoryTray(url: allStories[index]["imageUrl"]),
                    ),
                  )
                : Container(),

            5.height,
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
            const CustomText(
                text: "Popular Products",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.black),
            10.height,

            Container(
              height: 500,
              width: double.infinity,
              child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 25),
                  itemCount: allProducts.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        NavigationHelper.navPush(
                            context,
                            ProductDetailScreen(
                              productModel: allProducts[i],
                            ));
                      },
                      child: CustomProductCard(
                        image: allProducts[i]["imageUrl"],
                        price: allProducts[i]["price"],
                        salePrice: allProducts[i]["salePrice"],
                        sale: allProducts[i]["sale"],
                        title: allProducts[i]["productName"],
                      ),
                    );
                  }),
            ),
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
        print(element.data());
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
