import 'package:flutter/material.dart';
import '../../../trips/presentation/view/trip_detail_page.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  final List<String> categories = const ['Vape Kits', 'E-Liquids', 'Pods', 'Disposables'];

  final List<Map<String, String>> topTrips = const [
    {
      'title': 'SMOK Nord 4 Kit',
      'location': 'Starter Kit',
      'price': '\$29.99',
      'rating': '4.8',
      'image': 'https://www.vaporesso.com/hubfs/SMOK-Nord-4.jpg',
      'description': 'A versatile pod system with adjustable wattage and long battery life. Perfect for beginners and pros.'
    },
    {
      'title': 'GeekVape Aegis X',
      'location': 'Advanced Mod',
      'price': '\$49.99',
      'rating': '4.7',
      'image': 'https://www.vaporesso.com/hubfs/GeekVape-Aegis-X.jpg',
      'description': 'A powerful, durable mod with a large display and customizable settings for advanced vapers.'
    },
    {
      'title': 'JUUL Device',
      'location': 'Pod System',
      'price': '\$24.99',
      'rating': '4.5',
      'image': 'https://www.vaporesso.com/hubfs/JUUL-Device.jpg',
      'description': 'The classic, ultra-portable pod vape. Sleek, simple, and satisfying.'
    },
    {
      'title': 'Elf Bar BC5000',
      'location': 'Disposable',
      'price': '\$15.99',
      'rating': '4.6',
      'image': 'https://www.vaporesso.com/hubfs/Elf-Bar-BC5000.jpg',
      'description': 'A high-capacity disposable vape with great flavors and long-lasting battery.'
    },
    {
      'title': 'Naked 100 E-Liquid',
      'location': 'E-Liquid',
      'price': '\$12.99',
      'rating': '4.9',
      'image': 'https://www.vaporesso.com/hubfs/Naked-100-E-Liquid.jpg',
      'description': 'Premium e-liquid with a variety of delicious flavors for every palate.'
    },
  ];

  final List<Map<String, String>> featuredPackages = const [
    {
      'title': 'Vaporesso Luxe PM40',
      'location': 'Pod Mod',
      'duration': 'New Arrival',
      'image': 'https://www.vaporesso.com/hubfs/Vaporesso-Luxe-PM40.jpg',
    },
    {
      'title': 'Voopoo Drag X Plus',
      'location': 'Advanced Mod',
      'duration': 'Best Seller',
      'image': 'https://www.vaporesso.com/hubfs/Voopoo-Drag-X-Plus.jpg',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for vapes, e-liquids, or accessories',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF26E5A6),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.tune, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 20),
        // Categories
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C47FF).withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(categories[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Top Products
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Top Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("See All", style: TextStyle(color: Colors.redAccent)),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topTrips.length,
            itemBuilder: (context, index) {
              var trip = topTrips[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailPage(trip: trip),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(trip['image']!, height: 120, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trip['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(trip['location']!, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$${trip['price']!}', style: const TextStyle(color: Colors.redAccent)),
                                const Icon(Icons.favorite_border, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Featured Products
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Featured Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("See All", style: TextStyle(color: Colors.redAccent)),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: featuredPackages.length,
          itemBuilder: (context, index) {
            var package = featuredPackages[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        package['image']!,
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(package['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(package['location']!, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 5),
                          Text(package['duration']!, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
} 