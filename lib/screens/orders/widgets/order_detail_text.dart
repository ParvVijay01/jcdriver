import 'package:flutter/material.dart';

Widget orderDetailText(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(text,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
      );