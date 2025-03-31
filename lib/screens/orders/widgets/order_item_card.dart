import 'package:flutter/material.dart';

Widget orderItemCard(Map<String, dynamic> item) {
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

  Widget _noImagePlaceholder() => Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade300,
      child:
          const Icon(Icons.image_not_supported, size: 40, color: Colors.grey));