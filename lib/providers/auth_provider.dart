import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    _initializeAuthState();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  // Initialize auth state listener
  void _initializeAuthState() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.signInWithEmailPassword(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      return false;
    }
  }

  // Sign up
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.signUpWithEmailPassword(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      return false;
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
