import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';

Widget buildScanningState(AddArrowRecordViewState state) {
  return Padding(
    key: ValueKey(state),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bulunan Cihazlar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Scan status indicator - active
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(width: 8),
            Text('Taranıyor...'),
          ],
        ),
        SizedBox(height: 16),

        Expanded(
          child: Center(
            child: Text(
              'Cihazlar aranıyor...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
