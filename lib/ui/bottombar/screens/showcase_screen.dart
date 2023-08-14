import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/banner_card.dart';

import '../../../utils/constants.dart';
import '../../../widgets/link_button.dart';
import '../../../widgets/story_card.dart';

class ShowCaseScreen extends StatefulWidget {
  const ShowCaseScreen({super.key});

  @override
  State<ShowCaseScreen> createState() => _ShowCaseScreenState();
}

class _ShowCaseScreenState extends State<ShowCaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Showcase",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            10.height,
            const CupertinoSearchTextField(),
            10.height,
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: ((context, index) {
                  return StoryCircle(
                    function: () {},
                    imgUrl:
                        "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
                    title: "Test add",
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return BannerCard(
                    image: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
                    title: "Test",
                    description: "shdjk ahsdkj ashd jash ajs,hda ksjh askh");
              },
            ),
            const SizedBox(height: 10),
            LinkButton('About the sky in diamonds'),
            const SizedBox(height: 10),
            LinkButton('Contract offer'),
            const SizedBox(height: 10),
            LinkButton('Delivery terms'),
          ],
        ),
      ),
    );
  }
  

  
  
  
}
