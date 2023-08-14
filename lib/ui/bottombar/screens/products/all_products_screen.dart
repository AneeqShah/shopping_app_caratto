import 'package:flutter/material.dart';
class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
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
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt),
                            Text('Filters'),
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
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.compare_arrows_sharp),
                          Text('Sort by'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),

    );
  }
}
