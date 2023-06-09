import 'dart:math';
import 'dart:ui';

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
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  bool uploadingGame = false;
  String _selectedSystem = "";
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
      setState(() {
        uploadingGame = true;
      });
      showDialog(
        barrierColor: null,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return waitDialog();
        },
      );
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

    // Compress the image
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageTemp.path, // input file path
      "${imageTemp.path}\compressed\banner.jpeg", // output file path
      quality: 25, // compression quality (0-100)
    );

    setState(() {
      this.image = compressedImage;
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
      child: Container(
        child: Stack(
          children: [
            Scaffold(
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
                          labelText: "Title",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blue), //<-- SEE HERE
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
                          labelText: "Description",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blue), //<-- SEE HERE
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
                          labelText: "System",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blue), //<-- SEE HERE
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
                      image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(image!))
                          : Container(),
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
            uploadingGame
                ? Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(124, 0, 0, 0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: SizedBox.expand(),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  Widget waitDialog() {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Center(
            child: Text(
          'Creating Game',
          style: TextStyle(fontSize: 24),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wait, it may take a\nfew seconds',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Container(
              height: 85,
              // child: LoadingIndicator(
              //     indicatorType: Indicator
              //         .lineSpinFadeLoader,

              //     /// Required, The loading type of the widget
              //     colors: const [Colors.purple],

              //     /// Optional, The color collections
              //     strokeWidth: 2,

              //     /// Optional, The stroke of the line, only applicable to widget which contains line
              //     backgroundColor:
              //         Colors.transparent,

              //     /// Optional, Background of the widget
              //     pathBackgroundColor:
              //         Colors.transparent

              //     /// Optional, the stroke backgroundColor
              //     ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
