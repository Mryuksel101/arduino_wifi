import 'package:arduino_wifi/views/settings/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _viewModel.handleTapEvent(details, context);
          },
          child: Image(
            image: const AssetImage('assets/images/workplace.jpg'),
          )),
    );
  }
}
