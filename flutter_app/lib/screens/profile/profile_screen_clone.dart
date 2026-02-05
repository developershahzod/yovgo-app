import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class ProfileScreenFixed extends StatelessWidget {
  const ProfileScreenFixed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // User info section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8E8E8),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: const Color(0xFFB0B0B0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name and phone
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shakhzod Ismoilov',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+998 93 956 6961',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard(Icons.local_car_wash, '0', 'AVTO MOYKALAR'),
                    const SizedBox(width: 8),
                    _buildStatCard(Icons.bolt, '0', 'TASHRIFLAR'),
                    const SizedBox(width: 8),
                    _buildStatCard(Icons.attach_money, '0', 'TEJALDI (SO\'M)'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu items - First group
              _buildMenuItem(Icons.directions_car_outlined, 'Mening mashinalarim'),
              _buildMenuItem(Icons.history, 'Tashriflar tarixi'),
              _buildMenuItem(Icons.credit_card_outlined, 'Mening kartalarim'),

              // Divider
              Container(
                height: 8,
                color: const Color(0xFFF5F5F5),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              // Menu items - Second group
              _buildMenuItem(Icons.settings_outlined, 'Sozlamalar'),
              _buildMenuItem(Icons.description_outlined, 'Maxfiylik siyosati'),
              _buildMenuItem(Icons.send_outlined, 'Telegram'),
              _buildMenuItem(Icons.headset_mic_outlined, 'Yordam markazi'),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textPrimary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish',
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 24),
        ],
      ),
    );
  }
}
