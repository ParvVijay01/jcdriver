// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/constants.dart';
import 'package:jcdriver/screens/orders/widgets/google_map.dart';
import 'package:jcdriver/screens/orders/widgets/order_detail_text.dart';
import 'package:jcdriver/screens/orders/widgets/order_items.dart';
import 'package:jcdriver/screens/orders/widgets/status_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final String _baseUrl = "$MAIN_URL/api/rider/update-delevery/";
  bool _isLoading = false;

  Future<void> _updateOrderStatus(BuildContext context,
      Map<String, dynamic> order, String newStatus) async {
    setState(() {
      _isLoading = true;
    });
    try {
      log("🛠 Updating Order Status...");
      var box = Hive.box('appBox');

      await Future.delayed(const Duration(milliseconds: 500));

      String? id = box.get('orderId');

      if (id == null) {
        log("❌ Error: Order ID not found in Hive.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Order ID not found. Please try again.")),
        );
        return;
      }

      int orderId = order['invoice'];
      String url = "$_baseUrl$orderId/$id/$newStatus";

      log("📦 Order ID from Hive: $id");
      log("🔗 API URL: $url");

      Response response = await Dio().get(url,
          options: Options(headers: {"Content-Type": "application/json"}));

      if (response.statusCode == 200) {
        order['status'] = newStatus;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus == "true"
                ? "✅ Order status updated to Delivered"
                : "❌ Order status updated to Cancelled"),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context, true);
          
        }
        
      } else {
        throw Exception("❌ Failed to update status");
      }
    } catch (e) {
      log("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.order['user_info'] ?? {};
    final List<dynamic> cart = widget.order['cart'] ?? [];
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth < 600 ? screenWidth * 0.9 : 500,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: IKColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: IKColors.primary, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderDetailText(
                          "🆔 Order ID: ${widget.order['invoice'] ?? 'N/A'}"),
                      orderDetailText(
                          "💰 Total Amount: ₹${widget.order['total'] ?? 0}"),
                      orderDetailText(
                          "📍 Address: ${userInfo['address'] ?? 'N/A'}"),
                      orderDetailText(
                          "📮 Pincode: ${userInfo['zipCode'] ?? 'N/A'}"),
                      orderDetailText("🏙 City: ${userInfo['city'] ?? 'N/A'}"),
                    ],
                  ),
                ),
                _statusAndActions(),
                orderItems(cart),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: IKColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusAndActions() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final userInfo = widget.order['user_info'] ?? {};

    return SizedBox(
      width: screenWidth < 600 ? screenWidth * 0.9 : 500,
      child: Card(
        elevation: 4,
        color: widget.order['status'] == 'Processing'
            ? const Color.fromARGB(255, 247, 236, 139)
            : widget.order['status'] == 'Delivered'
                ? const Color.fromARGB(125, 0, 255, 8)
                : const Color.fromARGB(255, 255, 150, 148),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: IKColors.primary, width: 1)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.order['status'] == 'Processing'
                  ? Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.circleUp),
                        const SizedBox(width: 5),
                        const Text(
                          "Update order status",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : const Text(
                      "📦 Order Status",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
              const SizedBox(height: 10),
              widget.order['status'] == 'Processing'
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: statusButton(
                                  "Cancel Order",
                                  Colors.red,
                                  Icons.close,
                                  () => _updateOrderStatus(
                                      context, widget.order, "false")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: statusButton(
                                  "Mark Delivered", Colors.green, Icons.check,
                                  () async {
                                await storeId();
                                _updateOrderStatus(
                                    context, widget.order, "true");
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (userInfo.containsKey('location') &&
                                  userInfo['location'] != null) {
                                openGoogleMaps(url: userInfo['location']);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Location not available")),
                                );
                              }
                            },
                            icon: const Icon(Icons.location_on,
                                color: Colors.white),
                            label: const Text("View on Map"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderDetailText(
                            "Current Status: ${widget.order['status']}"),
                        _dateText(
                            widget.order['status'], widget.order['updatedAt'])
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> storeId() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var box = Hive.box('appBox'); // Open Hive box
    String? riderId = prefs.getString('riderId'); // Retrieve riderId

    if (riderId == null) {
      log("❌ Rider ID not found");
      return;
    }

    final response =
        await Dio().get("$MAIN_URL/api/rider/pending-deliveries/$riderId");

    if (response.statusCode == 200) {
      log("📦 Full Response Data: ${response.data}");

      if (response.data is List && response.data.isNotEmpty) {
        String? orderId = response.data[0]['_id'];
        log("🔍 Extracted Order ID: $orderId");

        if (orderId != null) {
          await box.put('orderId', orderId);
          log("✅ Order ID stored successfully in Hive.");
        } else {
          log("❌ '_id' field not found in response.");
        }
      } else {
        log("⚠️ API response format is incorrect or empty.");
      }
    } else {
      log("❌ Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    log("❌ storeId Error: $e");
  }
}

Widget _dateText(String status, String updatedAt) {
  // Parse the timestamp from backend
  DateTime dateTime =
      DateTime.parse(updatedAt).toLocal(); // Convert to local time

  // Format the date
  String formattedDate = DateFormat("dd/MM/yy 'at' hh:mm a").format(dateTime);

  // Determine text based on order status
  String displayText = status == "Delivered"
      ? "Delivered on $formattedDate"
      : status == "Cancelled"
          ? "Cancelled on $formattedDate"
          : "";

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      displayText,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );
}
