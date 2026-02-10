import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Map<String, dynamic>> _plans = [];
  bool _loading = true;
  Map<String, dynamic>? _activeSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final plans = await FullApiService.getSubscriptionPlans();
      Map<String, dynamic>? activeSub;
      try {
        activeSub = await FullApiService.getSubscriptionStatus();
      } catch (_) {}
      
      if (mounted) {
        setState(() {
          _plans = plans.cast<Map<String, dynamic>>();
          _activeSubscription = activeSub;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _plans = _defaultPlans;
          _loading = false;
        });
      }
    }
  }

  static final List<Map<String, dynamic>> _defaultPlans = [
    {
      'id': '1',
      'name': '30 kunlik',
      'duration_days': 30,
      'price': 1500000,
      'old_price': 1800000,
      'discount': 20,
    },
    {
      'id': '2',
      'name': '90 kunlik',
      'duration_days': 90,
      'price': 3150000,
      'old_price': 4500000,
      'discount': 30,
    },
    {
      'id': '3',
      'name': '365 kunlik',
      'duration_days': 365,
      'price': 10800000,
      'old_price': 18000000,
      'discount': 40,
    },
  ];

  String _formatPrice(dynamic price) {
    final p = (price is int) ? price : (price as num).toInt();
    final str = p.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) buffer.write(' ');
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('sub_title'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Mulish',
            color: AppTheme.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryCyan))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                // Blue gradient banner
                _buildBanner(),
                const SizedBox(height: 16),
                // View car washes row
                _buildViewCarWashesRow(),
                const SizedBox(height: 16),
                // Plan cards
                ..._getDisplayPlans().map((plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPlanCard(plan),
                )),
              ],
            ),
    );
  }

  List<Map<String, dynamic>> _getDisplayPlans() {
    if (_plans.isNotEmpty) return _plans.cast<Map<String, dynamic>>();
    return _defaultPlans;
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00BFFE), Color(0xFF0090D4)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('sub_choose_plan'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('home_premium_desc'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified_user,
            color: Colors.white.withOpacity(0.8),
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildViewCarWashesRow() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/map'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.home_outlined, size: 20, color: AppTheme.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avtomoykalarni ko\'rish',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '+ 60 avtomoykalar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Mulish',
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final name = plan['name'] ?? '${plan['duration_days']} kunlik';
    final price = plan['price'] ?? 0;
    final oldPrice = plan['old_price'] ?? plan['price'] ?? 0;
    final discount = plan['discount'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/checkout', arguments: plan);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF0)),
        ),
        child: Row(
          children: [
            // Plan icon/image placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '${plan['duration_days'] ?? 30}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                    color: AppTheme.primaryCyan,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Mulish',
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Old price
                  if (oldPrice > price)
                    Text(
                      '${_formatPrice(oldPrice)} so\'m',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish',
                        color: AppTheme.textTertiary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(height: 2),
                  // Discount + new price
                  Row(
                    children: [
                      if (discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-$discount%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mulish',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Text(
                        '${_formatPrice(price)} so\'m',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Mulish',
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.refresh, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Qayta rasmiylashtirish mumkin',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
