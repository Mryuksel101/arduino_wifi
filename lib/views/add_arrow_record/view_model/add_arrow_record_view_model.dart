import 'dart:async';
import 'dart:developer';

import 'package:arduino_wifi/common/models/arrow.dart';
import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:arduino_wifi/services/arrow_service.dart';
import 'package:arduino_wifi/services/ble_service.dart';
import 'package:arduino_wifi/views/add_arrow_record/models/arrow_record_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AddArrowRecordViewModel extends ChangeNotifier {
  AddArrowRecordViewModel(this.context, this.bluetoothProvider) {
    init();
  }
  final TextEditingController textController = TextEditingController();
  final BluetoothProvider bluetoothProvider;
  final BuildContext context;
  BluetoothDevice? connectedDevice;
  final Arrow saveModel = Arrow.empty();
  final ArrowService _arrowService = ArrowService();
  bool isArrowRecordSaving = false;

  void startBleScan() async {
    try {
      bluetoothProvider.startBleScan();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarama başarısız: $e')),
        );
      });
    }
  }

  void stopBleScan() {
    bluetoothProvider.stopBleScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await bluetoothProvider.connectToDevice(device);
    connectedDevice = device;
  }

  Future<void> disconnectFromDevice() async {
    await bluetoothProvider.disconnectFromDevice();
    connectedDevice = null;
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
    if (bluetoothProvider.state == AddArrowRecordViewState.connected) {
      connectedDevice = bluetoothProvider.connectedDevice;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bluetoothProvider.startMonitoringBluetoothState();
      });
    }
    bluetoothProvider.addListener(
      () {
        log(bluetoothProvider.state.name);
      },
    );
  }

  void prepeareArrowRecord() {
    currentRecordStepIndex = 0;
    notifyListeners();
  }

  int currentRecordStepIndex = 0;
  ArrowRecordStep get currentRecordStep =>
      arrowRecordSteps[currentRecordStepIndex];

  void updateSaveModel(
      {required ArrowMeasurementType type, required dynamic value}) {
    switch (type) {
      case ArrowMeasurementType.code:
        saveModel.code = value as String;
        break;
      case ArrowMeasurementType.weight:
        saveModel.weight = double.parse(value);
        break;
      case ArrowMeasurementType.leftSpine:
        saveModel.leftSpine = double.parse(value);
        break;
      case ArrowMeasurementType.rightSpine:
        saveModel.rightSpine = double.parse(value);
        break;
    }
    currentRecordStep.value = value;
    textController.text = value.toString();
  }

  void saveArrowRecord() async {
    try {
      isArrowRecordSaving = true;
      notifyListeners();
      await _arrowService.addArrow(saveModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ok kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      isArrowRecordSaving = false;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ok kaydedilemedi: $e')),
      );
      isArrowRecordSaving = false;
      notifyListeners();
    }
  }

  void nextStep() {
    if (currentRecordStepIndex < arrowRecordSteps.length - 1) {
      currentRecordStepIndex++;
      textController.text = '';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
