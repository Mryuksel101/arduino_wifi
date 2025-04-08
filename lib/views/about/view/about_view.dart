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
      if (mounted) {
        viewModel.setContext(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hakkında'),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: FloatingActionButton.extended(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            backgroundColor: Colors.grey,
            onPressed: viewModel.logout,
            label: Row(
              children: [
                Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Çıkış Yap",
                  style: TextStyle(color: Colors.white, letterSpacing: 0.5),
                )
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('About View'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
