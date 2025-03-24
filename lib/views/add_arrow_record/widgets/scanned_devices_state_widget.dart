import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Widget buildScannedDevicesState({
  required AddArrowRecordViewState state,
  required List<ScanResult> scanResults,
  required final VoidCallback startBleScan,
  required final Function(BluetoothDevice device) connectToDevice,
}) {
  return Padding(
    key: ValueKey(state),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bulunan Cihazlar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Scan status indicator - inactive with rescan button
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(width: 8),
            Text('Tarama durdu'),
            Spacer(),
            ElevatedButton.icon(
              onPressed: startBleScan,
              icon: Icon(
                Icons.refresh,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                'Tekrar Tara',
                style: TextStyle(
                  letterSpacing: 0.015, // tracking-[0.015em],
                  fontWeight: FontWeight.bold, // font-bold
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Devices list
        Expanded(
          child: scanResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.device_unknown,
                          size: 70, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Hiç cihaz bulunamadı',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: scanResults.length,
                  itemBuilder: (context, i) {
                    final result = scanResults[i];
                    final device = result.device;
                    final name = device.platformName.isNotEmpty
                        ? device.platformName
                        : 'Bilinmeyen Cihaz';
                    final rssi = result.rssi;

                    // Signal strength indicator
                    int signalBars = 0;
                    if (rssi > -60) {
                      signalBars = 4;
                    } else if (rssi > -70) {
                      signalBars = 3;
                    } else if (rssi > -80) {
                      signalBars = 2;
                    } else if (rssi > -90) {
                      signalBars = 1;
                    }

                    return Material(
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
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('MAC: ${device.remoteId.str}'),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text('Sinyal: '),
                                      ...List.generate(
                                        4,
                                        (index) => Container(
                                          width: 5,
                                          height: 12 + (index * 3),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                            color: index < signalBars
                                                ? Colors.green
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      Text(' $rssi dBm'),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Bağlan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => connectToDevice(device)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
