import 'package:arduino_wifi/firebase_options.dart';
import 'package:arduino_wifi/helpers/snackbar_global.dart';
import 'package:arduino_wifi/helpers/ui_helpers.dart';
import 'package:arduino_wifi/providers/bluetooth_provider.dart';
import 'package:arduino_wifi/views/bottom_nav/bottom_nav_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // White status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons for visibility
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // BLE servisini provider olarak ekle
        ChangeNotifierProvider<BluetoothProvider>(
          create: (_) => BluetoothProvider(
            context,
          ),
        ),
        // İhtiyaç duyarsanız daha fazla provider ekleyebilirsiniz
      ],
      child: MaterialApp(
        scaffoldMessengerKey: SnackbarGlobal.key,
        navigatorKey: UiHelpers.navigator,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          // Poppins fontunu tüm uygulamaya uygula
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const BottomNavView(),
      ),
    );
  }
}
