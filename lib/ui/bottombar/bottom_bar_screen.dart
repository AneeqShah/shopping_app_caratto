import 'package:flutter/material.dart';
import 'package:shopping_app/ui/bottombar/screens/account_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/cart_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/category_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/favourite_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/showcase_screen.dart';
import '../../utils/constants.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  List<Widget> _tabs = [];

  void _onItemTapped(int index) {
    _selectedIndex = index;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabs = [
      const ShowCaseScreen(),
      const CategoryScreen(),
      const CartScreen(),
      const FavouriteScreen(),
      const AccountScreen(),
    ];
    // EasyLocalization.of(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Showcase',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_search),
              label: 'Catalogue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          onTap: (index) => _onItemTapped(index),
          unselectedFontSize: 10,
          unselectedIconTheme: const IconThemeData(size: 14),
          type: BottomNavigationBarType.fixed, // Fixed
        ),
        body: _tabs[_selectedIndex],
      ),
    );
  }
}
