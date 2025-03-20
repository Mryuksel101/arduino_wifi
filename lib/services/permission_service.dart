import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Bluetooth ayarlarını açma metodu
  Future<void> openBluetoothSettings() async {
    try {
      // Önce izinleri kontrol et
      if (Platform.isAndroid) {
        // Android 12 (API level 31) ve üzeri için özel Bluetooth izinleri
        if (await checkAndRequestBluetoothPermissions()) {
          await FlutterBluePlus.turnOn();
        }
      } else if (Platform.isIOS) {
        // iOS'ta Bluetooth iznini kontrol et
        PermissionStatus status = await Permission.bluetooth.request();
        if (status.isGranted) {
          AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
        } else if (status.isDenied || status.isPermanentlyDenied) {
          // İzin reddedildiyse veya kalıcı olarak reddedildiyse ayarlar sayfasına yönlendir
          await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
        }
      }
    } catch (e) {
      debugPrint('Bluetooth ayarları açılırken hata: $e');
    }
  }

  // Bluetooth izinlerini kontrol eden ve gerekirse talep eden yardımcı metod
  Future<bool> checkAndRequestBluetoothPermissions() async {
    // Android 12 ve üzeri için ek Bluetooth izinleri gerekli
    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      permissions.add(Permission.bluetooth);
      permissions.add(Permission.bluetoothScan);
      permissions.add(Permission.bluetoothConnect);
      permissions.add(Permission.bluetoothAdvertise);
      permissions
          .add(Permission.location); // BLE taraması için konum izni gerekli
    } else if (Platform.isIOS) {
      permissions.add(Permission.bluetooth);
    }

    // İzin durumlarını kontrol et
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Tüm izinlerin verilip verilmediğini kontrol et
    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    return allGranted;
  }
}
