import 'package:flutter/material.dart';
import '../config/constants.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Главная',
                index: 0,
                route: '/home',
              ),
              _buildNavItem(
                context,
                icon: Icons.map_outlined,
                label: 'Карта',
                index: 1,
                route: '/map',
              ),
              _buildCenterButton(context),
              _buildNavItem(
                context,
                icon: Icons.history_rounded,
                label: 'История',
                index: 3,
                route: '/visits',
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                label: 'Профиль',
                index: 4,
                route: '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.iconGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.iconGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    final isActive = currentIndex == 2;
    
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, '/subscriptions');
        }
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.accent,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.card_membership_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
