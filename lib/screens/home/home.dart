import 'package:flutter/material.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/data/providers/order_provider.dart';
import 'package:jcdriver/routes/router.dart'; // In case you're using named routes.
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<DriverProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                userProvider.logout();
                Navigator.pushReplacementNamed(context, '/signin');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: orderProvider.orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final userInfo = order['order']?['user_info'] ?? {};
                final cart = order['order']?['cart'] ?? [];
                final productTitle = cart.isNotEmpty
                    ? cart[0]['title'] ?? 'No Product'
                    : 'No Product';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      cart.isNotEmpty &&
                              cart[0]['image'] != null &&
                              cart[0]['image'].isNotEmpty
                          ? cart[0]['image'][0]
                          : 'https://via.placeholder.com/150', // Placeholder for missing images
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    title: Text("Order #${order['orderId'] ?? 'N/A'}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: ${userInfo['name'] ?? 'N/A'}"),
                        Text("Total: ₹${order['order']['total'] ?? '0'}"),
                        Text("Product: $productTitle"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Optional: Add navigation to order details
                      Navigator.pushNamed(context, '/orderDetails',
                          arguments: order);
                    },
                  ),
                );
              },
            ),
    );
  }
}
