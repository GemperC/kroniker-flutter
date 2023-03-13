import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kroniker_flutter/backend/backend.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final userRecordService =
      UserRecordService(); // create an object of UserRecordService

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        final userData = {
          'name': user.displayName!,
          'email': user.email!,
        };
        await userRecordService.createUserRecord(UserRecord(
          name: userData['name']!,
          email: userData['email']!,
          uid: user.uid,
        )); // call th
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
