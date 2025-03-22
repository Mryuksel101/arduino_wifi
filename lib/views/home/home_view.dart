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
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildBodyForState(),
          ),
        );
      },
    );
  }

  Widget _buildBodyForState() {
    switch (_vm.state) {
      case HomeViewState.idle:
        return SizedBox();
      case HomeViewState.loading:
        return _buildLoadingState();
      case HomeViewState.scanning:
        return _buildScanningState();
      case HomeViewState.scannedDevices:
        return _buildScannedDevicesState();
      case HomeViewState.connected:
        return _buildConnectedState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningState() {
    return Padding(
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

          // Scan status indicator - active
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(width: 8),
              Text('Taranıyor...'),
            ],
          ),
          SizedBox(height: 16),

          Expanded(
            child: Center(
              child: Text(
                'Cihazlar aranıyor...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannedDevicesState() {
    return Padding(
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
                onPressed: _vm.startBleScan,
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
            child: _vm.scanResults.isEmpty
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
                    itemCount: _vm.scanResults.length,
                    itemBuilder: (context, i) {
                      final result = _vm.scanResults[i];
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
                                  onPressed: () => _vm.connectToDevice(device),
                                ),
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

  Widget _buildConnectedState() {
    return Padding(
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
                          _vm.connectedDevice?.platformName ?? 'Cihaz',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _vm.disconnectFromDevice,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veri Gönder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                SdTextField(
                  label: 'Gönderilecek Veri',
                  onChanged: (value) {},
                  textInputType: TextInputType.text,
                  textEditingController: _vm.textController,
                ),
                SizedBox(height: 10),
                SdButton(
                  backgroundColor: Colors.blue,
                  text: 'Gönder',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
