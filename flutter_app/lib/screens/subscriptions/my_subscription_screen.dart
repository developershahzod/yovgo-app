import 'package:flutter/material.dart';
import '../../services/full_api_service.dart';

class MySubscriptionScreen extends StatefulWidget {
  const MySubscriptionScreen({Key? key}) : super(key: key);

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _status == null
                ? _buildGuest(context)
                : _buildSubscribed(context),
      ),
    );
  }

  // ─── GUEST STATE (Image 1) ───
  Widget _buildGuest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Text('Mening obunam', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
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
                gradient: const LinearGradient(colors: [Color(0xFF8E9AAF), Color(0xFFB0B8C8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Stack(
                children: [
                  // Metallic shimmer overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient(center: Alignment.topRight, radius: 1.5, colors: [Colors.white.withOpacity(0.15), Colors.transparent]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mehmon obunachi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                        Row(
                          children: [
                            Text('Pullik obunalar haqida batafsil ma\'lumot', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish')),
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
        _buildActionRow(Icons.help_outline, 'Savollar va javoblar', const Color(0xFF0A0C13), () {}),
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
                            const Text('Obuna sotib oling', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Bizning obuna orqali 50% gacha pul tejaysiz!', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish')),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text('Mening obunam', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
          ),
          // Subscription card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFF1A3A7A), Color(0xFF3B7DDD)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Stack(
                children: [
                  // 3D number image
                  Positioned(
                    top: 10, left: 10,
                    child: Image.asset(
                      'assets/images/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png',
                      height: 120, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Text(_planName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Mulish')),
                        const SizedBox(height: 4),
                        Text(_endDate.isNotEmpty ? 'Tugaydi: ${_formatEndDate(_endDate)}' : '', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish')),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isExpired ? const Color(0xFFFF8C00) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: isExpired
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.info, size: 14, color: Colors.white),
                                      const SizedBox(width: 4),
                                      const Text('Obuna tugadi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text('Qoldi:', style: TextStyle(fontSize: 11, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
                                      Text('$_daysLeft kun', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildStatCard(Icons.attach_money, 'Tejalgan pul', '${_formatPrice(_savedAmount)} so\'m')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard(Icons.access_time, 'Shu oy tashriflari', _isUnlimited ? '$_visitsUsed / ∞' : '$_visitsUsed / $_visitsLimit')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action rows
          if (isExpired) ...[
            _buildActionRow(Icons.refresh, 'Obunani qayta rasmiylashtirish', const Color(0xFF00BFFE), () => Navigator.pushNamed(context, '/subscription-plans')),
            _buildActionRow(Icons.ac_unit, 'Obunani muzlatish', const Color(0xFF8F96A0), () {}),
          ],
          _buildActionRow(Icons.help_outline, 'Savollar va javoblar', const Color(0xFF0A0C13), () {}),
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
