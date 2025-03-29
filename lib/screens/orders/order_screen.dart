import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      log("🔄 Updating order...");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('orderId');

      log("🔍 Stored User ID: $id"); // Debugging log

      if (id == null) {
        log("❌ User ID is null. Cannot update order.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: User ID is missing. Please log in again.")),
        );
        return;
      }

      int orderId = widget.order['invoice'];
      String url = "$_baseUrl$orderId/$id/$newStatus";
      log("🌐 API URL: $url");

      Response response = await _dio.get(url,
          options: Options(headers: {"Content-Type": "application/json"}));

      log("✅ Response Data: ${response.data}");

      if (response.statusCode == 200) {
        setState(() => widget.order['status'] = newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated to $newStatus")),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      } else {
        log("❌ Unexpected Response: ${response.statusCode} - ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error updating status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      log("🚨 Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while updating status.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.order['user_info'] ?? {};
    final List<dynamic> cart = widget.order['cart'] ?? [];
    final double screenWidth = MediaQuery.of(context).size.width;
    print("userinfo ---> $userInfo");
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
                      _orderDetailText(
                          "🆔 Order ID: ${widget.order['invoice'] ?? 'N/A'}"),
                      _orderDetailText(
                          "💰 Total Amount: ₹${widget.order['total'] ?? 0}"),
                      _orderDetailText(
                          "📍 Address: ${userInfo['address'] ?? 'N/A'}"),
                      _orderDetailText(
                          "📮 Pincode: ${userInfo['zipCode'] ?? 'N/A'}"),
                      _orderDetailText("🏙 City: ${userInfo['city'] ?? 'N/A'}"),
                    ],
                  ),
                ),
                _statusAndActions(),
                _orderItems(cart),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
                child: CircularProgressIndicator(color: IKColors.primary)),
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
                        FaIcon(FontAwesomeIcons.circleUp),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Update order status",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : const Text(
                      "📦 Order Status",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
              const SizedBox(height: 10),
              widget.order['status'] == 'Processing'
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _statusButton(
                                  "Cancel Order",
                                  Colors.red,
                                  Icons.close,
                                  () => _updateOrderStatus("false")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _statusButton(
                                  "Mark Delivered",
                                  Colors.green,
                                  Icons.check,
                                  () => _updateOrderStatus("true")),
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
                                log("User Info Location: ${userInfo['location']}");
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
                    ) //,
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _orderDetailText(
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

  Widget _statusButton(
      String text, Color color, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _orderItems(List<dynamic> cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Items:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cart.length,
          itemBuilder: (context, index) {
            final item = cart[index];
            return _orderItemCard(item);
          },
        ),
      ],
    );
  }

  Widget _orderItemCard(Map<String, dynamic> item) {
    final String title = item['title'] ?? 'Unknown Item';
    final List<String> images = (item['image'] is List)
        ? List<String>.from(item['image'])
        : [item['image'] ?? ''];
    final double price = (item['price'] ?? 0).toDouble();
    final int quantity = item['quantity'] ?? 1;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: images.isNotEmpty && images.first.isNotEmpty
              ? Image.network(images.first,
                  width: 60, height: 60, fit: BoxFit.cover)
              : _noImagePlaceholder(),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("₹$price x $quantity"),
        trailing: Text("Total: ₹${price * quantity}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _orderDetailText(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(text,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
      );

  Widget _noImagePlaceholder() => Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade300,
      child:
          const Icon(Icons.image_not_supported, size: 40, color: Colors.grey));
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

void openGoogleMaps({
  required String? url,
}) async {
  String googleMapsUrl;

  if (url != null) {
    // Case 1: Open the direct Google Maps link from backend
    googleMapsUrl = url;
  } else {
    // Invalid case

    return;
  }

  Uri uri = Uri.parse(googleMapsUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print("Could not launch Google Maps");
  }
}
