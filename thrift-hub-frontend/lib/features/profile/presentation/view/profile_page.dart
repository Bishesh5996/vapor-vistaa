import 'package:flutter/material.dart';
import '../../../../core/theme/vapor_colors.dart';
import '../../../../core/storage/storage_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StorageService _storage = StorageService();

  Future<void> _logout() async {
    await _storage.clearAll();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [VaporColors.accent, VaporColors.primary]),
                  boxShadow: [
                    BoxShadow(
                      color: VaporColors.accent.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VaporColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Thrift HUB Premium User', style: TextStyle(fontSize: 16, color: VaporColors.textSecondary)),
              const SizedBox(height: 40),
              
              _buildProfileOption(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: _navigateToEditProfile,
              ),
              
              _buildProfileOption(
                icon: Icons.shopping_bag_outlined,
                title: 'Order History',
                subtitle: 'View your previous orders',
                onTap: () {
                  // Navigate to orders tab
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              
              _buildProfileOption(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your notifications',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications settings coming soon!')));
                },
              ),
              
              _buildProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help & Support coming soon!')));
                },
              ),
              
              _buildProfileOption(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'Manage your account security',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy settings coming soon!')));
                },
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VaporColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 24),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: VaporColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: VaporColors.accent, size: 24),
          ),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: VaporColors.textPrimary)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: VaporColors.textSecondary)),
          trailing: const Icon(Icons.arrow_forward_ios, color: VaporColors.textSecondary, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
