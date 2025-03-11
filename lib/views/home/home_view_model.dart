import 'package:flutter/material.dart';

import '../../services/arduino_service.dart'; // Arduino servisini import ediyoruz - yol projenize göre değişebilir

class HomeViewModel extends ChangeNotifier {
  final String _title = "Home View";
  String get title => _title;

  // Arduino servisi örneği
  final ArduinoService _arduinoService = ArduinoService();
  final TextEditingController textController = TextEditingController();

  // Arduino'ya veri göndermek için metod
  void sendDataToArduino(String data) {
    _arduinoService.sendToArduino(data);
    notifyListeners(); // UI'ı güncellemek istiyorsanız
  }

  void init() {
    textController.addListener(() {
      sendDataToArduino(textController.text);
    });
  }
}
