import 'package:flutter/material.dart';

import '../../services/arduino_service.dart'; // Arduino servisini import ediyoruz - yol projenize göre değişebilir

class HomeViewModel extends ChangeNotifier {
  bool isLoading = true;

  // Arduino servisi örneği
  final ArduinoService _arduinoService = ArduinoService();
  final TextEditingController textController = TextEditingController();

  // Arduino'ya veri göndermek için metod
  void sendDataToArduino(String data) {
    _arduinoService.sendToArduino(data);
    notifyListeners(); // UI'ı güncellemek istiyorsanız
  }

  Future<void> init() async {
    isLoading = true;
    textController.addListener(() {
      sendDataToArduino(textController.text);
    });
    await _arduinoService.initializeSocket();
    isLoading = false;
    notifyListeners();
  }
}
