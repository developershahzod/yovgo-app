import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import 'home/home_screen_fixed.dart';
import 'map/map_screen_new.dart';
import 'qr/qr_scanner_screen_pixel_perfect.dart';
import 'subscriptions/subscription_screen_pixel_perfect.dart';
import 'profile/profile_screen_pixel_perfect.dart';

class MainNavigationPixelPerfect extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationPixelPerfect({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigationPixelPerfect> createState() => _MainNavigationPixelPerfectState();
}

class _MainNavigationPixelPerfectState extends State<MainNavigationPixelPerfect> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreenFixed(),
    const MapScreenNew(),
    const QrScannerScreenPixelPerfect(),
    const SubscriptionScreenPixelPerfect(),
    const ProfileScreenPixelPerfect(),
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
        color: AppTheme.white.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.85),
            BlendMode.srcOver,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Menu items
                SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildNavItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: 'Asosiy',
                          index: 0,
                        ),
                        _buildNavItem(
                          icon: Icons.map_outlined,
                          activeIcon: Icons.map,
                          label: 'Xarita',
                          index: 1,
                        ),
                        _buildCenterButton(),
                        _buildNavItem(
                          icon: Icons.card_membership_outlined,
                          activeIcon: Icons.card_membership,
                          label: 'Obuna',
                          index: 3,
                        ),
                        _buildNavItem(
                          icon: Icons.person_outline,
                          activeIcon: Icons.person,
                          label: 'Profil',
                          index: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Home indicator bar
                Container(
                  height: 34,
                  alignment: Alignment.center,
                  child: Container(
                    width: 134,
                    height: 5,
                    margin: const EdgeInsets.only(top: 13),
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
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Active background
            if (isActive)
              Positioned(
                top: 4,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                    color: isActive ? AppTheme.primaryCyan : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    final isActive = _currentIndex == 2;
    
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow layers
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 76 * 0.8125,
              height: 76 * 0.8125,
              decoration: const BoxDecoration(
                color: AppTheme.primaryCyan,
                shape: BoxShape.circle,
              ),
            ),
            // Main button
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
                  color: AppTheme.white,
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
