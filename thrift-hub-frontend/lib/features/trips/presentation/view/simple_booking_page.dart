import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/vapor_colors.dart';

class SimpleBookingPage extends StatefulWidget {
  final Map<String, String> package;

  const SimpleBookingPage({super.key, required this.package});

  @override
  State<SimpleBookingPage> createState() => _SimpleBookingPageState();
}

class _SimpleBookingPageState extends State<SimpleBookingPage> {
  bool _isLoading = false;
  bool _paymentCompleted = false;

  Future<void> _orderAfterPaymentSuccess() async {
    if (_paymentCompleted) return;
    
    setState(() { 
      _isLoading = true;
      _paymentCompleted = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final userEmail = prefs.getString('user_email');
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error: User not logged in'),
            backgroundColor: VaporColors.error,
          ),
        );
        return;
      }
      
      final orderData = {
        'userId': userId,
        'packageId': widget.package['id'] ?? 'test-product',
        'fullName': 'Vapor Vista User',
        'email': userEmail ?? 'user@vaporvista.com',
        'phone': '9800000000',
        'tickets': 1,
        'pickupLocation': 'Vapor Store',
        'paymentMethod': 'credit-card',
      };
      
      print('🔄 Sending order to: ${ApiEndpoints.baseUrl}/bookings');
      print('📦 Order data: $orderData');
      
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(orderData),
      );
      
      print('📊 Response status: ${response.statusCode}');
      print('📊 Response body: ${response.body}');
      
      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('✅ Order placed successfully!'),
                ],
              ),
              backgroundColor: VaporColors.success,
              duration: Duration(seconds: 3),
            ),
          );
          
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context);
        }
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Order error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error: Unable to place order. Please try again.'),
            backgroundColor: VaporColors.error,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _startPayment() async {
    if (_isLoading || _paymentCompleted) return;
    
    setState(() { _isLoading = true; });
    
    try {
      final amt = widget.package['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '1000';
      final productName = widget.package['title'] ?? 'Vape Product';
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Processing payment...'),
            ],
          ),
          backgroundColor: VaporColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
      
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: VaporColors.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      color: VaporColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: VaporColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: VaporColors.success.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transaction Details:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: VaporColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Product: $productName'),
                        Text('Amount: Rs. $amt'),
                        Text('Transaction ID: VV_${DateTime.now().millisecondsSinceEpoch}'),
                        const Text('Status: Completed'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your order is being processed.',
                    style: TextStyle(color: VaporColors.textSecondary),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _orderAfterPaymentSuccess();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VaporColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Error: $e'),
            backgroundColor: VaporColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Product'),
        backgroundColor: VaporColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VaporColors.cloud, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, VaporColors.cloud],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: VaporColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.cloud, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.package['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: VaporColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Premium Vape Product',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: VaporColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: VaporColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: VaporColors.accent.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: VaporColors.textPrimary,
                                ),
                              ),
                              Text(
                                (widget.package['price'] ?? '').replaceAll('/visit', ''),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: VaporColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Center(
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _paymentCompleted 
                          ? [VaporColors.success, VaporColors.success]
                          : [VaporColors.accent, VaporColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: (_paymentCompleted ? VaporColors.success : VaporColors.accent).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: (_isLoading || _paymentCompleted) ? null : _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : _paymentCompleted
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Order Completed',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Purchase Now',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: VaporColors.textSecondary.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, color: VaporColors.success, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Secure payment processing with 256-bit SSL encryption',
                        style: TextStyle(
                          fontSize: 14,
                          color: VaporColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
