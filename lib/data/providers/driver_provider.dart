import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jcdriver/services/dio_servce.dart';

class DriverProvider with ChangeNotifier {
  final HttpService service = HttpService();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  String? _riderId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  String? get riderId => _riderId;

  /// 🔹 Login Rider & Store Rider ID
  Future<bool> loginRider(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Response? response = await service.loginRider(username: username, password: password);

      if (response != null && response.statusCode == 200) {
        _userData = response.data; // Store user data
        _riderId = _userData?['_id']; // Extract rider ID

        // Store rider ID in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('riderId', _riderId!);

        _isLoading = false;
        notifyListeners();
        return true; // Login successful
      } else {
        _errorMessage = response?.data['error'] ?? "Invalid credentials";
      }
    } catch (e) {
      _errorMessage = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false; // Login failed
  }

  /// 🔹 Load Rider ID from SharedPreferences
  Future<void> loadRiderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _riderId = prefs.getString('riderId');
    notifyListeners();
  }

  /// 🔹 Logout & Clear Rider ID
  void logout() async {
    _userData = null;
    _riderId = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('riderId');

    notifyListeners();
  }
}
