import 'dart:developer';
import 'dart:io';

class ArduinoService {
  RawDatagramSocket? udpSocket; // Global UDP socket değişkeni

  Future<void> initializeSocket() async {
    try {
      // IP: anyIPv4, port: 0 (sistem tarafından dinamik olarak atanır)
      udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      log("UDP Socket oluşturuldu. Yerel port: ${udpSocket!.port}");
    } catch (e) {
      log("UDP socket oluşturulurken hata oluştu: $e");
    }
  }

  Future<void> sendToArduino(String data) async {
    // Eğer socket henüz oluşturulmamışsa, initialize et
    if (udpSocket == null) {
      await initializeSocket();
    }
    final address = InternetAddress('192.168.101.71'); // ESP8266'nın IP adresi
    final bytesSent = udpSocket!.send(data.codeUnits, address, 1234);
    if (bytesSent == -1) {
      log("Gönderim başarısız!");
    } else {
      log("$bytesSent byte gönderildi: $data");
    }
  }
}
