import 'package:arduino_wifi/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutViewModel extends ChangeNotifier {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> logout() async {
    if (_context != null) {
      final authProvider = Provider.of<AuthProvider>(_context!, listen: false);
      await authProvider.signOut();
    }
  }
}
