import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'my_user.dart';

class Shift {
  DateTime date;
  TimeOfDay start;
  TimeOfDay end;
  String user;
  bool wanted;
  bool approval;
  String job;
  String wantedUser;

  Shift({
    required this.date,
    required this.start,
    required this.end,
    required this.user,
    required this.wanted,
    required this.approval,
    required this.job,
    required this.wantedUser,
  });

  Shift.fromMap(Map map)
      : this(
          date: DateTime.parse(map['date'].toDate().toString()),
          start: map['start'],
          end: map['end'],
          user: map['user'],
          wanted: map['wanted'],
          approval: map['approval'],
          job: map['job'],
          wantedUser: map['wantedUser'],
        );

  Map<String, dynamic> asMap() {
    final now = new DateTime.now();
    final startDt =
        DateTime(date.year, date.month, date.day, start.hour, start.minute);
    final endDt =
        DateTime(date.year, date.month, date.day, end.hour, end.minute);
    final format = DateFormat.jm(); //"6:00 AM"

    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = startDt;
    data['start'] = format.format(startDt);
    data['end'] = format.format(endDt);
    data['user'] = user;
    data['approval'] = approval;
    data['wanted'] = wanted;
    data['job'] = job;
    data['wantedUser'] = wantedUser;

    return data;
  }
}
