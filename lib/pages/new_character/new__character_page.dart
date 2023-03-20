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
import 'new_character_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class NewCharacterPage extends StatefulWidget {
  const NewCharacterPage({super.key});

  @override
  State<NewCharacterPage> createState() => _NewCharacterPageState();
}

class _NewCharacterPageState extends State<NewCharacterPage> {
  final gameRecordService = GameRecordService();
  final user = FirebaseAuth.instance.currentUser!;
  late NewCharacterModel _model;
  late FirebaseStorage storage;
  late Reference storageReference;
  File? image;
  bool uploadingGame = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _model = createModel(context, () => NewCharacterModel());
    storage = FirebaseStorage.instance;
    storageReference = storage.ref().child('images');

    _model.nameController ??= TextEditingController();
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
        title: _model.nameController!.text,
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
            builder: (context) => const HomePage(),
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
              body: Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(
                    canvasColor: Colors.white,
                    colorScheme: ColorScheme.light(primary: Colors.orange),
                  ),
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepTapped: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    onStepContinue: () {
                      setState(() {
                        if (_currentStep < 2) {
                          _currentStep++;
                        } else {
                          // Do something when last step is reached
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentStep > 0) {
                          _currentStep--;
                        }
                      });
                    },
                    steps: [
                      Step(
                        title: Text('Who are You'),
                        content: Text('This is the content for step 1'),
                        isActive: _currentStep == 0,
                      ),
                      Step(
                        title: Text('Step 2'),
                        content: Text('This is the content for step 2'),
                        isActive: _currentStep == 1,
                      ),
                      Step(
                        title: Text('Step 3'),
                        content: Text('This is the content for step 3'),
                        isActive: _currentStep == 2,
                      ),
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
                      child: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.check),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            uploadingGame
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(124, 0, 0, 0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const SizedBox.expand(),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}
