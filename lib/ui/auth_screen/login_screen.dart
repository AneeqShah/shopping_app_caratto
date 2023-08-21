import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/ui/auth_screen/signup_screen.dart';
import 'package:shopping_app/ui/bottombar/bottom_bar_screen.dart';
import 'package:shopping_app/utils/input_validators.dart';
import 'package:shopping_app/widgets/custom_loader.dart';

import '../../navigation/navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool isValid = false;
  final _textFieldColor = const Color.fromARGB(255, 222, 222, 222);
  final _errorTextFieldColor = const Color.fromARGB(255, 255, 117, 107);

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        body: _getUI(context),
      ),
    );
  }

  Widget _getUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _form,
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Colors.black,
              controller: _email,
              decoration: InputDecoration(
                hintText: 'your@email.com',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                filled: true,
                fillColor: _textFieldColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _textFieldColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _textFieldColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _errorTextFieldColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _errorTextFieldColor),
                ),
              ),
              textInputAction: TextInputAction.done,
              focusNode: _emailFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your email.';
                }
                if (!value.isValidEmail()) {
                  return 'Enter right email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Colors.black,
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                filled: true,
                fillColor: _textFieldColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _textFieldColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _textFieldColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _errorTextFieldColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: _errorTextFieldColor),
                ),
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password.';
                }
                if (value.length <= 5) {
                  return 'Password must be 6 digits .';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!_form.currentState!.validate()) {
                    return;
                  }
                  _loginUser();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(10, 8, 9, 0.8)),
                child: const Text('Login',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                InkWell(
                  onTap: () {
                    NavigationHelper.navPush(context, SignUpScreen());
                  },
                  child: Text(
                    " SignUp",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _loginUser() async {
    try {
      loadingTrue();
     await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text, password: password.text)
          .then((value) {
        NavigationHelper.navStart(context, BottomBarScreen());
      });
    } on FirebaseException catch (e) {
      loadingFalse();
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  bool isLoading = false;

  loadingTrue() {
    isLoading = true;
    setState(() {});
  }

  loadingFalse() {
    isLoading = false;
    setState(() {});
  }
}
