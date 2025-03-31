import 'package:flutter/material.dart';
import 'package:jcdriver/screens/orders/widgets/order_item_card.dart';

Widget orderItems(List<dynamic> cart) {
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
            return orderItemCard(item);
          },
        ),
      ],
    );
  }