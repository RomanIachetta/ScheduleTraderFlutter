import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/utils/firebase_functions.dart';

class UserPreferences {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // static MyUser myUser = MyUser(
  //     imagePath: 'img',
  //     email: "v",
  //     uid: "s",
  //     isDarkMode: false,
  //     jobs: [],
  //     name: '',
  //     work: '');

  static MyUser? myUser;

  // static MyUser myUser =
  //     FirebaseFunctions.convertFirebaseUserToMyUser(auth.currentUser!);
  // auth changed user stream

}
