import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model class for user data
class UserRecord {
  final String name;
  final String email;
  final String uid;
  final List<dynamic>? myGames;

  UserRecord({
    required this.name,
    required this.email,
    required this.uid,
    this.myGames,
  });

  // Convert Firestore document to UserRecord object
  factory UserRecord.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserRecord(
      name: data['name'],
      email: data['email'],
      uid: data['uid'],
      myGames: data['myGames'],
    );
  }
}

class UserRecordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  // Function to get user data as a Future
  Future<UserRecord> getUserData(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return UserRecord.fromDocument(doc);
  }

  // Function to get user data as a Stream
  Stream<UserRecord> streamUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map(
          (doc) => UserRecord.fromDocument(doc),
        );
  }

  // Function to create a new user document in Firestore
  Future<void> createUserRecord(UserRecord user) async {
    await _usersRef.doc(user.uid).set({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
      'myGames': user.myGames,
    });
  }

  // Function to delete a user document from Firestore
  Future<void> deleteUserRecord(String uid) async {
    await _usersRef.doc(uid).delete();
  }
}
