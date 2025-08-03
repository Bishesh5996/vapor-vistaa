import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/vapor_colors.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/api_constants.dart';

class PaymentPage extends StatefulWidget {
  final dynamic product;
  
  const PaymentPage({super.key, required this.product});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final StorageService _storage = StorageService();
  String _selectedPaymentMethod = 'CREDIT_CARD';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'CREDIT_CARD',
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'description': 'Visa, MasterCard, American Express'
    },
    {
      'id': 'PAYPAL',
      'name': 'PayPal',
      'icon': Icons.account_balance_wallet,
      'description': 'Pay with your PayPal account'
    },
    {
      'id': 'APPLE_PAY',
      'name': 'Apple Pay',
      'icon': Icons.phone_iphone,
      'description': 'Touch ID or Face ID'
    },
    {
      'id': 'GOOGLE_PAY',
      'name': 'Google Pay',
      'icon': Icons.android,
      'description': 'Pay with Google'
    },
  ];

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      print('🎯 Starting payment process...');
      
      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(VaporColors.accent),
              ),
              SizedBox(height: 16),
              Text('Processing payment...'),
            ],
          ),
        ),
      );

      // Mock payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      print('✅ Payment processed successfully');

      // Get user data
      final userId = await _storage.getUserId();

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Prepare order data with placeholder values
      final orderData = {
        'userId': userId,
        'packageId': widget.product['_id'] ?? widget.product['id'],
        'packageTitle': widget.product['name'],
        'fullName': 'John Doe', // Placeholder - you can get this from login
        'email': 'john@vaporvista.com', // Placeholder
        'phone': '1234567890',
        'pickupLocation': 'Vapor Store',
        'paymentMethod': _selectedPaymentMethod,
        'totalPrice': widget.product['price'],
        'status': 'confirmed'
      };

      print('📤 Sending order data: $orderData');

      // Create order in database
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookingsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      // Close processing dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Order created successfully in database');
        
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: VaporColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: VaporColors.success,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your order for ${widget.product['name']} has been confirmed.',
                  style: const TextStyle(fontSize: 16, color: VaporColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check your orders in the Orders tab!',
                  style: TextStyle(fontSize: 14, color: VaporColors.accent, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to product details
                    Navigator.of(context).pop(); // Go back to products list
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VaporColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('View Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      // Close processing dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      print('❌ Payment error: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: VaporColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product['price']?.toString() ?? '0.00';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: VaporColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VaporColors.cloud, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: VaporColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: VaporColors.accent.withOpacity(0.1),
                            child: widget.product['imageUrl'] != null
                                ? (widget.product['imageUrl'].startsWith('assets/')
                                    ? Image.asset(widget.product['imageUrl'], fit: BoxFit.cover)
                                    : Image.network(widget.product['imageUrl'], fit: BoxFit.cover))
                                : const Icon(Icons.vape_free, color: VaporColors.accent),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product['name'] ?? 'Product',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: VaporColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product['brand'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: VaporColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$$price',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: VaporColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: VaporColors.textPrimary,
                          ),
                        ),
                        Text(
                          '\$$price',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: VaporColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Payment Methods
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: VaporColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: _paymentMethods.map((method) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['id'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPaymentMethod == method['id']
                                ? VaporColors.accent
                                : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedPaymentMethod == method['id']
                                    ? VaporColors.accent.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                method['icon'],
                                color: _selectedPaymentMethod == method['id']
                                    ? VaporColors.accent
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: VaporColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    method['description'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: VaporColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedPaymentMethod == method['id'])
                              const Icon(Icons.check_circle, color: VaporColors.accent),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Security Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VaporColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, color: VaporColors.success),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your payment is secured with SSL encryption',
                        style: TextStyle(
                          fontSize: 14,
                          color: VaporColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Pay Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [VaporColors.accent, VaporColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: VaporColors.accent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Pay \$$price',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
