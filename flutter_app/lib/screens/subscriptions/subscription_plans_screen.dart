import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

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
    // Fallback: show empty state if API failed
    setState(() {
      _plans = [];
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
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)), onPressed: () => Navigator.pop(context)),
        title: Text(context.tr('sub_plans_title'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
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
                              Text(
                                context.tr('sub_banner_title'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Mulish', height: 1.3),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.tr('sub_banner_desc'),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.tr('view_car_washes'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                              Text(context.tr('car_wash_count'), style: const TextStyle(fontSize: 12, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
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

  String _localizedField(Map<String, dynamic> plan, String baseKey) {
    final lang = context.read<LanguageProvider>().languageCode;
    if (lang == 'ru') {
      final val = plan['${baseKey}_ru'];
      if (val != null && (val as String).isNotEmpty) return val;
    } else if (lang == 'en') {
      final val = plan['${baseKey}_en'];
      if (val != null && (val as String).isNotEmpty) return val;
    }
    return plan[baseKey] ?? '';
  }

  String _buildSubtitle(Map<String, dynamic> plan) {
    final lang = context.read<LanguageProvider>().languageCode;
    final days = plan['duration_days'] ?? 0;
    final visits = plan['visit_limit'] ?? 0;
    final isUnlimited = plan['is_unlimited'] == true;

    if (lang == 'ru') {
      final visitsStr = isUnlimited ? 'безлимит' : '$visits посещений';
      return '$days дней · $visitsStr';
    } else if (lang == 'en') {
      final visitsStr = isUnlimited ? 'unlimited' : '$visits visits';
      return '$days days · $visitsStr';
    } else {
      final visitsStr = isUnlimited ? 'cheksiz' : '$visits ta tashrif';
      return '$days kun · $visitsStr';
    }
  }

  bool _isStarterPlan(Map<String, dynamic> plan) {
    return plan['is_one_time'] == true || plan['visit_limit'] == 1;
  }

  String _starterLimitLabel(Map<String, dynamic> plan) {
    final lang = context.read<LanguageProvider>().languageCode;
    final max = plan['max_users'] ?? 1000;
    if (lang == 'ru') return 'Только $max пользователей';
    if (lang == 'en') return '$max users only';
    return 'Faqat $max foydalanuvchi';
  }

  String _oneTimeBadgeLabel() {
    final lang = context.read<LanguageProvider>().languageCode;
    if (lang == 'ru') return 'Однократно';
    if (lang == 'en') return 'One-time';
    return 'Bir martalik';
  }

  String _priceLabel(Map<String, dynamic> plan) {
    final lang = context.read<LanguageProvider>().languageCode;
    final price = plan['price'] ?? 0;
    if (lang == 'ru') return '${_fmt(price)} сум';
    if (lang == 'en') return '${_fmt(price)} UZS';
    return "${_fmt(price)} so'm";
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final name = _localizedField(plan, 'name').isNotEmpty
        ? _localizedField(plan, 'name')
        : '${plan['duration_days']} kunlik';
    final durationDays = plan['duration_days'] ?? 0;
    final isStarter = _isStarterPlan(plan);

    if (isStarter) return _buildStarterPlanCard(plan, name);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                (durationDays >= 365)
                    ? 'assets/images/dc39eda64d246726ea5621050f1a81b4f23f7d79.png'
                    : 'assets/images/c22416c54393bfea53da65c75321cdc015b47ddb.png',
                width: 60, height: 60, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1A3A7A), Color(0xFF3B7DDD)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text('$durationDays', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                  const SizedBox(height: 4),
                  Text(_priceLabel(plan), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                  const SizedBox(height: 2),
                  Text(_buildSubtitle(plan), style: const TextStyle(fontSize: 13, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF8F96A0)),
          ],
        ),
      ),
    );
  }

  Widget _buildStarterPlanCard(Map<String, dynamic> plan, String name) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/checkout', arguments: plan),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD600), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFFD600).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: badge + limit
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0C13),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFFFFD600), size: 14),
                        const SizedBox(width: 4),
                        Text(_oneTimeBadgeLabel(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline, color: Color(0xFF0A0C13), size: 14),
                        const SizedBox(width: 4),
                        Text(_starterLimitLabel(plan), style: const TextStyle(color: Color(0xFF0A0C13), fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Icon + Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0C13),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.local_car_wash, color: Color(0xFFFFD600), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
                        const SizedBox(height: 2),
                        Text(_buildSubtitle(plan), style: TextStyle(fontSize: 13, color: const Color(0xFF0A0C13).withOpacity(0.6), fontFamily: 'Mulish')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Divider
              Container(height: 1, color: const Color(0xFF0A0C13).withOpacity(0.15)),
              const SizedBox(height: 14),
              // Price + CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_priceLabel(plan), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0C13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward, color: Color(0xFFFFD600), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
