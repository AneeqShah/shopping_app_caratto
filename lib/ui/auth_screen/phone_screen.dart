import 'package:flutter/material.dart';
import 'package:shopping_app/navigation/navigation_helper.dart';
import 'package:shopping_app/ui/auth_screen/signup_screen.dart';

import 'login_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController(text: '+998');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Authorization',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter phone number',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _phoneController,
                  cursorColor: Colors.black,
                  style: Theme.of(context).textTheme.bodyMedium,
                  autocorrect: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: '+998 (xx) xxx-xx-xx',
                    filled: true,
                    fillColor: Color.fromARGB(255, 222, 222, 222),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 10) {
                    } else {}
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    NavigationHelper.navPush(
                        context, SignUpScreen(number: _phoneController.text));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(10, 8, 9, 0.8)),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  InkWell(
                    onTap: () {
                      NavigationHelper.navPush(context, LoginScreen());
                    },
                    child: Text(
                      " Login",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
