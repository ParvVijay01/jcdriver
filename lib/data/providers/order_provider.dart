import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jcdriver/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final Dio dio = Dio(BaseOptions(baseUrl: MAIN_URL));
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  Future<void> fetchOrders() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? riderId = prefs.getString('riderId');

    if (riderId == null) return;

    final response = await dio.get("/api/rider/pending-deliveries/$riderId");

    if (response.statusCode == 200) {
      // Proper parsing with explicit type casting
      _orders = (response.data as List)
          .map((order) => order as Map<String, dynamic>)
          .toList();

      print("Fetched Orders: $_orders");  // Log the result for debugging
      notifyListeners();
    }
  } catch (e) {
    print("Error fetching orders: $e");
  }
}

}
