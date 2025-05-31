// Updated Dashboard with navigation buttons and functional search
import 'package:flutter/material.dart';
import '../widgets/category_icons.dart';
import '../widgets/product_card.dart';
import '../widgets/banner_slider.dart'; // Make sure to import the BannerSlider
import '../models/vape_model.dart';
import 'wishlist_page.dart';
import 'profile_page.dart';
import 'search_results_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();

  final List<VapeProduct> allProducts = [
    VapeProduct(
      name: "Elf Bar 600",
      price: 14.99,
      image: "assets/images/vape1.png",
      rating: 4.5,
    ),
    VapeProduct(
      name: "Geek Bar Pro",
      price: 12.49,
      image: "assets/images/vape2.jpg",
      rating: 4.2,
    ),
    VapeProduct(
      name: "Puff Bar Max",
      price: 17.99,
      image: "assets/images/vape3.jpg",
      rating: 4.8,
    ),
  ];

  void onSearch(String query) {
    final results = allProducts
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(results: results),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Vapor Vista", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onSubmitted: onSearch,
                decoration: InputDecoration(
                  hintText: "Search vapes...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => onSearch(_searchController.text),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),

              const SizedBox(height: 16),

              // Banner
              const BannerSlider(),

              const SizedBox(height: 16),

              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const CategoryIcons(),

              const SizedBox(height: 16),
              const Text(
                "Flash Sale",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: allProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
