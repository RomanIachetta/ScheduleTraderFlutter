import 'package:flutter/material.dart';

class Event {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String job;
  final String fullName;
  final String shiftId;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.job,
    required this.fullName,
    required this.shiftId,
  });
  @override
  String toString() => title;
}
