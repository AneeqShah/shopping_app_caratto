import 'package:flutter/material.dart';
import 'package:shopping_app/utils/constants.dart';

import 'custom_button.dart';
import 'custom_text.dart';

class CustomOrderCard extends StatelessWidget {
  final String status;
  final String orderID;
  final String orderDate;
  final String quantity;
  final String totalPrice;
  final Function onTap;
  const CustomOrderCard(
      {super.key,
      required this.status,
      required this.orderID,
      required this.orderDate,
      required this.quantity,
      required this.totalPrice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 8.0,
        shadowColor: Colors.grey.shade50,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       CustomText(
                          text: "Order no: ${orderID}",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.black),
                       CustomText(
                          text: orderDate,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          textColor: Color(0xff808080))
                    ],
                  ),
                ),
                10.height,
                const Divider(
                  thickness: 1,
                ),
                10.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _text("Quantity:", quantity),
                      _text("Total Amount:", " \$${totalPrice}"),
                    ],
                  ),
                ),
                20.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                          hight: 35,
                          width: 100,
                          radius: 5,
                          text: "Details",
                          size: 14,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          buttonColor: primaryColor,
                          onTap: () =>onTap()),
                      CustomText(
                          text: status,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.green)
                    ],
                  ),
                ),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(String question, String answer) {
    return Row(
      children: [
        CustomText(
            text: question,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            textColor: const Color(0xff808080)),
        CustomText(
            text: answer,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textColor: Colors.black),
      ],
    );
  }
}
