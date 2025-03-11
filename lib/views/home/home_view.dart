import 'package:arduino_wifi/common/widgets/sd_button.dart';
import 'package:arduino_wifi/common/widgets/text_field.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SdTextField(
              label: 'Arduino\'ya gönderilecek veri',
              textEditingController: _vm.textController,
              onChanged: (value) {
                // Burada Arduino'ya veri göndermek için metod çağrılıyor
                // Örnek: sendDataToArduino('AÇ');
                _vm.sendDataToArduino(value);
              },
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 10),
            SdButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                // Burada Arduino'ya veri göndermek için metod çağrılıyor
                // Örnek: sendDataToArduino('AÇ');
                _vm.sendDataToArduino('Merhaba dünya');
              },
              text: 'Arduino\'ya veri gönder',
            ),
          ],
        ),
      ),
    );
  }
}
