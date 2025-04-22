import 'package:arduino_wifi/views/settings/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsViewModel _viewModel;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTapDown: (TapDownDetails details) {
                _viewModel.handleTapEvent(details, _imageKey);
              },
              child: Image(
                key: _imageKey,
                image: const AssetImage('assets/images/workplace.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) => Column(
              children: [
                const Text(
                  'Tap the image to get coordinates',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap Position: ${_viewModel.tapPosition?.dx.toStringAsFixed(2)}, ${_viewModel.tapPosition?.dy.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
