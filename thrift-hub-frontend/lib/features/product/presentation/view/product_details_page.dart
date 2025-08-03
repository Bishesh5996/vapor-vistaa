import 'package:flutter/material.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../payment/presentation/view/payment_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final dynamic product;
  
  const ProductDetailsPage({super.key, required this.product});

  // Helper method to load images (local or network)
  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: VaporColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.vape_free, size: 100, color: VaporColors.accent),
      );
    }

    // Check if it's a local asset path
    if (imageUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: VaporColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.vape_free, size: 100, color: VaporColors.accent),
            );
          },
        ),
      );
    } else {
      // Network image
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: VaporColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.vape_free, size: 100, color: VaporColors.accent),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = product['price']?.toString() ?? '0.00';
    final rating = product['rating']?.toDouble() ?? 4.0;
    final stock = product['stock']?.toString() ?? '0';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VaporColors.cloud, Colors.white],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: VaporColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  margin: const EdgeInsets.all(20),
                  child: _buildProductImage(product['imageUrl']),
                ),
              ),
            ),
            
            // Product Details
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name and Brand
                      Text(
                        product['name'] ?? 'Unknown Product',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: VaporColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Text(
                            product['brand'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              color: VaporColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: VaporColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$stock in stock',
                              style: const TextStyle(
                                color: VaporColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Rating and Category
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating.floor() ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VaporColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: VaporColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product['category'] ?? 'Vape',
                              style: const TextStyle(
                                color: VaporColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Price
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [VaporColors.accent.withOpacity(0.1), VaporColors.primary.withOpacity(0.1)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 18,
                                color: VaporColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$$price',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: VaporColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: VaporColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        product['description'] ?? 'No description available.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: VaporColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Specifications (if available)
                      if (product['specifications'] != null) ...[
                        const Text(
                          'Specifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: VaporColors.textPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: VaporColors.cloud.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product['specifications']['battery'] != null)
                                _buildSpecRow('Battery', product['specifications']['battery']),
                              if (product['specifications']['wattage'] != null)
                                _buildSpecRow('Wattage', product['specifications']['wattage']),
                              if (product['specifications']['capacity'] != null)
                                _buildSpecRow('Capacity', product['specifications']['capacity']),
                              if (product['specifications']['puffs'] != null)
                                _buildSpecRow('Puffs', product['specifications']['puffs']),
                              if (product['specifications']['nicotine'] != null)
                                _buildSpecRow('Nicotine', product['specifications']['nicotine']),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                      
                      const SizedBox(height: 100), // Space for floating button
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Purchase Button
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(product: product),
              ),
            );
          },
          backgroundColor: VaporColors.accent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.shopping_cart),
          label: Text(
            'Purchase Now - \$$price',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: VaporColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: VaporColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
