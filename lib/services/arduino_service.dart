import 'dart:io';

class ArduinoService {
  void sendToArduino(String data) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      final address = InternetAddress('192.168.101.71'); // Örn: 192.168.43.100
      socket.send(data.codeUnits, address, 1234);
    });
  }
}
