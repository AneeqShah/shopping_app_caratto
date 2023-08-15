import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/bottombar/screens/products/product_detail_screen.dart';
import 'package:shopping_app/widgets/custom_text.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_product_card.dart';
import '../bottom_bar_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> allFav = [];
  List<DocumentSnapshot> myFav = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: CustomText(text: "Favourite", fontSize: 16, fontWeight: FontWeight.bold, textColor: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: myFav.isNotEmpty
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
                    itemCount: myFav.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          NavigationHelper.navPush(
                              context,
                              ProductDetailScreen(
                                productModel: myFav[i],
                              ));
                        },
                        child: CustomProductCard(
                          image: myFav[i]["imageUrl"],
                          price: myFav[i]["price"],
                          salePrice: myFav[i]["salePrice"],
                          sale: myFav[i]["sale"],
                          title: myFav[i]["productName"],
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
                    'You have no favorites 😞',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Press',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const WidgetSpan(
                              child: Icon(Icons.favorite_border,
                                  color: Colors.black),
                            ),
                            TextSpan(
                                text:
                                    'in front of any product to return to it later',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ]),
                        ),
                      ),
                    ],
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
                      NavigationHelper.navStart(context, BottomBarScreen());
                    },
                    child: const Text('Back to shopping'),
                  ),
                )
              ],
            ),
    );
  }

  _getFavourite() async {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('favourites')
          .doc(user!.uid)
          .collection('products')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        snapshot.docs.forEach((element) {
          myFav.clear();

          allFav.add(element);
          setState(() {});
        });
        for (var item in allFav) {
          print(allFav.length);
          FirebaseFirestore.instance
              .collection('product')
              .where('productId', isEqualTo: item['producdID'])
              .snapshots()
              .listen((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) {
              allFav.clear();
              myFav.add(element);
              setState(() {});
            });
          });
        }
      });
    }
  }
}
