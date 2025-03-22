import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  static const String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String characteristicUUID =
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _targetCharacteristic;

  // Singleton pattern
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;
  BLEService._internal();

  // Streams for UI updates
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;
  // Start BLE scanning
  Future<void> startScanning(
      {Duration timeout = const Duration(seconds: 4)}) async {
    await FlutterBluePlus.startScan(timeout: timeout);
  }

  // Stop scanning
  void stopScanning() {
    FlutterBluePlus.stopScan();
  }

  // Connect to device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      _connectedDevice = device;

      // Discover services after connection
      await _discoverServices();
    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }

  // Discover services and characteristics
  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;

    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid == Guid(serviceUUID)) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid == Guid(characteristicUUID)) {
            _targetCharacteristic = characteristic;
            return;
          }
        }
      }
    }
    throw Exception("Characteristics not found");
  }

  // Read characteristic value
  Future<String> readCharacteristic() async {
    if (_targetCharacteristic == null) {
      throw Exception("Characteristic not initialized");
    }

    List<int> value = await _targetCharacteristic!.read();
    return String.fromCharCodes(value);
  }

  // Write to characteristic
  Future<void> writeCharacteristic(List<int> value) async {
    if (_targetCharacteristic == null) {
      throw Exception("Characteristic not initialized");
    }

    await _targetCharacteristic!.write(value);
  }

  // Disconnect from device
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _targetCharacteristic = null;
    }
  }
}
