import 'package:flutter/material.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../../core/storage/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/api_constants.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with AutomaticKeepAliveClientMixin {
  final StorageService _storage = StorageService();
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _error = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      print('📦 Loading orders...');
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final userId = await _storage.getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      print('👤 Loading orders for user: $userId');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/bookings/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('📥 Orders response status: ${response.statusCode}');
      print('📥 Orders response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _orders = data['data'] ?? [];
          _isLoading = false;
        });
        print('✅ Loaded ${_orders.length} orders');
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading orders: $e');
      setState(() {
        _error = 'Failed to load orders: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VaporColors.cloud, Colors.white],
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(VaporColors.accent)),
            SizedBox(height: 16),
            Text('Loading your orders...', style: TextStyle(color: VaporColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: VaporColors.error),
            const SizedBox(height: 16),
            Text(_error, style: const TextStyle(color: VaporColors.error, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              style: ElevatedButton.styleFrom(backgroundColor: VaporColors.accent, foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: VaporColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 60, color: VaporColors.accent),
            ),
            const SizedBox(height: 24),
            const Text('No orders yet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VaporColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Start shopping for premium vape products!', style: TextStyle(fontSize: 16, color: VaporColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to products tab
                print('🔄 Navigate to products tab');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VaporColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Browse Products'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final totalPrice = order['totalPrice']?.toString() ?? '0.00';
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, VaporColors.cloud.withOpacity(0.3)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: VaporColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_bag, color: VaporColors.accent, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['packageTitle'] ?? 'Unknown Product',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VaporColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Order #${order['_id']?.toString().substring(0, 8) ?? 'N/A'}',
                                style: const TextStyle(fontSize: 12, color: VaporColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: VaporColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: VaporColors.success.withOpacity(0.3)),
                          ),
                          child: Text(
                            order['status']?.toString().toUpperCase() ?? 'CONFIRMED',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: VaporColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Payment Method', style: TextStyle(fontSize: 12, color: VaporColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              order['paymentMethod']?.toString().replaceAll('-', ' ').toUpperCase() ?? 'CREDIT CARD',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: VaporColors.textPrimary),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date', style: TextStyle(fontSize: 12, color: VaporColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(order['createdAt']),
                              style: const TextStyle(fontSize: 14, color: VaporColors.textPrimary),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 12, color: VaporColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              '\$$totalPrice',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VaporColors.accent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }
}
