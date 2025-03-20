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
          body: _buildBodyForState(),
        );
      },
    );
  }

  Widget _buildBodyForState() {
    switch (_vm.state) {
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

          // Scan status indicator - inactive
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
            ],
          ),
          SizedBox(height: 8),

          // Devices list
          Expanded(
            child: _vm.scanResults.isEmpty
                ? Center(
                    child: Text(
                      'Hiç cihaz bulunamadı',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
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

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(Icons.bluetooth),
                          title: Text(name),
                          subtitle: Text(
                              'MAC: ${device.remoteId.str}\nSinyal Gücü: $rssi dBm'),
                          trailing: ElevatedButton(
                            child: Text('Bağlan'),
                            onPressed: () => _vm.connectToDevice(device),
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
