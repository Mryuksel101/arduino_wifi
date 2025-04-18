import 'package:arduino_wifi/common/widgets/sd_button.dart';
import 'package:arduino_wifi/common/widgets/text_field.dart';
import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:arduino_wifi/views/add_arrow_record/models/arrow_record_step.dart';
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
        Material(
          borderRadius: BorderRadius.circular(16),
          elevation: 3,
          shadowColor: Colors.grey.withValues(alpha: 0.2),
          type: MaterialType.card,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.bluetooth,
                      color: Colors.blue.shade800,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    "Bağlı Cihaz",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        vm.connectedDevice?.platformName ?? 'Cihaz',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                  trailing: SdButton(
                    onPressed: vm.disconnectFromDevice,
                    backgroundColor: Colors.grey,
                    text: "Bağlantıyı Kes",
                  ),
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
              Spacer(),
              Text(
                vm.currentRecordStep.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              SdTextField(
                label: vm.currentRecordStep.title,
                onChanged: (value) {
                  if (value.isEmpty) return;
                  vm.updateSaveModel(
                      type: vm.currentRecordStep.type, value: value);
                },
                textInputType: TextInputType.text,
                textEditingController: vm.textController,
              ),
              SizedBox(height: 10),
              Spacer(),
              SdButton(
                backgroundColor: Colors.blue,
                text: vm.currentRecordStepIndex < arrowRecordSteps.length - 1
                    ? 'Kaydet ve İlerle'
                    : "Kaydı Tamamla",
                onPressed: () {
                  if (vm.currentRecordStepIndex < arrowRecordSteps.length - 1) {
                    vm.nextStep();
                  } else {
                    if (vm.isArrowRecordSaving) return;
                    vm.saveArrowRecord();
                  }
                },
                loading: vm.isArrowRecordSaving,
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    ),
  );
}
