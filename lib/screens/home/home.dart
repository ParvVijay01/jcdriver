import 'package:flutter/material.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/data/providers/order_provider.dart';
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
    final userProvider = Provider.of<DriverProvider>(context, listen: false);

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
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          final orders = orderProvider.orders;

          if (orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // ✅ Handling potential null values
              final String orderId = (order['orderId'] ?? 'N/A').toString();
              final String modeOfPayment =
                  order['order']?['paymentMethod'] ?? 'Unknown';
              final double totalAmount =
                  (order['order']?['total'] ?? 0).toDouble();
              final Map<String, dynamic> userInfo =
                  order['order']?['user_info'] ?? {};
              final String customerName =
                  (userInfo['name'] ?? 'N/A').toString();
              final String customerContact =
                  (userInfo['contact'] ?? 'N/A').toString();
              final List<dynamic> cart = order['order']?['cart'] ?? [];
              final String productTitle = cart.isNotEmpty
                  ? (cart[0]['title'] ?? 'No Product').toString()
                  : 'No Product';

              final String productImage = cart.isNotEmpty &&
                      cart[0]['image'] != null &&
                      cart[0]['image'].isNotEmpty
                  ? cart[0]['image'][0]
                  : 'https://via.placeholder.com/150'; // Default placeholder

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImage,
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  title: Text(
                    "Order #$orderId",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: $customerName",
                          style: const TextStyle(fontSize: 14)),
                      Text("Contact: $customerContact",
                          style: const TextStyle(fontSize: 14)),
                      Text("Total: ₹$totalAmount",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text("Mode of Payment: $modeOfPayment",
                          style: const TextStyle(fontSize: 14)),
                      Text("Product: $productTitle",
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () async {
                    bool? updated = await Navigator.pushNamed(
                      context,
                      '/orderScreen',
                      arguments: order,
                    ) as bool?;

                    if (updated == true && mounted) {
                      Provider.of<OrderProvider>(context, listen: false)
                          .fetchOrders(); // Refresh orders on return
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
