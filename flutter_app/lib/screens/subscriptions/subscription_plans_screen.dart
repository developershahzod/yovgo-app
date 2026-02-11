import 'package:flutter/material.dart';
import '../../services/full_api_service.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  List<Map<String, dynamic>> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final res = await FullApiService.get('/api/mobile/subscriptions/plans');
      if (res.statusCode == 200 && res.data != null) {
        final list = res.data['plans'] as List? ?? res.data as List? ?? [];
        setState(() {
          _plans = list.map((e) => e as Map<String, dynamic>).toList();
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}
    // Fallback with real plan IDs from DB
    setState(() {
      _plans = [
        {'id': 'c62a8b3e-8c58-4c62-8ba1-b264c989b4dd', 'name': '30 kunlik', 'duration_days': 30, 'price': 1500000, 'old_price': 2500000, 'discount': 40, 'is_unlimited': true},
        {'id': '87fcee77-82fb-4193-b0b6-bad7d9cb6899', 'name': '90 kunlik', 'duration_days': 90, 'price': 4050000, 'old_price': 6750000, 'discount': 40, 'is_unlimited': true},
        {'id': 'b5f2d04f-cec8-439c-99fb-d292421ca509', 'name': 'Premium 30 kunlik', 'duration_days': 30, 'price': 3150000, 'old_price': 5250000, 'discount': 40, 'is_unlimited': true},
      ];
      _isLoading = false;
    });
  }

  String _fmt(dynamic price) {
    final p = (price is int) ? price : (price as num).toInt();
    final str = p.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buf.write(str[i]);
      c++;
      if (c % 3 == 0 && i > 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)), onPressed: () => Navigator.pop(context)),
        title: const Text('Obunalar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                children: [
                  // Cyan banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF00BFFE), Color(0xFF00A3E0)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'YuvGO bilan\nxarajatlaringizni tejang!',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish', height: 1.3),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sizga mos keladigan obuna turini tanlang',
                                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), fontFamily: 'Mulish'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                          child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Car washes row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.store_outlined, size: 18, color: Color(0xFF0A0C13)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Avtomoykalarni ko\'rish', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                              Text('+ 60 avtomoykalar', style: TextStyle(fontSize: 12, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 22, color: Color(0xFF8F96A0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Plan cards
                  ..._plans.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPlanCard(plan),
                  )),
                ],
              ),
            ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final name = plan['name'] ?? '${plan['duration_days']} kunlik';
    final price = plan['price'] ?? 0;
    final oldPrice = plan['old_price'] ?? price;
    final discount = plan['discount'] ?? 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/checkout', arguments: plan),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            // Plan image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png',
                width: 60, height: 60, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1A3A7A), Color(0xFF3B7DDD)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text('${plan['duration_days'] ?? ''}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                  const SizedBox(height: 2),
                  if (oldPrice != price)
                    Text('${_fmt(oldPrice)} so\'m', style: const TextStyle(fontSize: 13, color: Color(0xFF8F96A0), decoration: TextDecoration.lineThrough, fontFamily: 'Mulish')),
                  Row(
                    children: [
                      if (discount > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF00BFFE), borderRadius: BorderRadius.circular(6)),
                          child: Text('-$discount%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
                        ),
                      Text('${_fmt(price)} so\'m', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_car_wash, size: 13, color: const Color(0xFF8F96A0)),
                      const SizedBox(width: 4),
                      Text(
                        plan['is_unlimited'] == true
                            ? 'Cheksiz yuvish'
                            : '${plan['visit_limit'] ?? '—'} ta yuvish',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today, size: 13, color: const Color(0xFF8F96A0)),
                      const SizedBox(width: 4),
                      Text('${plan['duration_days'] ?? '—'} kun', style: const TextStyle(fontSize: 11, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF8F96A0)),
          ],
        ),
      ),
    );
  }
}
