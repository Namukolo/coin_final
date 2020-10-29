import 'package:flutter/material.dart';

Color getColor(BuildContext context, double percent) {
  if (percent >= 0.50) {
    // return Theme.of(context).primaryColor;
    return Colors.deepOrange[600];
  } else if (percent >= 0.25) {
    // return Colors.orange;
    return Colors.black87;
  }
  return Colors.red;
}
