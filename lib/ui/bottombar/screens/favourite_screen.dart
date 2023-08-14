import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';

import '../../../utils/constants.dart';
import '../bottom_bar_screen.dart';
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
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
                        child:
                        Icon(Icons.favorite_border, color: Colors.black),
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
}
