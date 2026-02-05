import 'package:flutter/material.dart';
import 'dart:ui';
import '../config/app_theme.dart';
import '../l10n/language_provider.dart';
import 'home/home_screen_new.dart';
import 'map/map_screen_new.dart';
import 'qr/qr_scanner_screen_fixed.dart';
import 'subscriptions/subscriptions_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationFixed extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationFixed({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigationFixed> createState() => _MainNavigationFixedState();
}

class _MainNavigationFixedState extends State<MainNavigationFixed> {
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blurred background container
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.white.withOpacity(0.75),
                child: Column(
                  children: [
                    // Menu items
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home,
                              label: context.tr('nav_home'),
                              index: 0,
                            ),
                            _buildNavItem(
                              icon: Icons.map_outlined,
                              activeIcon: Icons.map,
                              label: context.tr('nav_map'),
                              index: 1,
                            ),
                            const SizedBox(width: 64), // Space for center button
                            _buildNavItem(
                              icon: Icons.credit_card_outlined,
                              activeIcon: Icons.credit_card,
                              label: context.tr('sub_title'),
                              index: 3,
                            ),
                            _buildNavItem(
                              icon: Icons.person_outline,
                              activeIcon: Icons.person,
                              label: context.tr('nav_profile'),
                              index: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Home indicator bar
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      child: Container(
                        width: 134,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Center QR button - positioned slightly above menu
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: _buildCenterButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with background when active
          Container(
            width: 30,
            height: 30,
            decoration: isActive ? BoxDecoration(
              color: AppTheme.primaryCyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ) : null,
            child: Icon(
              icon,
              color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
              color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
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
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryCyan.withOpacity(0.2),
              ),
            ),
            // Middle circle
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryCyan.withOpacity(0.99),
              ),
            ),
            // Inner circle with icon
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppTheme.primaryCyan,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
