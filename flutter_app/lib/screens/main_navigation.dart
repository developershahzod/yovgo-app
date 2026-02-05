import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import 'home/home_screen_new.dart';
import 'map/map_screen_new.dart';
import 'qr/qr_scanner_screen_fixed.dart';
import 'subscriptions/subscriptions_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigation({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreenNew(),
    const MapScreenNew(),
    const QrScannerScreenFixed(),
    const SubscriptionsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Asosiy',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.map_outlined,
                label: 'Xarita',
                index: 1,
              ),
              _buildCenterButton(),
              _buildNavItem(
                icon: Icons.camera_alt_outlined,
                label: 'Obuna',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Profil',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryCyan : AppTheme.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppTheme.primaryCyan : AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    final isActive = _currentIndex == 2;
    
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.primaryCyan,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryCyan.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
