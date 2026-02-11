import 'package:flutter/material.dart';
import 'dart:ui';
import '../config/app_theme.dart';
import '../l10n/language_provider.dart';
import 'home/home_screen_fixed.dart';
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
        children: [
          const HomeScreenFixed(),
          const MapScreenNew(),
          // Only build QR scanner when its tab is active to prevent camera on all pages
          _currentIndex == 2 ? const QrScannerScreenFixed() : const SizedBox.shrink(),
          const SubscriptionsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
          child: SafeArea(
            top: false,
            child: Container(
              height: 64,
              color: Colors.white.withOpacity(0.85),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    svgType: 'home',
                    label: context.tr('nav_home'),
                    index: 0,
                  ),
                  _buildNavItem(
                    svgType: 'map',
                    label: context.tr('nav_map'),
                    index: 1,
                  ),
                  _buildCenterButton(),
                  _buildNavItem(
                    svgType: 'subscription',
                    label: context.tr('profile_subscription'),
                    index: 3,
                  ),
                  _buildNavItem(
                    svgType: 'profile',
                    label: context.tr('nav_profile'),
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String svgType,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    
    IconData icon;
    switch (svgType) {
      case 'home':
        icon = isActive ? Icons.home : Icons.home_outlined;
        break;
      case 'map':
        icon = isActive ? Icons.storefront : Icons.storefront_outlined;
        break;
      case 'subscription':
        icon = isActive ? Icons.qr_code_2 : Icons.qr_code_2_outlined;
        break;
      case 'profile':
        icon = isActive ? Icons.person : Icons.person_outline;
        break;
      default:
        icon = Icons.home_outlined;
    }
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                fontFamily: 'Mulish',
                color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryCyan,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryCyan.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
