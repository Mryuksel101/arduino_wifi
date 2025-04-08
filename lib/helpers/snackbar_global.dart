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

  // showErrorSnackbar is a static method that displays an error snackbar with a red background color.
  static void showAlert(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
