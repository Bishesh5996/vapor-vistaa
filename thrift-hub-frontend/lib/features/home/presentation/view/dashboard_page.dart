import 'package:flutter/material.dart';
import '../../../booking/presentation/view/bookings_page.dart';
import 'simple_home_content.dart';
import '../../../profile/presentation/view/profile_page.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../../core/sensors/sensor_service.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final SensorService _sensorService = SensorService();
  String _lastTiltDirection = 'none';

  final List<Widget> _pages = [
    const SimpleHomeContent(),
    const BookingsPage(),
    const ProfilePage(),
  ];

  final List<String> _tabNames = ['Products', 'Orders', 'Account'];
  final List<IconData> _tabIcons = [Icons.home, Icons.shopping_bag, Icons.person];

  @override
  void initState() {
    super.initState();
    _initializeSensors();
  }

  void _initializeSensors() {
    _sensorService.initializeTabNavigation((direction) {
      _handleTabNavigation(direction);
    });

    _sensorService.initializeShakeDetector(() {
      _handleShakeRefresh();
    });
  }

  void _handleTabNavigation(String direction) {
    if (direction == _lastTiltDirection) return; // Prevent rapid switching
    
    setState(() {
      _lastTiltDirection = direction;
    });

    int newIndex = _selectedIndex;
    String actionText = '';

    if (direction == 'right') {
      newIndex = (_selectedIndex + 1) % 3;
      actionText = 'Tilted right → ${_tabNames[newIndex]}';
    } else if (direction == 'left') {
      newIndex = (_selectedIndex - 1 + 3) % 3;
      actionText = 'Tilted left → ${_tabNames[newIndex]}';
    }

    if (newIndex != _selectedIndex) {
      HapticFeedback.lightImpact();

      setState(() {
        _selectedIndex = newIndex;
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(_tabIcons[newIndex], color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '📱 $actionText',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: VaporColors.accent,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _lastTiltDirection = 'none';
      });
    });
  }

  void _handleShakeRefresh() {
    HapticFeedback.mediumImpact();

    String currentTab = _tabNames[_selectedIndex];
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.refresh, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              '📱 Shake detected → Refreshing tab',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: VaporColors.success,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // You can add specific refresh logic for each tab here if needed
    // For example, call a refresh method on SimpleHomeContent if selectedIndex == 0
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: VaporColors.primary,
              elevation: 4,
              title: const Row(
                children: [
                  Icon(Icons.location_on_outlined, color: VaporColors.vapor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Kathmandu, Nepal", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: VaporColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
              ],
            )
          : AppBar(
              backgroundColor: VaporColors.primary,
              elevation: 4,
              title: Text(
                _selectedIndex == 1 ? 'My Orders' : 'Account',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              VaporColors.cloud,
              Colors.white,
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: VaporColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: VaporColors.accent,
          unselectedItemColor: VaporColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
