import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shiftit/model/event.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/model/shift.dart';

class FirebaseFunctions {
  static final usersCollection = FirebaseFirestore.instance.collection("users");
  static final nestleShiftsCollection =
      FirebaseFirestore.instance.collection("NestleShifts");
  static final nestleCollection =
      FirebaseFirestore.instance.collection("Nestle");

  static final nestleWantedShiftCollection =
      FirebaseFirestore.instance.collection("NestleWantedShifts");

  static Future<MyUser> convertFirebaseUserToMyUser(
      User user, String name) async {
    String username = '';
    if (user.displayName == null || user.displayName == "") {
      username = name;
    } else {
      username = user.displayName!;
    }

    return MyUser(
        uid: user.uid,
        email: user.email!,
        name: username,
        imagePath: user.photoURL ??
            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
        work: "Work",
        jobs: [],
        isDarkMode: true);
  }

  static getFullNameFromUserUid(String uid) async {
    DocumentSnapshot variable = await usersCollection.doc(uid).get();
    Map<String, dynamic> result =
        Map<String, dynamic>.from(variable.data() as Map<dynamic, dynamic>);

    MyUser user = MyUser.fromMap(result);
    return user.name;
  }

  static addWantedShiftsToDb(Shift shift) async {
    await nestleWantedShiftCollection.doc().set(shift.asMap());
  }

  static addUserToDb(MyUser user) async {
    await usersCollection.doc(user.uid).set(user.asMap());
  }

  static addShiftToDb(Shift shift) async {
    //var doc = await nestleShiftsCollection.doc().set(shift.asMap());
    DocumentReference docRef = await nestleShiftsCollection.add(shift.asMap());
    return docRef.id;
//    await nestleShiftsCollection.set(shift.asMap());
  }

  static getUserFromDb(String uid) async {
    //return usersCollection.doc(uid).snapshots();
    DocumentSnapshot variable = await usersCollection.doc(uid).get();

    // MyUser user = MyUser.fromMap(variable.data() as Map<String, dynamic>);
    Map<String, dynamic> result =
        Map<String, dynamic>.from(variable.data() as Map<dynamic, dynamic>);

    MyUser user = MyUser.fromMap(result);
    return user;
  }

  static getNestleShiftsFromDb() async {
    QuerySnapshot querySnapshot = await nestleShiftsCollection.get();
    var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    QueryDocumentSnapshot doc = querySnapshot.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;

    var details = new Map();

    for (var i = 0; i < allData.length; i++) {
      details[querySnapshot.docs[i].reference.id] = allData[i];
    }
    // await getNestleShiftsFromId(docRef.id);

    return details;
    //return allData;
  }

  static getUsersShiftsFromDb(String userId) async {
    Stream streamQuery = nestleShiftsCollection
        .where('user', isEqualTo: userId)
        .where('wanted', isEqualTo: false)
        .snapshots();

    var t = await nestleShiftsCollection.where('user', isEqualTo: userId).get();
    var allData = t.docs.map((doc) => doc.data()).toList();

    int i = 0;
    List<Shift> shifts = [];
    List<Event> events = [];
    for (var element in allData) {
      //   var dateTimeDate = DateTime.parse(element["date"].toDate().toString());
      //   var date = DateUtils.dateOnly(dateTimeDate);
      //   var start = element["start"];
      //   var end = element["end"];
      //   var timeDayStart = stringToTimeOfDay(start);
      //   var timeDayEnd = stringToTimeOfDay(end);
      //   Shift shift = Shift(
      //       date: date,
      //       start: timeDayStart,
      //       end: timeDayEnd,
      //       user: element["user"],
      //       wanted: element["wanted"],
      //       approval: element["approval"],
      //       job: element["job"],
      //       wantedUser: element["wantedUser"]);
      //
      //   shifts.add(shift);
      // }

      var title =
          'Start Time:${element["start"]}\nEnd Time ${element["end"]}\nJob:${element["job"]}';
      var ta = 'Start Time:${element["start"]}';

      Event event = Event(
          title: title,
          startTime: stringToTimeOfDay(element["start"]),
          endTime: stringToTimeOfDay(element["end"]),
          job: element["job"],
          fullName: element["user"],
          shiftId: t.docs[i].reference.id);
      events.add(event);

      i++;
    }

    return events;
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static removeShiftFromDb(String id) async {
    nestleShiftsCollection.doc(id).delete();
  }

  static updateShift(Shift shift, String shiftId) async {
    await nestleShiftsCollection
        .doc(shiftId)
        .update(shift.asMap())
        .then((value) => print("done"));
  }

  static updateUser(MyUser user) async {
    await usersCollection.doc(user.uid).update(user.asMap());
  }
}
