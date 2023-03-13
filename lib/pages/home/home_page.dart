import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kroniker_flutter/auth/google_auth.dart';
import 'package:kroniker_flutter/backend/backend.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'floatingMenuButton.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<DocumentSnapshot> gameDocs;

  GlobalKey containerKey = GlobalKey();
  FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final userRecordServices = UserRecordService();
  var _tabTextIconIndexSelected = 0;
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  late Map<String, dynamic> userDocData;
  late Map<String, dynamic> myGamesIdsImages;
  List<String> imageBannersUrls = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDocDataFromFirestore();
  }

  Future<void> _getUserDocDataFromFirestore() async {
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      userDocData = document.data() as Map<String, dynamic>;
    });
    List<String> imageUrls = [];

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('games')
        .where(FieldPath.documentId, whereIn: userDocData['myGames'])
        .get();
    for (var document in querySnapshot.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('imageUrl')) {
        String imageUrl = data['imageUrl'];
        imageUrls.add(imageUrl);
      }
    }

    setState(() {
      imageBannersUrls = imageUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Add your widgets here
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("Upcoming Sessions",
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      enlargeFactor: 0.4,
                    ),
                    items: imageBannersUrls
                        .map((item) => Container(
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: Stack(
                                      children: <Widget>[
                                        Image.network(item,
                                            fit: BoxFit.cover, width: 1000.0),
                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(200, 0, 0, 0),
                                                  Color.fromARGB(0, 0, 0, 0)
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Text(
                                              'No. ${imgList.indexOf(item)} image',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  FlutterToggleTab(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: 45,
                    borderRadius: 15,
                    selectedBackgroundColors: [Theme.of(context).primaryColor],
                    unSelectedBackgroundColors: [
                      Theme.of(context).disabledColor
                    ],
                    selectedTextStyle: GoogleFonts.poppins(
                        color: Theme.of(context).indicatorColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    unSelectedTextStyle: GoogleFonts.poppins(
                        color: Theme.of(context).indicatorColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    labels: ["Games", "Charecters"],
                    selectedIndex: _tabTextIconIndexSelected,
                    selectedLabelIndex: (index) {
                      setState(() {
                        _tabTextIconIndexSelected = index;
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Center(
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.blue),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration:
                                        const BoxDecoration(color: Colors.red),
                                  ),
                                  const Text("sadsad\nasdsad"),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: const FloatingMenuButton()),
    );
  }
}
