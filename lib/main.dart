import 'package:flutter/material.dart';
import 'package:jcdriver/config/app.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/data/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  // Initialize Hive
  await Hive.openBox('appBox');  // Open a Hive box
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
