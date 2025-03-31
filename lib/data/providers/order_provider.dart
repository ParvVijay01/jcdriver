import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:jcdriver/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final Dio dio = Dio(BaseOptions(baseUrl: MAIN_URL));
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> ordersByStatus(String status) {
    return _orders.where((order) => order["status"] == status).toList();
  }

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? riderId = prefs.getString('riderId');

      if (riderId == null) {
        _orders = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await dio.get("/api/rider/my-deliveries/$riderId");

      if (response.statusCode == 200) {
        _orders = (response.data['data'] as List)
            .map((order) => order as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> storeId() async {
    try {
      var box = await Hive.openBox('appBox'); // Ensure the box is opened
      String? riderId = box.get('riderId'); // Retrieve riderId

      if (riderId == null) {
        log("Error: Rider ID not found in Hive.");
        return;
      }
      log("Rider ID: $riderId");

      final response =
          await Dio().get("/api/rider/pending-deliveries/$riderId");

      if (response.statusCode == 200) {
        log("Response Data: ${response.data}");

        if (response.data is List && response.data.isNotEmpty) {
          String? orderId = response.data[0]['_id'];
          if (orderId != null) {
            await box.put('orderId', orderId); // Store order ID in Hive
            log("✅ Order ID stored in Hive: $orderId");
          } else {
            log("❌ Error: '_id' not found in response.");
          }
        } else {
          log("❌ Error: Unexpected response format or empty list.");
        }
      } else {
        log("❌ Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ storeId Error: $e");
    }
  }
}
