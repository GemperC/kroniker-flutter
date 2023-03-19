import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kroniker_flutter/backend/backend.dart';

// Model class for character data
class CharacterRecord {
  final String name;
  final String? description;
  final String? race;
  final String? classType;
  final String id;
  final String key;
  final List<dynamic>? players;
  final DocumentReference owner;
  final String? level;
  final String? imageUrl;

  CharacterRecord({
    required this.name,
    this.description,
    this.race,
    this.classType,
    required this.id,
    required this.key,
    this.players,
    required this.owner,
    this.level,
    this.imageUrl,
  });

  // Convert Firestore document to CharacterRecord object
  factory CharacterRecord.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CharacterRecord(
      name: data['name'],
      description: data['description'],
      race: data['race'],
      classType: data['classType'],
      id: data['id'],
      key: data['key'],
      players: List<DocumentReference>.from(data['players']),
      owner: data['owner'],
      level: data['level'],
      imageUrl: data['imageUrl'],
    );
  }
}

class CharacterRecordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _characterRecordsRef =
      FirebaseFirestore.instance.collection('characters');

  // Function to get character data as a Future
  Future<CharacterRecord> getCharacterRecord(String id) async {
    final doc = await _characterRecordsRef.doc(id).get();
    return CharacterRecord.fromDocument(doc);
  }

  // Function to get character data as a Stream
  Stream<CharacterRecord> streamCharacterRecord(String id) {
    return _characterRecordsRef.doc(id).snapshots().map(
          (doc) => CharacterRecord.fromDocument(doc),
        );
  }

  Stream<List<CharacterRecord>> streamCharacterCollection() {
    return _characterRecordsRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => CharacterRecord.fromDocument(doc))
              .toList(),
        );
  }



  Stream<List<CharacterRecord>> streamCharactersForUser(UserRecord userDoc) {
    if (userDoc.myCharacters.isEmpty) {
      return Stream.fromIterable([]);
      
    }
    return _characterRecordsRef
        .where(FieldPath.documentId, whereIn: userDoc.myCharacters)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => CharacterRecord.fromDocument(doc))
          .toList();
    });
  }

  // Function to create a new character document in Firestore
  Future<void> createCharacterRecord(
      String characterDocID, CharacterRecord characterRecord) async {
    await _characterRecordsRef.doc(characterDocID).set({
      'name': characterRecord.name,
      'description': characterRecord.description,
      'race': characterRecord.race,
      'classType': characterRecord.classType,
      'id': characterDocID,
      'key': characterRecord.key,
      'players': characterRecord.players,
      'owner': characterRecord.owner,
      'level': characterRecord.level,
      'imageUrl': characterRecord.imageUrl,
    });
  }

  // Function to delete a character document from Firestore
  Future<void> deleteCharacterRecord(String id) async {
    await _characterRecordsRef.doc(id).delete();
  }
}
