import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.bottomCenter,
            child: Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 30,
            ),
            child: Text(
              'Start by browsing the product catalog and you will definitely find what you need',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
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
                Navigator.of(context).pushNamed('/');
              },
              child: const Text('Back to shopping'),
            ),
          )
        ],
      ),
    );  }
}
