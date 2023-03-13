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
import 'package:kroniker_flutter/backend/records/character_record.dart';
import 'package:kroniker_flutter/backend/records/game_record.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'floatingMenuButton.dart';

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
  final gameRecordServices = GameRecordService();

  var _tabTextIconIndexSelected = 0;

  late Map<String, dynamic> userDocData;
  late Map<String, dynamic> myGamesIdsImages;

  List<String> gameIdList = [];

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
    List<String> _gameIdList = [];

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
      if (data != null && data.containsKey('id')) {
        String gameId = data['id'];
        gameIdList.add(gameId);
      }
    }

    setState(() {
      imageBannersUrls = imageUrls;
      gameIdList = _gameIdList;
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
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
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            'image',
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
                        print(_tabTextIconIndexSelected);
                      });
                    },
                  ),
                  _tabTextIconIndexSelected == 0
                      ? StreamBuilder<List<GameRecord>>(
                          stream: gameRecordServices
                              .streamGamesForUser(userDocData),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                final myGames = snapshot.data!;
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: myGames.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 30),
                                        child: Center(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  child: Image.network(
                                                    myGames[index].imageUrl!,
                                                    height: 50.0,
                                                    width: 50.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "${myGames[index].title}\nSession: 5"),
                                                Expanded(child: Container()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2.0),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 30,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      child: Center(
                                                          child: Text(
                                                        "Play",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      )),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("There is an Error!"),
                                );
                              } else {
                                return Center(
                                  child: Text("Nothing to show"),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                      : StreamBuilder<List<CharacterRecord>>(
                          stream: null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                final myGames = snapshot.data!;
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: myGames.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 30),
                                        child: Center(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  child: Image.network(
                                                    myGames[index].imageUrl!,
                                                    height: 50.0,
                                                    width: 50.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "${myGames[index].name}\Game: 5"),
                                                Expanded(child: Container()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2.0),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 30,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      child: Center(
                                                          child: Text(
                                                        "Play",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      )),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("There is an Error!"),
                                );
                              } else {
                                return Center(
                                  child: Text("Nothing to show"),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                ],
              ),
            ],
          ),
          floatingActionButton: const FloatingMenuButton()),
    );
  }
}
