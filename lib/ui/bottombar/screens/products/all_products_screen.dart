import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/products/product_detail_screen.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: CustomText(text: "Products", fontSize: 16, fontWeight: FontWeight.bold, textColor: Colors.black),
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
                          // Navigator.of(context)
                          //     .pushNamed(FiltersScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.filter_alt),
                            const Text('Filters'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed(SortScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.compare_arrows_sharp),
                          const Text('Sort by'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: allProducts.isNotEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 25),
                    itemCount: allProducts.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          NavigationHelper.navPush(
                              context, ProductDetailScreen(productModel: allProducts[i],));
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

  _getProducts() {
    FirebaseFirestore.instance
        .collection("product")
        .where("categoryID", isEqualTo: widget.productID)
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
