import 'package:flutter/material.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../payment/presentation/view/payment_page.dart';

class TripDetailPage extends StatefulWidget {
  final Map<String, dynamic> trip;
  const TripDetailPage({super.key, required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(product: widget.trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VaporColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Product Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.trip['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: VaporColors.cloud,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud, size: 80, color: VaporColors.accent),
                          Text('VAPOR VISTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VaporColors.accent)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip['title'] ?? 'Unknown Product',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VaporColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(widget.trip['rating'] ?? '4.5', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: VaporColors.textPrimary)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: VaporColors.accent, size: 20),
                      const SizedBox(width: 4),
                      Text(widget.trip['location'] ?? 'Vapor Store', style: const TextStyle(fontSize: 16, color: VaporColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: VaporColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.trip['price'] ?? '\$0.00',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: VaporColors.accent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: VaporColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    widget.trip['description'] ?? 'Premium vape product with excellent quality and performance.',
                    style: const TextStyle(fontSize: 16, height: 1.5, color: VaporColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VaporColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 24),
                          SizedBox(width: 8),
                          Text('Purchase Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
