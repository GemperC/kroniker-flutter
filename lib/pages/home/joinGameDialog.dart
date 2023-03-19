import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kroniker_flutter/backend/records/game_record.dart';
import 'package:kroniker_flutter/utils/utils.dart';

class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({super.key});

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final TextEditingController gameKeyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final gameRecordServices = GameRecordService();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      title: Center(
        child: Text(
          "Join Game",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Game Key",
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 10),
          StreamBuilder<List<GameRecord>>(
              stream: gameRecordServices.streamGameCollection(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final games = snapshot.data!;
                  List<String> gameKeysList = [];
                  for (var game in games) {
                    gameKeysList.add(game.key);
                  }
                  return Form(
                    key: formKey,
                    child: TextFormField(
                      controller: gameKeyController,
                      validator: (value) {
                        if (gameKeyController.text.isEmpty) {
                          return "Invalid key";
                        } else if (!gameKeysList
                            .contains(gameKeyController.text)) {
                          return "Invalid key";
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 53, 53, 53),
                        filled: true,
                        hintText: "key",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // print(snapshot.error);
                  return Text(
                    "${snapshot.error}",
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return const Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.white),
                  );
                }
              }),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Join",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            final isValid = formKey.currentState!.validate();

            if (!isValid) {
              return;
            } else {
              addUserToGame();

              Utils.showSnackBarWithColor(
                  'You have joined the Game!', Colors.blue);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  void addUserToGame() async {
    final gameQuerySnapshot = await FirebaseFirestore.instance
        .collection('games')
        .where('key', isEqualTo: gameKeyController.text)
        .get();
    if (gameQuerySnapshot.docs.isNotEmpty) {
      final gameDocumentReference = gameQuerySnapshot.docs.first.reference;

      // Add the user document reference to the players field array
      final userDocumentReference =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await gameDocumentReference.update({
        'players': FieldValue.arrayUnion([userDocumentReference])
      });
    }
  }
}
