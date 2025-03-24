import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';

Widget buildLoadingState(AddArrowRecordViewState state) {
  return Center(
    key: ValueKey(state),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
