import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:arduino_wifi/common/widgets/sd_button.dart';
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

  // Bluetooth ayarlarını açma metodu
  Future<void> _openBluetoothSettings() async {
    try {
      if (Platform.isAndroid) {
        await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
      } else if (Platform.isIOS) {
        // iOS'ta doğrudan Bluetooth ayarlarını açamayız,
        // FlutterBluePlus'ın sistemle etkileşime girmesini sağlayabiliriz
        await FlutterBluePlus.turnOn(); // iOS'ta izin isteyebilir
      }
    } catch (e) {
      debugPrint('Bluetooth ayarları açılırken hata: $e');
    }
  }

  void _showBluetoothAlert(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Bluetooth Alert",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => Container(), // Kullanılmıyor
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Yukarıdan aşağıya kayma animasyonu
        final slideAnimation = Tween<Offset>(
          begin: Offset(0, -0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        // Soluklaşma animasyonu
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: AlertDialog(
              backgroundColor: CupertinoColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Bluetooth Kapalı",
                style: TextStyle(color: Colors.blue, fontSize: 19),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animations/bluetooth.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Cihazları taramak için lütfen Bluetooth'u açın.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                SdButton(
                  width: double.infinity,
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _openBluetoothSettings();
                  },
                  text: "Bluetooth'u Aç",
                ),
              ],
            ),
          ),
        );
      },
    );
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
