import 'package:flutter/material.dart';
import '../models/vape_model.dart';
import '../widgets/product_card.dart';

class SearchResultsPage extends StatelessWidget {
  final List<VapeProduct> results;

  const SearchResultsPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Results")),
      body: results.isEmpty
          ? const Center(child: Text("No products found."))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: results[index]),
            ),
    );
  }
}
