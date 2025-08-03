import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../product/presentation/view/product_details_page.dart';

class SimpleHomeContent extends StatefulWidget {
  const SimpleHomeContent({super.key});

  @override
  State<SimpleHomeContent> createState() => _SimpleHomeContentState();
}

class _SimpleHomeContentState extends State<SimpleHomeContent> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final dio = Dio();
      final response = await dio.get('${ApiConstants.baseUrl}/products/featured/list');

      if (response.statusCode == 200) {
        setState(() {
          _products = response.data ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load products';
        _isLoading = false;
      });
    }
  }

  // Helper method to load images (local or network)
  Widget _buildProductImage(String? imageUrl, String productName) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: VaporColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.vape_free, size: 40, color: VaporColors.accent),
      );
    }

    // Check if it's a local asset path
    if (imageUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: VaporColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.vape_free, size: 40, color: VaporColors.accent),
            );
          },
        ),
      );
    } else {
      // Network image
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: VaporColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.vape_free, size: 40, color: VaporColors.accent),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Loading premium products...', style: TextStyle(color: VaporColors.textSecondary, fontSize: 16)),
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
            Text(_error, style: const TextStyle(color: VaporColors.error, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              style: ElevatedButton.styleFrom(backgroundColor: VaporColors.accent, foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
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
            const Text('No products available', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VaporColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Check back soon for new arrivals!', style: TextStyle(fontSize: 16, color: VaporColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Premium thrift Products',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: VaporColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover our curated collection',
              style: TextStyle(fontSize: 16, color: VaporColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final price = product['price']?.toString() ?? '0.00';
    final rating = product['rating']?.toDouble() ?? 4.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, VaporColors.cloud.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: VaporColors.accent.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: SizedBox(
                  width: double.infinity,
                  child: _buildProductImage(product['imageUrl'], product['name'] ?? ''),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Product Name
              Text(
                product['name'] ?? 'Unknown Product',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: VaporColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Brand
              Text(
                product['brand'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: VaporColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Rating
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12, color: VaporColors.textSecondary),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Price
              Text(
                '\$$price',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: VaporColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 