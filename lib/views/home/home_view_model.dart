import 'dart:async';

import 'package:arduino_wifi/services/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeViewModel extends ChangeNotifier {
  bool isLoading = true;
  bool isBluetoothOn = false;
  String bluetoothStatus = "Kontrol ediliyor...";
  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  final BLEService _bleService = BLEService();
  final TextEditingController textController = TextEditingController();

  void _startMonitoringBluetoothState() {
    _bluetoothStateSubscription?.cancel(); // Varsa önceki aboneliği iptal et

    _bluetoothStateSubscription = _bleService.adapterState.listen((state) {
      isBluetoothOn = state == BluetoothAdapterState.on;

      // Duruma göre mesaj güncelle
      if (isBluetoothOn) {
        bluetoothStatus = "Bluetooth açık";
        // Bluetooth hazır olduğunda taramayı başlatabilirsiniz
        startBleScan();
      } else {
        bluetoothStatus = "Bluetooth kapalı";
        // Taramayı durdur
        _bleService.stopScanning();
      }

      notifyListeners();
    });
  }

  void startBleScan() {
    if (isBluetoothOn) {
      _bleService.startScanning();
    }
  }

  Future<void> init() async {
    isLoading = true;
    _startMonitoringBluetoothState();
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    textController.dispose();
    super.dispose();
  }
}
