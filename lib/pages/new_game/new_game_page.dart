import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kroniker_flutter/backend/records/game_record.dart';
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
          'myGames': FieldValue.arrayUnion([gameDoc.id])
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _model.titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      setState(() => _model.titleController!.text = value!),
                ),
                TextFormField(
                  controller: _model.descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _model.systemController,
                  decoration: const InputDecoration(labelText: 'System'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a system';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _model.sessionNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Session Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a system';
                    }
                    return null;
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    pickImage();
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Pick Image"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.camera),
                  label: Text("upload Image"),
                ),
                image != null ? Image.file(image!) : Container(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _submitForm();
          },
        ),
      ),
    );
  }
}
