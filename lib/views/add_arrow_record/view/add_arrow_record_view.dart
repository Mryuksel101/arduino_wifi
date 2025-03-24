import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:arduino_wifi/views/add_arrow_record/view_model/add_arrow_record_view_model.dart';
import 'package:arduino_wifi/views/add_arrow_record/widgets/connected_state_widget.dart';
import 'package:arduino_wifi/views/add_arrow_record/widgets/loading_state_widget.dart';
import 'package:arduino_wifi/views/add_arrow_record/widgets/scanned_devices_state_widget.dart';
import 'package:arduino_wifi/views/add_arrow_record/widgets/scanning_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddArrowRecordView extends StatefulWidget {
  const AddArrowRecordView({super.key});

  @override
  State<AddArrowRecordView> createState() => _AddArrowRecordViewState();
}

class _AddArrowRecordViewState extends State<AddArrowRecordView> {
  late final AddArrowRecordViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = AddArrowRecordViewModel(
        context, Provider.of<BluetoothProvider>(context, listen: false));
    _vm.init();
  }

  @override
  Widget build(BuildContext context) {
    final BluetoothProvider bluetoothProvider =
        Provider.of<BluetoothProvider>(context, listen: true);
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Yeni Ok Kaydı Ekle'),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _buildBodyForState(bluetoothProvider.state, bluetoothProvider),
          ),
        );
      },
    );
  }

  Widget _buildBodyForState(
      AddArrowRecordViewState state, BluetoothProvider bluetoothProvider) {
    switch (state) {
      case AddArrowRecordViewState.idle:
        return SizedBox(
          key: ValueKey(state),
        );
      case AddArrowRecordViewState.loading:
        return buildLoadingState(state);
      case AddArrowRecordViewState.scanning:
        return buildScanningState(state);
      case AddArrowRecordViewState.scannedDevices:
        return buildScannedDevicesState(
            state: state,
            scanResults: bluetoothProvider.scanResults,
            connectToDevice: (device) => _vm.connectToDevice(device),
            startBleScan: () => _vm.startBleScan());
      case AddArrowRecordViewState.connected:
        return buildConnectedState(state, _vm);
    }
  }
}
