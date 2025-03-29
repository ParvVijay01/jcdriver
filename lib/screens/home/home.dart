import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/data/providers/order_provider.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<String> _statuses = ["Processing", "Delivered", "Cancelled"];
  Timer? _timer;
  OrderProvider? orderProvider;

  @override
  void initState() {
    super.initState();

    // Delay order fetching after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrdersAndCheck();
    });

    // Auto-refresh orders every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) _fetchOrdersAndCheck();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orderProvider ??= Provider.of<OrderProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  void showTopSnackBar(BuildContext context, String message) {
    if (!mounted) return;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: IKColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 5), () {
      if (mounted) overlayEntry.remove();
    });
  }

  void _fetchOrdersAndCheck() async {
    if (orderProvider == null) return;

    int previousOrderCount = orderProvider!.orders.length;

    await orderProvider!.fetchOrders(); // Fetch new orders

    int newOrderCount = orderProvider!.orders.length;

    if (newOrderCount > previousOrderCount && mounted) {
      // Delay UI update until after the build phase
      Future.delayed(Duration.zero, () {
        if (mounted) showTopSnackBar(context, "New orders assigned");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<DriverProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context);

    int totalOrders = orderProvider.orders.length;
    int processingOrders = orderProvider.ordersByStatus("Processing").length;
    int deliveredOrders = orderProvider.ordersByStatus("Delivered").length;
    int cancelledOrders = orderProvider.ordersByStatus("Cancelled").length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              userProvider.logout();
              Navigator.pushReplacementNamed(context, '/signin');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: _fetchOrdersAndCheck, // Manual refresh button
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Chips
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_statuses.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(
                      _statuses[index],
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    showCheckmark: false,
                    selected: _selectedIndex == index,
                    selectedColor: index == 0
                        ? Colors.amber
                        : index == 1
                            ? Colors.green
                            : Colors.red,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),

          // Summary Card
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryItem(
                      Icons.list, "Total", totalOrders, Colors.blue),
                  _buildSummaryItem(Icons.hourglass_bottom, "Processing",
                      processingOrders, Colors.orange),
                  _buildSummaryItem(Icons.check_circle, "Delivered",
                      deliveredOrders, Colors.green),
                  _buildSummaryItem(
                      Icons.cancel, "Cancelled", cancelledOrders, Colors.red),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> orders =
                    provider.ordersByStatus(_statuses[_selectedIndex]);

                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      "No ${_statuses[_selectedIndex]} orders",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final int orderId = order['invoice'] ?? 'N/A';
                    final String modeOfPayment =
                        order['paymentMethod'] ?? 'Unknown';
                    final double totalAmount = (order['total'] ?? 0).toDouble();
                    final String customerName =
                        order['user_info']?['name'] ?? 'N/A';
                    final String customerContact =
                        order['user_info']?['contact'] ?? 'N/A';

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text("Order #$orderId",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Customer: $customerName"),
                            Text("Contact: $customerContact"),
                            Text("Total: ₹$totalAmount"),
                            Text("Mode of Payment: $modeOfPayment"),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.pushNamed(context, '/orderScreen',
                              arguments: order);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSummaryItem(IconData icon, String label, int count, Color color) {
  return Column(
    children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(height: 4),
      Text("$count",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}
