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
import 'package:kroniker_flutter/pages/game_menu/game_menu_page.dart';
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
  GlobalKey containerKey = GlobalKey();
  FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final userRecordServices = UserRecordService();
  final gameRecordServices = GameRecordService();
  final characterRecordServices = CharacterRecordService();

  var _tabTextIconIndexSelected = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: userStream(), floatingActionButton: const FloatingMenuButton()),
    );
  }

  Widget pageUI(UserRecord userDoc, List<GameRecord> gamesDocs,
      List<CharacterRecord> charactersDocs) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("Upcoming Sessions",
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            const SizedBox(
              height: 20,
            ),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     aspectRatio: 2.0,
            //     enlargeCenterPage: true,
            //     enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            //     enlargeFactor: 0.4,
            //   ),
            //   items: imageBannersUrls
            //       .map((item) => Container(
            //             margin: const EdgeInsets.symmetric(
            //                 horizontal: 8.0, vertical: 8.0),
            //             child: ClipRRect(
            //                 borderRadius:
            //                     const BorderRadius.all(Radius.circular(8.0)),
            //                 child: Stack(
            //                   children: <Widget>[
            //                     Image.network(item,
            //                         fit: BoxFit.cover, width: 1000.0),
            //                     Positioned(
            //                       bottom: 0.0,
            //                       left: 0.0,
            //                       right: 0.0,
            //                       child: Container(
            //                         decoration: const BoxDecoration(
            //                           gradient: LinearGradient(
            //                             colors: [
            //                               Color.fromARGB(200, 0, 0, 0),
            //                               Color.fromARGB(0, 0, 0, 0)
            //                             ],
            //                             begin: Alignment.bottomCenter,
            //                             end: Alignment.topCenter,
            //                           ),
            //                         ),
            //                         padding: const EdgeInsets.symmetric(
            //                             vertical: 10.0, horizontal: 20.0),
            //                         child: const Text(
            //                           'image',
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 20.0,
            //                             fontWeight: FontWeight.bold,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 )),
            //           ))
            //       .toList(),
            // ),

            const SizedBox(
              height: 20,
            ),
            FlutterToggleTab(
              width: MediaQuery.of(context).size.width * 0.22,
              height: 45,
              borderRadius: 15,
              selectedBackgroundColors: [Theme.of(context).primaryColor],
              unSelectedBackgroundColors: [Theme.of(context).disabledColor],
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
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: gamesDocs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GameMenuPage(
                                        gameData: gamesDocs[index])));
                          },
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    gamesDocs[index].imageUrl!,
                                    height: 50.0,
                                    width: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("${gamesDocs[index].title}\nSession: 5"),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: charactersDocs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => GameMenuPage(
                            //             gameData: gamesDocs[index])));
                          },
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    gamesDocs[index].imageUrl!,
                                    height: 50.0,
                                    width: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("${charactersDocs[index].id}\nSession: 5"),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ],
    );
  }

  Widget userStream() {
    return StreamBuilder<UserRecord>(
      stream: userRecordServices.streamUserData(user.uid),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (userSnapshot.hasError) {
          return Center(child: Text("${userSnapshot.error}"));
        } else {
          final UserRecord userDoc = userSnapshot.data!;

          return gamesStream(userDoc);
        }
      },
    );
  }

  Widget gamesStream(UserRecord userDoc) {
    return StreamBuilder<List<GameRecord>>(
      stream: gameRecordServices.streamGamesForUser(userDoc),
      builder: (context, gamesSnapshot) {
        if (gamesSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (gamesSnapshot.hasError) {
          return Center(child: Text("${gamesSnapshot.error}"));
        } else {
          final List<GameRecord> gamesDocs;
          if (gamesSnapshot.hasData) {
            gamesDocs = gamesSnapshot.data!;
          } else {
            gamesDocs = [];
          }

          return charactersStream(userDoc, gamesDocs);
        }
      },
    );
  }

  Widget charactersStream(UserRecord userDoc, List<GameRecord> gamesDocs) {
    return StreamBuilder<List<CharacterRecord>>(
      stream: characterRecordServices.streamCharactersForUser(userDoc),
      builder: (context, charactersSnapshot) {
        if (charactersSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (charactersSnapshot.hasError) {
            return Center(child: Text("${charactersSnapshot.error}"));
          } else {
            final List<CharacterRecord> charactersDocs;
            if (charactersSnapshot.hasData) {
              charactersDocs = charactersSnapshot.data!;
            } else {
              charactersDocs = [];
            }

            return pageUI(userDoc, gamesDocs, charactersDocs);
          }
        }
      },
    );
  }
}
