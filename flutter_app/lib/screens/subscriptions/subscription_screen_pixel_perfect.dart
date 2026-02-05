import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SubscriptionScreenPixelPerfect extends StatelessWidget {
  const SubscriptionScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Mening obunam',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Guest subscriber card
            _buildGuestSubscriberCard(context),
            const SizedBox(height: 24),
            // FAQ menu item
            _buildFaqMenuItem(context),
            const Spacer(),
            // Buy subscription banner
            _buildBuySubscriptionBanner(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSubscriberCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 343,
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.primaryCyan,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Background image placeholder
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryCyan,
                        AppTheme.primaryCyan.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Blur overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppTheme.white.withOpacity(0.01),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mehmon obunachi',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Pullik obunalar haqida batafsil ma\'lumot',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppTheme.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqMenuItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 46,
          child: Row(
            children: const [
              SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.help_outline,
                  size: 24,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Savollar va javoblar',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
              SizedBox(
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
      ),
    );
  }

  Widget _buildBuySubscriptionBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/subscription-plans'),
        child: Container(
          width: 343,
          height: 92,
          decoration: BoxDecoration(
            color: AppTheme.darkNavy,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Top right glow
              Positioned(
                right: -50,
                top: -60,
                child: Transform.rotate(
                  angle: 15.41 * 3.14159 / 180,
                  child: Container(
                    width: 177,
                    height: 59,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan,
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom left glow
              Positioned(
                left: -49,
                bottom: -39,
                child: Container(
                  width: 63,
                  height: 66,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan,
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCyan.withOpacity(0.5),
                        blurRadius: 34.35,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              // 3D image placeholder
              Positioned(
                left: -9,
                top: -20,
                child: Container(
                  width: 129,
                  height: 161,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 80,
                    color: AppTheme.primaryCyan,
                  ),
                ),
              ),
              // Text content
              Positioned(
                left: 116,
                top: 20,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Obuna sotib oling',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 24,
                          color: AppTheme.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bizning obuna orqali 50% gacha pul tejaysiz!',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
