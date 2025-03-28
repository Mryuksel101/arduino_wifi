import 'dart:async';

import 'package:arduino_wifi/common/widgets/sd_button.dart';
import 'package:arduino_wifi/services/ble_service.dart';
import 'package:arduino_wifi/services/permission_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';

enum HomeViewState { idle, loading, scanning, scannedDevices, connected }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.context);
  HomeViewState state = HomeViewState.loading;
  String bluetoothStatus = "Kontrol ediliyor...";
  bool isBtOffAlertShown = false;
  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  List<ScanResult> scanResults = [];
  final BLEService _bleService = BLEService();
  final PermissionService _permissionService = PermissionService();
  final TextEditingController textController = TextEditingController();
  final BuildContext context;
  BluetoothDevice? connectedDevice;

  void _startMonitoringBluetoothState() {
    _bluetoothStateSubscription?.cancel(); // Varsa önceki aboneliği iptal et

    _bluetoothStateSubscription = _bleService.adapterState.listen((state) {
      // Duruma göre mesaj güncelle
      if (state == BluetoothAdapterState.on) {
        bluetoothStatus = "Bluetooth açık";
        if (isBtOffAlertShown) {
          // Bluetooth alert'ini kapat
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          isBtOffAlertShown = false;
        }

        // Bluetooth hazır olduğunda taramayı başlatabilirsiniz
        startBleScan();
      } else if (state == BluetoothAdapterState.off) {
        // Taramayı durdur
        _bleService.stopScanning();
        this.state = HomeViewState.idle;
        notifyListeners();
        bluetoothStatus = "Bluetooth kapalı";
        // Use post-frame callback to avoid showing dialog during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBluetoothAlert(context);
        });
      }

      notifyListeners();
    });
  }

  void startBleScan() async {
    state = HomeViewState.scanning;
    notifyListeners();
    await _bleService.startScanning();
    state = HomeViewState.scannedDevices;
    notifyListeners();
    _listenToScanResults();
  }

  void stopBleScan() {
    _bleService.stopScanning();
  }

  void _listenToScanResults() {
    _scanResultsSubscription?.cancel();
    _scanResultsSubscription = _bleService.scanResults.listen((results) {
      scanResults = results;
      notifyListeners();
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;
      state = HomeViewState.connected;
      notifyListeners();

      // Show connection success message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Cihaza bağlandı: ${device.name}')),
        );
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bağlantı başarısız: $e')),
        );
      });
    }
  }

  Future<void> disconnectFromDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      state = HomeViewState.scannedDevices;
      notifyListeners();
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
    await _permissionService.openBluetoothSettings();
  }

  void _showBluetoothAlert(BuildContext context) {
    isBtOffAlertShown = true;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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

  Future<void> sendToArduino(String text) async {
    if (connectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cihaz bağlı değil')),
      );
      return;
    }

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir mesaj girin')),
      );
      return;
    }

    if (text.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj 20 karakterden uzun olamaz')),
      );
      return;
    }

    try {
      // Get the services
      List<BluetoothService> services =
          await connectedDevice!.discoverServices();

      // Find the service
      BluetoothService? targetService;
      for (var service in services) {
        if (service.uuid.str == BLEService.serviceUUID) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arduino servisi bulunamadı')),
        );
        return;
      }

      // Find the characteristic
      BluetoothCharacteristic? targetCharacteristic;
      for (var characteristic in targetService.characteristics) {
        if (characteristic.uuid.str == BLEService.characteristicUUID) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arduino özelliği bulunamadı')),
        );
        return;
      }

      // Convert the text to bytes and write to the characteristic
      List<int> bytes = text.codeUnits;
      await targetCharacteristic.write(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mesaj gönderildi: $text'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear text field after sending
      textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilemedi: $e')),
      );
    }
  }

  Future<void> init() async {
    state = HomeViewState.loading;
    notifyListeners();
    _startMonitoringBluetoothState();
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    textController.dispose();
    super.dispose();
  }
}
