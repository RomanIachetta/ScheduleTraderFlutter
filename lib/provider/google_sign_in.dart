import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => user;

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

      var auth = await FirebaseAuth.instance.signInWithCredential(credential);

      UserPreferences.myUser =
          await FirebaseFunctions.convertFirebaseUserToMyUser(auth.user!, '');
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    if (googleSignIn.currentUser != null) {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } else {
      FirebaseAuth.instance.signOut();
    }
  }
}
