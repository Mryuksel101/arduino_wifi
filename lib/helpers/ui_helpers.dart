import 'package:arduino_wifi/common/widgets/sd_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UiHelpers {
  static final GlobalKey<NavigatorState> navigator =
      GlobalKey<NavigatorState>(debugLabel: 'AppNavigator');

  static void showBtOffAlert(
      final BuildContext context, final Function openBluetoothSettings) {
    // Store the original context to use for the Bluetooth settings
    final BuildContext outerContext = context;

    showGeneralDialog(
      context: navigator.currentContext!,
      barrierDismissible: false,
      barrierLabel: "Bluetooth Alert",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => Container(), // Kullanılmıyor
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        // Yukarıdan aşağıya kayma animasyonu
        final slideAnimation = Tween<Offset>(
          begin: Offset(0, -0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        // Soluklaşma animasyonu
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: AlertDialog(
              backgroundColor: CupertinoColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Bluetooth Kapalı",
                style: TextStyle(color: Colors.blue, fontSize: 19),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animations/bluetooth.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Cihazları taramak için lütfen Bluetooth'u açın.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                SdButton(
                  width: double.infinity,
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    // Dismiss the dialog using the dialog context
                    Navigator.of(dialogContext).pop();

                    // Use the original context for Bluetooth settings
                    // Wrap in Future.delayed to ensure dialog is fully dismissed first
                    Future.delayed(Duration.zero, () {
                      if (outerContext.mounted) {
                        openBluetoothSettings();
                      }
                    });
                  },
                  text: "Bluetooth'u Aç",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
