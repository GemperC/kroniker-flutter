import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kroniker_flutter/backend/records/game_record.dart';
import 'package:kroniker_flutter/config/theme.dart';
import 'package:kroniker_flutter/index.dart';
import 'package:kroniker_flutter/utils/page_model.dart';
import 'package:kroniker_flutter/utils/utils.dart';
import './new_game_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final gameRecordService = GameRecordService();
  final user = FirebaseAuth.instance.currentUser!;
  late NewGameModel _model;
  late FirebaseStorage storage;
  late Reference storageReference;
  File? image;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _model = createModel(context, () => NewGameModel());
    storage = FirebaseStorage.instance;
    storageReference = storage.ref().child('images');

    _model.titleController ??= TextEditingController();
    _model.descriptionController ??= TextEditingController();
    _model.systemController ??= TextEditingController();
    _model.sessionNumberController ??= TextEditingController();
    _model.imageUrlController ??= TextEditingController();
  }

  String generateGameKey() {
    const length = 10;
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    String chars = '';
    chars += '$letters$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gameRecord = GameRecord(
        title: _model.titleController!.text,
        description: _model.descriptionController!.text,
        system: _model.systemController!.text,
        id: "",
        key: generateGameKey(),
        players: [],
        dm: FirebaseFirestore.instance.collection("users").doc(user.uid),
        sessionNumber: _model.sessionNumberController!.text,
        imageUrl: _model.imageUrlController!.text,
      );

      try {
        final gameDoc = FirebaseFirestore.instance.collection('games').doc();
        gameRecordService.createGameRecord(gameDoc.id, gameRecord);

        if (image != null) {
          String imageUrl = await uploadFile(image!, gameDoc.id);
          gameDoc.update({'imageUrl': imageUrl});
        }
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        userDoc.update({
          'myGames': FieldValue.arrayUnion(
              [FirebaseFirestore.instance.collection('games').doc(gameDoc.id)])
        });
        Utils.showSnackBarWithColor("Game record created!", Colors.blue);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create game record')));
      }
    }
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageTemp = File(image!.path);
    setState(() {
      this.image = imageTemp;
    });
  }

  Future<String> uploadFile(File file, String gameId) async {
    String fileName = 'game_banners/$gameId.${file.path.split('.').last}';
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _model.titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
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
                    labelText: "Title",
                    labelStyle: GoogleFonts.poppins(
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
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                  controller: _model.descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 53, 53, 53),
                    filled: true,
                    labelText: "Description",
                    labelStyle: GoogleFonts.poppins(
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _model.systemController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a system';
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
                    labelText: "System",
                    labelStyle: GoogleFonts.poppins(
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Container(
                      height: 48,
                      width: 130,
                      child: Center(
                        child: Text(
                          "Upload a Banner",
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 16),
                image != null ? Image.file(image!) : Container(),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                _submitForm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
