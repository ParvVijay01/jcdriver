import 'package:flutter/material.dart';
import 'package:jcdriver/screens/auth/onboarding.dart';
import 'package:jcdriver/screens/auth/sign_in.dart';
import 'package:jcdriver/screens/auth/splash_screen.dart';
import 'package:jcdriver/screens/home/home.dart';
import 'package:jcdriver/screens/orders/order_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String home = '/home';
  static const String orderDetails = '/orderScreen'; // Ensure this matches the navigation call

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => Splash());

      case onboarding:
        return MaterialPageRoute(builder: (_) => Onboarding());

      case signIn:
        return MaterialPageRoute(builder: (_) => SignIn());

      case home:
        return MaterialPageRoute(builder: (_) => Home());

      case orderDetails:
        if (settings.arguments != null && settings.arguments is Map<String, dynamic>) {
          final order = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: order),
          );
        }
        return _errorRoute("Invalid order details provided.");

      default:
        return _errorRoute("Page not found!");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(message, style: const TextStyle(fontSize: 18))),
      ),
    );
  }
}
