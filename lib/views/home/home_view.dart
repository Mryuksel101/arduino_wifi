import 'package:arduino_wifi/views/home/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = HomeViewModel();
    _vm.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _vm.textController,
            decoration: InputDecoration(
              hintText: 'Arduino\'ya gönderilecek veri',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Burada Arduino'ya veri göndermek için metod çağrılıyor
              // Örnek: sendDataToArduino('AÇ');
              _vm.sendDataToArduino('Merhaba dünya');
            },
            child: Text('Arduino\'ya veri gönder'),
          ),
        ],
      ),
    );
  }
}
