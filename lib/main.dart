import 'package:flutter/material.dart';
import 'package:jcdriver/config/app.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/data/providers/order_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DriverProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const App(),
    ),
  );
}
