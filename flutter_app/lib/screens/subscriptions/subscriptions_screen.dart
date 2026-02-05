import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final List<Map<String, dynamic>> _plans = [
    {
      'name': '30 kunlik',
      'price': '365 000',
      'duration': '30 kun',
      'visits': '10',
      'popular': false,
    },
    {
      'name': '90 kunlik',
      'price': '950 000',
      'duration': '90 kun',
      'visits': '30',
      'popular': true,
    },
    {
      'name': '365 kunlik',
      'price': '3 200 000',
      'duration': '365 kun',
      'visits': '120',
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Obuna rejalarini tanlang',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'O\'zingizga mos rejani tanlang',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ..._plans.map((plan) => _buildPlanCard(plan)),
          ],
        ),
      ),
    );
  }


  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isPopular = plan['popular'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? AppTheme.primaryCyan : AppTheme.borderGray,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'MASHHUR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 10),
            Text(
              plan['name'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan['price'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryCyan,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'so\'m',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildFeature(Icons.check_circle, '${plan['visits']} ta tashrif'),
            const SizedBox(height: 8),
            _buildFeature(Icons.check_circle, 'Barcha hamkor avtomoykalar'),
            const SizedBox(height: 8),
            _buildFeature(Icons.check_circle, '24/7 qo\'llab-quvvatlash'),
            const SizedBox(height: 8),
            _buildFeature(Icons.check_circle, 'Chegirmalar va bonuslar'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular ? AppTheme.yellow : AppTheme.darkNavy,
                  foregroundColor: isPopular ? AppTheme.darkNavy : AppTheme.white,
                ),
                child: Text(
                  'Rejani tanlash',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
