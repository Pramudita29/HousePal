import 'package:flutter/material.dart';

void showMySnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
