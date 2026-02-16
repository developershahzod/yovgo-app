import 'package:flutter/material.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class MySubscriptionScreen extends StatefulWidget {
  const MySubscriptionScreen({Key? key}) : super(key: key);

  static final GlobalKey<_MySubscriptionScreenState> globalKey = GlobalKey<_MySubscriptionScreenState>();

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  // null = guest, 'active', 'expired'
  String? _status;
  String _planName = '';
  int _daysLeft = 0;
  String _endDate = '';
  int _visitsUsed = 0;
  int _visitsLimit = 0;
  bool _isUnlimited = false;
  int _savedAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  void refreshData() {
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      final res = await FullApiService.get('/api/mobile/subscriptions/active');
      if (res.statusCode == 200 && res.data != null) {
        final sub = res.data is Map ? (res.data['subscription'] ?? res.data) : null;
        if (sub != null && sub['status'] != null) {
          // Calculate days remaining from end_date
          int daysLeft = 0;
          final endDateStr = sub['end_date']?.toString() ?? '';
          if (endDateStr.isNotEmpty) {
            try {
              final endDt = DateTime.parse(endDateStr);
              daysLeft = endDt.difference(DateTime.now()).inDays;
              if (daysLeft < 0) daysLeft = 0;
            } catch (_) {}
          }
          final usedVisits = sub['used_visits'] ?? sub['visits_used'] ?? 0;
          setState(() {
            _status = sub['status'];
            _planName = sub['plan_name'] ?? '${sub['duration_days'] ?? 90} kunlik obuna';
            _daysLeft = sub['days_remaining'] ?? daysLeft;
            _endDate = endDateStr;
            _visitsUsed = usedVisits;
            _visitsLimit = sub['total_visits'] ?? sub['visit_limit'] ?? 0;
            _isUnlimited = sub['is_unlimited'] == true;
            _savedAmount = sub['saved_amount'] ?? (usedVisits * 15000);
          });
        }
      }
    } catch (_) {}

    // Load visit stats
    try {
      final statsRes = await FullApiService.get('/api/visit/visits/stats');
      if (statsRes.statusCode == 200 && statsRes.data != null) {
        final stats = statsRes.data is Map ? statsRes.data : {};
        setState(() {
          if (_visitsUsed == 0) _visitsUsed = stats['total_visits'] ?? stats['this_month'] ?? 0;
          if (_savedAmount == 0) _savedAmount = stats['saved_amount'] ?? 0;
        });
      }
    } catch (_) {}

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00BCD4),
          onRefresh: () async {
            setState(() => _isLoading = true);
            await _loadSubscription();
          },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _status == null
                      ? _buildGuest(context)
                      : _buildSubscribed(context),
                ),
        ),
      ),
    );
  }

  // ─── GUEST STATE (Image 1) ───
  Widget _buildGuest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Text(context.tr('my_subscription'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        ),
        // Guest card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/subscription-plans'),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF2D2D2D),
              ),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/cf60d18fa5d4a3f355d9680de472249a061f2d56.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.tr('guest_subscriber'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                        Row(
                          children: [
                            Text(context.tr('sub_paid_info'), style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish')),
                            const SizedBox(width: 6),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // FAQ row
        _buildActionRow(Icons.help_outline, context.tr('sub_faq'), const Color(0xFF0A0C13), () {}),
        const Spacer(),
        // Buy subscription banner
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/subscription-plans'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF00BFFE), Color(0xFF00A3E0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // % icon
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    child: const Center(child: Text('%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(context.tr('sub_buy'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(context.tr('sub_save_desc'), style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SUBSCRIBED STATE (Images 2, 3) ───
  Widget _buildSubscribed(BuildContext context) {
    final isExpired = _status == 'expired';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text(context.tr('my_subscription'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
          ),
          // Subscription card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFF1A3A7A), Color(0xFF3B7DDD)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // PREMIUM badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              const Text('PREMIUM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish', letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (!isExpired)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF5CCC27), borderRadius: BorderRadius.circular(8)),
                            child: Text(context.tr('sub_active'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                          ),
                        if (isExpired)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFF8C00), borderRadius: BorderRadius.circular(8)),
                            child: Text(context.tr('sub_expired_badge'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(_planName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish')),
                    const SizedBox(height: 6),
                    if (_endDate.isNotEmpty)
                      Text('${context.tr('sub_expires')}: ${_formatEndDate(_endDate)}', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85), fontFamily: 'Mulish')),
                    const SizedBox(height: 16),
                    // Stats inside card
                    Row(
                      children: [
                        // Remaining days
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Text('$_daysLeft', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish')),
                              Text(context.tr('days'), style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontFamily: 'Mulish')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Visits
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Text(_isUnlimited ? '∞' : '${_visitsLimit - _visitsUsed}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish')),
                              Text(context.tr('qr_visits_remaining'), style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontFamily: 'Mulish')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildStatCard(Icons.attach_money, context.tr('saved_money'), '${_formatPrice(_savedAmount)} ${context.tr('currency')}')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard(Icons.access_time, context.tr('monthly_visits'), _isUnlimited ? '$_visitsUsed / ∞' : '$_visitsUsed / $_visitsLimit')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action rows
          if (isExpired) ...[
            _buildActionRow(Icons.refresh, context.tr('sub_renew_action'), const Color(0xFF00BFFE), () => Navigator.pushNamed(context, '/subscription-plans')),
            _buildActionRow(Icons.ac_unit, context.tr('sub_freeze'), const Color(0xFF8F96A0), () {}),
          ],
          _buildActionRow(Icons.help_outline, context.tr('sub_faq'), const Color(0xFF0A0C13), () {}),
          const SizedBox(height: 24),
          // View all plans button — only when expired
          if (isExpired)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/subscription-plans'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF00BFFE), Color(0xFF00A3E0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.list_alt, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.tr('sub_view_all_plans'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                            const SizedBox(height: 2),
                            Text(context.tr('sub_view_prices'), style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85), fontFamily: 'Mulish')),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: const Color(0xFF0A0C13)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEndDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = ['Yanvar','Fevral','Mart','Aprel','May','Iyun','Iyul','Avgust','Sentabr','Oktabr','Noyabr','Dekabr'];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buf.write(str[i]);
      c++;
      if (c % 3 == 0 && i > 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  Widget _buildActionRow(IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color, fontFamily: 'Mulish'))),
            Icon(Icons.chevron_right, size: 22, color: const Color(0xFF8F96A0)),
          ],
        ),
      ),
    );
  }
}
