import 'package:flutter/material.dart';

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }
}
