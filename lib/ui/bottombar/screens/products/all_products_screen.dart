import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/products/product_detail_screen.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_product_card.dart';
import 'package:shopping_app/widgets/custom_text.dart';

class AllProductsScreen extends StatefulWidget {
  final String productID;

  const AllProductsScreen({super.key, required this.productID});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  List<DocumentSnapshot> allProducts = [];
  bool hightToLow = false;
  bool isFilter = false;
  bool male = false;
  bool female = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts(hightToLow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const CustomText(
            text: "Products",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textColor: Colors.black),
        bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          isFilter = !isFilter;
                          setState(() {});
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt),
                            Text('Filter by'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        hightToLow = !hightToLow;
                        setState(() {});
                        _getProducts(hightToLow);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.compare_arrows_sharp),
                          hightToLow
                              ? const Text('Sort by High to low')
                              : const Text('Sort by low to High'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: allProducts.isNotEmpty
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: CupertinoSearchTextField(
                          onChanged: (value) {
                            _filter(value);
                            setState(() {});
                          },
                        ),
                      ),
                      10.height,
                      Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: 25),
                            itemCount: filterList.isNotEmpty
                                ? filterList.length
                                : allProducts.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  NavigationHelper.navPush(
                                      context,
                                      ProductDetailScreen(
                                        productModel: filterList.isNotEmpty
                                            ? filterList[i]
                                            : allProducts[i],
                                      ));
                                },
                                child: CustomProductCard(
                                  image: filterList.isNotEmpty
                                      ? filterList[i]["imageUrl"]
                                      : allProducts[i]["imageUrl"],
                                  price: filterList.isNotEmpty
                                      ? filterList[i]["price"]
                                      : allProducts[i]["price"],
                                  salePrice: filterList.isNotEmpty
                                      ? filterList[i]["salePrice"]
                                      : allProducts[i]["salePrice"],
                                  sale: filterList.isNotEmpty
                                      ? filterList[i]["sale"]
                                      : allProducts[i]["sale"],
                                  title: filterList.isNotEmpty
                                      ? filterList[i]["productName"]
                                      : allProducts[i]["productName"],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                isFilter
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                  text: "Filter by Gender",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.black),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                      text: "Male",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.black),
                                  Checkbox(
                                    value: male,
                                    onChanged: (val) {
                                      male = val!;
                                      female = !val;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                      text: "Female",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.black),
                                  Checkbox(
                                    value: female,
                                    onChanged: (val) {
                                      male = !val!;
                                      female = val;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _getFilter();
                                        isFilter = false;
                                        setState(() {});
                                      },
                                      child: const CustomText(
                                          text: "Apply",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          textColor: Colors.white)),
                                  20.width,
                                  InkWell(
                                    onTap: () {
                                      _getProducts(false);
                                      isFilter = false;
                                      setState(() {});
                                    },
                                    child: CustomText(
                                        text: "Reset",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        textColor: primaryColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'No Product available 😞',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }

  _getProducts(bool high) {
    FirebaseFirestore.instance
        .collection("product")
        .where("categoryID", isEqualTo: widget.productID)
        .orderBy("price", descending: high)
        .orderBy("dateTime", descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      allProducts.clear();
      snapshot.docs.forEach((element) {
        allProducts.add(element);
        setState(() {});
      });
    });
  }

  List<DocumentSnapshot> filterList = [];

  _filter(String name) {
    filterList.clear();
    for (var item in allProducts) {
      var title = item['productName'].toString().toLowerCase();
      if (title.toLowerCase().toString().contains(name.toString())) {
        filterList.add(item);
        setState(() {});
      }
    }
  }

  _getFilter() {
    allProducts.clear();
    FirebaseFirestore.instance
        .collection("product")
        .where("categoryID", isEqualTo: widget.productID)
        .where("gender", isEqualTo: male ? "Male" : "Female")
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
