import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Obunalar',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryCyan, Color(0xFF00B8D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppTheme.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YuvGO bilan xarajatlaringizni tejang!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sizga mos keladigan obuna turini tanlang',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Car Washes Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderGray, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.store,
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Avtomoykalarni ko\'rish',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '+ 60 avtomoykalar',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 30 Days Plan
            _buildPlanCard(
              context,
              icon: '30',
              title: '30 kunlik',
              originalPrice: '10 000 000 so\'m',
              discountedPrice: '1 200 000 so\'m',
              discount: '-20%',
              canRenew: true,
            ),
            
            const SizedBox(height: 12),
            
            // 90 Days Plan
            _buildPlanCard(
              context,
              icon: '90',
              title: '90 kunlik',
              originalPrice: '4 500 000 so\'m',
              discountedPrice: '3 150 000 so\'m',
              discount: '-30%',
              canRenew: true,
            ),
            
            const SizedBox(height: 12),
            
            // 365 Days Plan
            _buildPlanCard(
              context,
              icon: '365',
              title: '365 kunlik',
              originalPrice: '18 000 000 so\'m',
              discountedPrice: '10 800 000 so\'m',
              discount: '-40%',
              canRenew: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String originalPrice,
    required String discountedPrice,
    required String discount,
    required bool canRenew,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/subscription-detail');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderGray, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with 3D effect
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.darkNavy,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          discount,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        discountedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    originalPrice,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  if (canRenew) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Qayta rasmiylashtiris mumkin',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
