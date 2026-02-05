import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class ProfileScreenPixelPerfect extends StatelessWidget {
  const ProfileScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Column(
        children: [
          // Top block with white background
          _buildTopBlock(context),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuList1(context),
                  const SizedBox(height: 8),
                  _buildMenuList2(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBlock(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // User info row
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF1F6FD),
                          Color(0xFFE0E3E8),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.lightGray,
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFCFD6E6),
                              Color(0xFFAEB7C8),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFF9AA3B3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Shakhzod Ismoilov',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+998 93 956 6961',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats row
              Row(
                children: [
                  _buildFactsCard(
                    icon: Icons.local_car_wash,
                    value: '0',
                    label: 'AVTO MOYKALAR',
                  ),
                  const SizedBox(width: 8),
                  _buildFactsCard(
                    icon: Icons.trending_up,
                    value: '0',
                    label: 'TASHRIFLAR',
                  ),
                  const SizedBox(width: 8),
                  _buildFactsCard(
                    icon: Icons.attach_money,
                    value: '0',
                    label: 'TEJALDI (SO\'M)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactsCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.lightBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppTheme.textPrimary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList1(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.directions_car_outlined,
            label: 'Mening mashinalarim',
            onTap: () => Navigator.pushNamed(context, '/cars'),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            icon: Icons.history,
            label: 'Tashriflar tarixi',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            icon: Icons.credit_card_outlined,
            label: 'Mening kartalarim',
            onTap: () => Navigator.pushNamed(context, '/payment-cards'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.settings_outlined,
            label: 'Sozlamalar',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            icon: Icons.description_outlined,
            label: 'Maxfiylik siyosati',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            icon: Icons.send_outlined,
            label: 'Telegram',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            icon: Icons.support_agent_outlined,
            label: 'Yordam markazi',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                icon,
                size: 24,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
