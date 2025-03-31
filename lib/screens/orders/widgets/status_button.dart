import 'package:flutter/material.dart';

Widget statusButton(
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
