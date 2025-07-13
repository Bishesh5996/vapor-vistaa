import 'package:flutter/material.dart';
import '../../../booking/presentation/view/bookings_page.dart';
import 'home_content.dart';
import '../../../profile/presentation/view/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const BookingsPage(),
    const ProfilePage(),
  ];

  final List<String> categories = ['Vape Kits', 'E-Liquids', 'Pods', 'Disposables'];

  final List<Map<String, String>> topTrips = [
    {
      'title': 'SMOK Nord 4 Kit',
      'location': 'Starter Kit',
      'price': '\$29.99',
      'rating': '4.8',
      'image': 'https://www.vaporesso.com/hubfs/SMOK-Nord-4.jpg',
    },
    {
      'title': 'GeekVape Aegis X',
      'location': 'Advanced Mod',
      'price': '\$49.99',
      'rating': '4.7',
      'image': 'https://www.vaporesso.com/hubfs/GeekVape-Aegis-X.jpg',
    },
    {
      'title': 'JUUL Device',
      'location': 'Pod System',
      'price': '\$24.99',
      'rating': '4.5',
      'image': 'https://www.vaporesso.com/hubfs/JUUL-Device.jpg',
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
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Color(0xFF6C47FF),
              elevation: 0,
              title: const Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white),
                  SizedBox(width: 4),
                  Text("Kathmandu, Nepal", style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF26E5A6),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
