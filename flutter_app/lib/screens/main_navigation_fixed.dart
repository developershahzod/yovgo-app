import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_theme.dart';
import '../l10n/language_provider.dart';
import 'home/home_screen_fixed.dart';
import 'map/map_screen_new.dart';
import 'qr/qr_scanner_screen_fixed.dart';
import 'subscriptions/my_subscription_screen.dart';
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
          const MySubscriptionScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 80,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget _buildNavItem({
    required String svgType,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final color = isActive ? AppTheme.primaryCyan : const Color(0xFF2D3142);
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/$svgType.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                fontFamily: 'Mulish',
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
        width: 72,
        height: 72,
        margin: const EdgeInsets.only(bottom: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(0, 191, 254, 0.12),
              ),
            ),
            // Middle ring
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(0, 191, 254, 0.25),
              ),
            ),
            // Inner button
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryCyan,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 191, 254, 0.4),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/qr.svg',
                  width: 26,
                  height: 26,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
