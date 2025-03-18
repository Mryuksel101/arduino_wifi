import 'dart:async';

import 'package:arduino_wifi/services/ble_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.context);
  bool isLoading = true;
  bool isBluetoothOn = false;
  String bluetoothStatus = "Kontrol ediliyor...";
  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  final BLEService _bleService = BLEService();
  final TextEditingController textController = TextEditingController();
  final BuildContext context;

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
        // Use post-frame callback to avoid showing dialog during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBluetoothAlert(context);
        });

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

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere((f) => f.name == 'animations/cat.json');
    });
  }

  Future<LottieComposition?> customDecoder2(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
    });
  }

  void _showBluetoothAlert(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Bluetooth Alert",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => Container(), // Kullanılmıyor
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Bluetooth Kapalı",
              style: TextStyle(
                  color: CupertinoColors.systemRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  child: Lottie.asset(
                    fit: BoxFit.cover,
                    'assets/animations/bluetooth.json',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Cihazları taramak için lütfen Bluetooth'u açın.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  dismissBluetoothAlert();
                },
                child: Text("Tamam"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Bluetooth ayarlarını açma girişimi
                  // FlutterBluePlus.turnOn(); // Bu şu anda Flutter Blue Plus'ta doğrudan desteklenmiyor
                  Navigator.pop(context);
                  dismissBluetoothAlert();
                },
                child: Text("Bluetooth'u Aç"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dismissBluetoothAlert() {
    notifyListeners();
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
