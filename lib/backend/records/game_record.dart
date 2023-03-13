import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model class for user data
class GameRecord {
  final String title;
  final String? description;
  final String? system;
  final String id;
  final String key;
  final List<DocumentReference>? players;
  final DocumentReference dm;
  final String? sessionNumber;
  final String? imageUrl;

  GameRecord({
    required this.title,
    this.description,
    this.system,
    required this.id,
    required this.key,
    this.players,
    required this.dm,
    this.sessionNumber,
    this.imageUrl,
  });
  // Convert Firestore document to GameRecord object
  factory GameRecord.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameRecord(
      title: data['title'],
      description: data['description'],
      system: data['system'],
      id: data['id'],
      key: data['key'],
      players: List<DocumentReference>.from(data['players']),
      dm: data['dm'],
      sessionNumber: data['sessionNumber'],
      imageUrl: data['imageUrl'],
    );
  }
}

class GameRecordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _gameRecordsRef =
      FirebaseFirestore.instance.collection('games');

  // Function to get user data as a Future
  Future<GameRecord> getGameRecord(String id) async {
    final doc = await _gameRecordsRef.doc(id).get();
    return GameRecord.fromDocument(doc);
  }

  // Function to get user data as a Stream
  Stream<GameRecord> streamGameRecord(String id) {
    return _gameRecordsRef.doc(id).snapshots().map(
          (doc) => GameRecord.fromDocument(doc),
        );
  }

  Stream<List<GameRecord>> streamGameCollection() {
    return _gameRecordsRef.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => GameRecord.fromDocument(doc)).toList(),
        );
  }

  Stream<List<GameRecord>> streamGamesForUser(Map<String, dynamic> userDocData) {
  List<String> myGameIds = List<String>.from(userDocData['myGames']);
  return _gameRecordsRef
      .where(FieldPath.documentId, whereIn: myGameIds)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => GameRecord.fromDocument(doc)).toList();
  });
}

  // Function to create a new user document in Firestore
  Future<void> createGameRecord(String gameDocID, GameRecord gameRecord) async {
    await _gameRecordsRef.doc(gameDocID).set({
      'title': gameRecord.title,
      'description': gameRecord.description,
      'system': gameRecord.system,
      'id': gameDocID,
      'key': gameRecord.key,
      'players': gameRecord.players,
      'dm': gameRecord.dm,
      'sessionNumber': gameRecord.sessionNumber,
      'imageUrl': gameRecord.imageUrl,
    });
  }

  // Function to delete a user document from Firestore
  Future<void> deleteGameRecord(String id) async {
    await _gameRecordsRef.doc(id).delete();
  }
}
