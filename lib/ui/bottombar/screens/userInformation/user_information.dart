import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/widgets/custom_button.dart';
import 'package:shopping_app/widgets/custom_text.dart';
import 'package:shopping_app/widgets/custom_textfield.dart';

class UserInformation extends StatefulWidget {
  final String name;
  final String phone;
  final String email;

  const UserInformation(
      {super.key,
      required this.name,
      required this.phone,
      required this.email});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email.text = widget.email;
    _name.text = widget.name;
    _phone.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const CustomText(
            text: "Profile",
            fontSize: 14,
            fontWeight: FontWeight.normal,
            textColor: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          children: [
            CustomTextField(
                title: "Email",
                isEnabled: false,
                controller: _email,
                validator: (val) => null,
                hint: "dummy@gmail.com"),
            10.height,
            CustomTextField(
                title: "FullName",
                controller: _name,
                validator: (val) => null,
                hint: "JohnSmith"),
            10.height,
            CustomTextField(
                title: "PhoneNumber",
                controller: _phone,
                validator: (val) => null,
                hint: ""),
            20.height,
            CustomButton(
                hight: 50,
                width: double.infinity,
                radius: 8,
                text: "Update",
                size: 14,
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
                buttonColor: primaryColor,
                onTap: () {})
          ],
        ),
      ),
    );
  }
}
