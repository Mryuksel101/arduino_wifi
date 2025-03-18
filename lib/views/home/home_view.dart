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
    _vm = HomeViewModel(context);
    _vm.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Arduino Wifi'),
          ),
          body: _vm.isLoading
              ? Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SdTextField(
                          label: 'Gönderilecek Veri',
                          onChanged: (value) {},
                          textInputType: TextInputType.text,
                          textEditingController: _vm.textController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SdButton(
                          backgroundColor: Colors.blue,
                          text: 'Send',
                          onPressed: () {
                            //_vm.sendDataToArduino(_vm.textController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
