import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MyUser {
  String imagePath;
  String name;
  String email;
  String uid;
  String work;
  List<String> jobs;
  bool isDarkMode;

  MyUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.isDarkMode,
    required this.imagePath,
    required this.work,
    required this.jobs,
  });

  MyUser.fromMap(Map map)
      : this(
            name: map['userName'],
            email: map['email'],
            uid: map['uid'],
            imagePath: map['imagePath'],
            work: map['work'],
            jobs: List<String>.from(map["jobs"].map((x) => x)),
            isDarkMode: map['isDarkMode']);

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = name;
    data['email'] = email;
    data['imagePath'] = imagePath;
    data['uid'] = uid;
    data['work'] = work;
    data['jobs'] = jobs;
    data['isDarkMode'] = isDarkMode;

    return data;
  }
}
