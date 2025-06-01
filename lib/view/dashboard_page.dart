import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<String> categories = ['Lakes', 'Mountain', 'Forest', 'Sea'];

  final List<Map<String, String>> topTrips = [
    {
      'title': 'Rara Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://i.pinimg.com/736x/86/82/e1/8682e16c492f150bd46e07e421adf5f2.jpg'
    },
    {
      'title': 'Tilicho Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://i.pinimg.com/736x/6e/75/54/6e7554806054be9939fd9ee89c632e21.jpg'
    },
    {
      'title': 'Shey-Phoksundo Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://i.pinimg.com/736x/eb/01/e5/eb01e564d2fc2b5c4c64ef7da9f1480b.jpg'
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.black),
            SizedBox(width: 4),
            Text("Kathmandu, Nepal", style: TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications, color: Colors.black),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 10),
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
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
                  color: Colors.redAccent,
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
                    color: const Color(0xFFE1F0F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(categories[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Top Trips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Top Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
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
                                Text(trip['price']!, style: const TextStyle(color: Colors.redAccent)),
                                const Icon(Icons.favorite_border, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Group Trips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Group Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("See All", style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://i.pinimg.com/736x/c5/dc/56/c5dc5678534a672c91d9d70ea1cf0014.jpg',
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
                      const Text("Mountain Trip", style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text("Mount Everest Base Camp"),
                      const Text("Nepal"),
                      const SizedBox(height: 6),
                      const LinearProgressIndicator(
                        value: 0.8,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
