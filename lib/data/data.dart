import 'dart:ui';

import 'package:flutter/material.dart';

class Task {
  final String taskVal;
  final String taskDetails;
  // final Color colorVal;
  Task(
    this.taskDetails,
    this.taskVal,
  );

  Task.fromMap(Map<String, dynamic> map)
      : assert(map['producttype'] != null),
        assert(map['points'] != null),
        // assert(map['colorVal'] != null),
        taskDetails = map['producttype'],
        taskVal = map['points'];
  // colorVal = Colors.blue;

  @override
  String toString() => "Record<$taskVal:$taskDetails>";
}
