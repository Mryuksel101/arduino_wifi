import 'dart:async';

import 'package:arduino_wifi/helpers/snackbar_global.dart';
import 'package:arduino_wifi/helpers/ui_helpers.dart';
import 'package:arduino_wifi/services/ble_service.dart';
import 'package:arduino_wifi/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum AddArrowRecordViewState {
  idle,
  loading,
  scanning,
  scannedDevices,
  connected
}

class BluetoothProvider extends ChangeNotifier {
  final BuildContext context;
  BluetoothProvider(
    this.context,
  );
  bool isBtOffAlertShown = false;
  AddArrowRecordViewState state = AddArrowRecordViewState.loading;

  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  List<ScanResult> scanResults = [];
  final BLEService _bleService = BLEService();
  final PermissionService _permissionService = PermissionService();
  String bluetoothStatus = "Kontrol ediliyor...";
  BluetoothDevice? connectedDevice;

  void startMonitoringBluetoothState() {
    _bluetoothStateSubscription?.cancel(); // Varsa önceki aboneliği iptal et

    _bluetoothStateSubscription = _bleService.adapterState.listen((state) {
      // Duruma göre mesaj güncelle
      if (state == BluetoothAdapterState.on) {
        bluetoothStatus = "Bluetooth açık";
        if (isBtOffAlertShown) {
          // Bluetooth alert'ini kapat
          WidgetsBinding.instance.addPostFrameCallback((_) {
            UiHelpers.hideAlert();
          });
          isBtOffAlertShown = false;
        }

        // Bluetooth hazır olduğunda taramayı başlatabilirsiniz
        _startBleScan();
      } else if (state == BluetoothAdapterState.off) {
        // Taramayı durdur
        _bleService.stopScanning();
        this.state = AddArrowRecordViewState.idle;
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

  void _showBluetoothAlert(BuildContext context) {
    isBtOffAlertShown = true;
    UiHelpers.showBtOffAlert(_openBluetoothSettings);
  }

  // Bluetooth ayarlarını açma metodu
  Future<void> _openBluetoothSettings() async {
    await _permissionService.openBluetoothSettings();
  }

  void _startBleScan() async {
    state = AddArrowRecordViewState.scanning;
    notifyListeners();
    await _bleService.startScanning();
    state = AddArrowRecordViewState.scannedDevices;
    notifyListeners();
    _listenToScanResults();
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
      state = AddArrowRecordViewState.connected;
      notifyListeners();

      // Show connection success message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarGlobal.show('Cihaza bağlandı: ${device.name}');
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarGlobal.show('Bağlantı başarısız: $e');
      });
    }
  }

  Future<void> disconnectFromDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      state = AddArrowRecordViewState.scannedDevices;
      notifyListeners();
    }
  }

  void startBleScan() async {
    state = AddArrowRecordViewState.scanning;
    notifyListeners();
    await _bleService.startScanning();
    state = AddArrowRecordViewState.scannedDevices;
    notifyListeners();
    _listenToScanResults();
  }

  void stopBleScan() {
    _bleService.stopScanning();
  }
}
