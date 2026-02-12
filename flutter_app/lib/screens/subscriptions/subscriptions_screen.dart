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
        final res = await FullApiService.getSubscriptionStatus();
        final sub = res['subscription'] as Map<String, dynamic>?;
        if (sub != null && sub['status'] == 'active') {
          activeSub = sub;
        }
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
          _plans = [];
          _loading = false;
        });
      }
    }
  }

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
                // Active subscription card (if exists)
                if (_activeSubscription != null) _buildActiveSubscriptionCard(),
                if (_activeSubscription != null) const SizedBox(height: 16),
                // Blue gradient banner (only if no active sub)
                if (_activeSubscription == null) _buildBanner(),
                if (_activeSubscription == null) const SizedBox(height: 16),
                // View car washes row
                _buildViewCarWashesRow(),
                const SizedBox(height: 16),
                // Plan cards
                if (_activeSubscription == null)
                  ..._getDisplayPlans().map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPlanCard(plan),
                  )),
              ],
            ),
    );
  }

  List<Map<String, dynamic>> _getDisplayPlans() {
    return _plans.cast<Map<String, dynamic>>();
  }

  Widget _buildActiveSubscriptionCard() {
    final sub = _activeSubscription!;
    final planName = sub['plan_name'] ?? 'Obuna';
    final remaining = sub['remaining_visits'] ?? sub['visits_remaining'] ?? 0;
    final used = sub['used_visits'] ?? sub['visits_used'] ?? 0;
    final isUnlimited = sub['is_unlimited'] == true;
    String endStr = '';
    try {
      final dt = DateTime.parse(sub['end_date'].toString());
      final months = ['Yanvar','Fevral','Mart','Aprel','May','Iyun','Iyul','Avgust','Sentabr','Oktabr','Noyabr','Dekabr'];
      endStr = '${dt.day} ${months[dt.month - 1]}, ${dt.year}';
    } catch (_) {
      endStr = sub['end_date']?.toString() ?? '';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0C13), Color(0xFF1A2332)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5CCC27),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('FAOL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
              ),
              const Spacer(),
              Icon(Icons.workspace_premium, color: const Color(0xFF00BFFE), size: 28),
            ],
          ),
          const SizedBox(height: 12),
          Text(planName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish')),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _buildSubStat(isUnlimited ? '∞' : '$remaining', 'Qolgan\ntashriflar'),
              const SizedBox(width: 20),
              _buildSubStat('$used', 'Ishlatilgan\ntashriflar'),
            ],
          ),
          const SizedBox(height: 16),
          // End date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text('Amal qilish muddati: $endStr', style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Mulish')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white60, fontFamily: 'Mulish', height: 1.3)),
      ],
    );
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
    final durationDays = plan['duration_days'] ?? 0;
    final visitLimit = plan['visit_limit'] ?? 0;

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
            // Plan icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '$durationDays',
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
                  const SizedBox(height: 4),
                  Text(
                    '${_formatPrice(price)} so\'m',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Mulish',
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$durationDays kun \u00b7 $visitLimit ta tashrif',
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
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
