import 'package:arduino_wifi/common/widgets/sd_button.dart';
import 'package:arduino_wifi/common/widgets/text_field.dart';
import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:arduino_wifi/views/add_arrow_record/view_model/add_arrow_record_view_model.dart';
import 'package:flutter/material.dart';

Widget buildConnectedState(
  final AddArrowRecordViewState state,
  final AddArrowRecordViewModel vm,
) {
  return Padding(
    key: ValueKey(state),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connected device info
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bağlı Cihaz',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        vm.connectedDevice?.platformName ?? 'Cihaz',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: vm.disconnectFromDevice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                  ),
                  child: Text('Bağlantıyı Kes'),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Data sending section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                vm.currentRecordStep.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              SdTextField(
                label: vm.currentRecordStep.title,
                onChanged: (value) {
                  vm.sendToArduino(value);
                },
                textInputType: TextInputType.text,
                textEditingController: vm.textController,
              ),
              SizedBox(height: 10),
              Spacer(),
              SdButton(
                backgroundColor: Colors.blue,
                text: 'Kaydet',
                onPressed: () {
                  vm.sendToArduino("Hello, Arduino!");
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    ),
  );
}
