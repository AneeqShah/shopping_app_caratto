import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/ui/bottombar/bottom_bar_screen.dart';
import 'package:shopping_app/utils/input_validators.dart';
import 'package:shopping_app/widgets/custom_loader.dart';

import '../../navigation/navigation_helper.dart';

class SignUpScreen extends StatefulWidget {

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

List<String> genderOptions = ['Male', 'Female'];

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool isValid = false;
  final _textFieldColor = const Color.fromARGB(255, 222, 222, 222);
  final _errorTextFieldColor = const Color.fromARGB(255, 255, 117, 107);
  final TextEditingController _date = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController password = TextEditingController();
  String _currentOption = genderOptions[0];

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Enter Profile Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: Colors.black,
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter name.';
                      }
                      if (!value.isAlpha() || value.isNum()) {
                        return 'Name must be alphabetic.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: Colors.black,
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'your@email.com',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _date,
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.none,
                    showCursor: false,
                    decoration: InputDecoration(
                      hintText: 'Select date of birth',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
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
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _date.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select date of birth.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: Colors.black,
                    controller: _phone,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone number',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
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
                        return 'Enter phone number.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: Colors.black,
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10.0),
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
                  const SizedBox(height: 20),
                  Text('Select gender',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  RadioListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Text(genderOptions[0],
                        style: Theme.of(context).textTheme.bodyLarge),
                    value: genderOptions[0],
                    groupValue: _currentOption,
                    onChanged: (value) {
                      setState(() {
                        _currentOption = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Text(genderOptions[1],
                        style: Theme.of(context).textTheme.bodyLarge),
                    value: genderOptions[1],
                    groupValue: _currentOption,
                    onChanged: (value) {
                      setState(() {
                        _currentOption = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        if (!_form.currentState!.validate()) {
                          return;
                        }
                       await _registerUser();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(10, 8, 9, 0.8)),
                      child: const Text('Register',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() async {
    print("called");
    try {
      loadingTrue();
     await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: password.text)
          .then((value) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection("users").doc(uid).set({
          'number': _phone.text,
          'email': _email.text,
          'name': _name.text,
          'dateOfJoining': _date.text,
          'uid': uid,
          'gender':_currentOption,
          'isBlocked':false,
        }).then((value) {
          loadingFalse();
          Fluttertoast.showToast(msg: "Registered");
          NavigationHelper.navStart(context, const BottomBarScreen());
        });
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
