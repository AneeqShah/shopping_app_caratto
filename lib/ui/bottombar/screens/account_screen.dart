import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/ui/auth_screen/login_screen.dart';
import 'package:shopping_app/ui/bottombar/bottom_bar_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/order/order_history_screen.dart';
import 'package:shopping_app/ui/bottombar/screens/userInformation/user_information.dart';
import 'package:shopping_app/widgets/custom_button.dart';

import '../../../navigation/navigation_helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _bgColor = const Color.fromARGB(255, 236, 236, 236);

  Widget _buildListTile(String title, IconData icon, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: Theme.of(ctx).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildContainerTitle(String title, BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: Theme.of(ctx).textTheme.headlineSmall,
      ),
    );
  }

  String name = "";
  String email = "";
  String phone = "";

  User? uid = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Image.asset(
                  'assets/wring2.jpg',
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover,
                ),
              ),
              uid != null
                  ? Positioned(
                      child: Column(
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            phone,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            uid != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            NavigationHelper.navStart(
                                context, BottomBarScreen());
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(10, 8, 9, 0.8)),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          NavigationHelper.navPush(context, LoginScreen());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(10, 8, 9, 0.8)),
                        child: const Text(
                          'Login / Register',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            _buildContainerTitle('Personal Area', context),
            _buildDivider(),
            InkWell(
              onTap: () {
                if (uid != null) {
                  NavigationHelper.navPush(
                      context,
                      UserInformation(
                        name: name,
                        phone: phone,
                        email: email,
                      ));
                } else {
                  Fluttertoast.showToast(msg: "Need to login");
                }
              },
              child: _buildListTile(
                'My information',
                Icons.contact_mail_sharp,
                context,
              ),
            ),
            _buildDivider(),
            InkWell(
              onTap: () {
                if (uid != null) {
                  NavigationHelper.navPush(context, OrderHistoryScreen());
                } else {
                  Fluttertoast.showToast(msg: "Need to login");
                }
              },
              child: _buildListTile(
                'History of orders',
                Icons.list_alt_sharp,
                context,
              ),
            ),
            _buildDivider(),
            _buildContainerTitle('Help', context),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  _getUserDetails() {
    if (uid != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid!.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        name = snapshot.get('name');
        email = snapshot.get('email');
        phone = snapshot.get('number');
        setState(() {});
      });
    }
  }
}
