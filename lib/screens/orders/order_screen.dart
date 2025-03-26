import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/constants.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Dio _dio = Dio();
  final String _baseUrl = "$MAIN_URL/api/rider/update-delevery/";

  bool _isLoading = false;

  Future<void> _updateOrderStatus(String newStatus) async {
    setState(() => _isLoading = true);

    try {
      int orderId = widget.order['orderId'];
      String id = widget.order['_id'];
      String url = "$_baseUrl$orderId/$id/$newStatus";

      log("Updating status to: $newStatus");
      log("API URL: $url");

      Response response = await _dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        setState(() => widget.order['order']['status'] = newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated to $newStatus")),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      } else {
        throw Exception("Failed to update status");
      }
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderInfo = widget.order['order'] ?? {};
    final userInfo = orderInfo['user_info'] ?? {};
    final List<dynamic> cart = orderInfo['cart'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                orderDetailText(
                    "Order ID: ${widget.order['orderId'] ?? 'N/A'}"),
                orderDetailText("Total Amount: ₹${orderInfo['total'] ?? 0}"),
                orderDetailText("Address: ${userInfo['address'] ?? 'N/A'}"),
                orderDetailText("Pincode: ${userInfo['zipCode'] ?? 'N/A'}"),
                orderDetailText("City: ${userInfo['city'] ?? 'N/A'}"),
                const SizedBox(height: 20),

                // Status Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    statusButton(() => _updateOrderStatus("false"), "Cancelled",
                        Colors.red),
                    statusButton(() => _updateOrderStatus("true"), "Delivered",
                        Colors.green),
                  ],
                ),
                const SizedBox(height: 20),

                const Text("Items:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Cart List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    final String title = item['title'] ?? 'Unknown Item';
                    final dynamic images = item['image'];

                    List<String> imageList = (images is List)
                        ? images.cast<String>()
                        : (images is String ? [images] : []);

                    String? imageUrl =
                        imageList.isNotEmpty ? imageList.first : null;

                    final double price = (item['price'] ?? 0).toDouble();
                    final int quantity = item['quantity'] ?? 1;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      noImagePlaceholder(),
                                )
                              : noImagePlaceholder(),
                        ),
                        title: Text(title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("₹$price x $quantity"),
                        trailing: Text(
                          "Total: ₹${price * quantity}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const Center(
                child: CircularProgressIndicator(
              color: IKColors.primary,
            )),
        ],
      ),
    );
  }
}

// ✅ Helper Widget for Order Details Text
Widget orderDetailText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
    ),
  );
}

// ✅ Status Button with Improved UI
Widget statusButton(VoidCallback? onPressed, String text, Color color) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    child: Text(text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

// ✅ Placeholder for missing images
Widget noImagePlaceholder() {
  return Container(
    width: 60,
    height: 60,
    color: Colors.grey.shade300,
    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
  );
}
