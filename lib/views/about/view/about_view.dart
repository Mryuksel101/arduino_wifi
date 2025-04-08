import 'package:arduino_wifi/views/about/view_model/about_view_model.dart';
import 'package:flutter/material.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late final AboutViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AboutViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setContext(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('About View'),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => viewModel.logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Çıkış Yap'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
