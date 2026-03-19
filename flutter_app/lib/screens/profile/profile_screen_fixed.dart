import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../l10n/language_provider.dart';
import '../../services/full_api_service.dart';
import 'token_wallet_screen.dart';

class ProfileScreenFixed extends StatefulWidget {
  const ProfileScreenFixed({Key? key}) : super(key: key);

  @override
  State<ProfileScreenFixed> createState() => _ProfileScreenFixedState();
}

class _ProfileScreenFixedState extends State<ProfileScreenFixed> {
  double _tokenBalance = 0;
  bool _tokenLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTokenBalance();
  }

  Future<void> _loadTokenBalance() async {
    final data = await FullApiService.getTokenBalance();
    if (mounted) {
      setState(() {
        _tokenBalance = (data['balance'] as num?)?.toDouble() ?? 0;
        _tokenLoaded = true;
      });
    }
  }

  String _fmtTokens(double n) {
    final val = n.toInt();
    final s = val.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]); c++;
      if (c % 3 == 0 && i > 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // User info section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8E8E8),
                      ),
                      child: const Icon(Icons.person, size: 40, color: Color(0xFFB0B0B0)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shakhzod Ismoilov',
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+998 93 956 6961',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontFamily: 'Mulish'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ─── Token Balance Banner ───
              GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenWalletScreen()));
                  _loadTokenBalance();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A0C13), Color(0xFF1A2035)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD600).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.toll, color: Color(0xFFFFD600), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('tokens_title'),
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Mulish', fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            _tokenLoaded
                                ? Text(
                                    '${_fmtTokens(_tokenBalance)} tokens',
                                    style: const TextStyle(color: Color(0xFFFFD600), fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'Mulish'),
                                  )
                                : const SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: Color(0xFF222633), color: Color(0xFFFFD600)),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD600),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.tr('tokens_topup'),
                          style: const TextStyle(color: Color(0xFF0A0C13), fontSize: 12, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Stats cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard(context, Icons.local_car_wash, '0', context.tr('saved_title')),
                    const SizedBox(width: 8),
                    _buildStatCard(context, Icons.bolt, '0', context.tr('profile_history')),
                    const SizedBox(width: 8),
                    _buildStatCard(context, Icons.attach_money, '0', context.tr('payment_title')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu items - First group
              _buildMenuItem(context, Icons.directions_car_outlined, context.tr('profile_vehicles'), () => Navigator.pushNamed(context, '/cars')),
              _buildMenuItem(context, Icons.history, context.tr('profile_history'), () {}),
              _buildMenuItem(context, Icons.credit_card_outlined, context.tr('profile_payment_methods'), () => Navigator.pushNamed(context, '/payment-cards')),
              _buildTokenMenuItem(context),

              // Divider
              Container(
                height: 8,
                color: const Color(0xFFF5F5F5),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              // Menu items - Second group
              _buildMenuItem(context, Icons.settings_outlined, context.tr('profile_settings'), () => Navigator.pushNamed(context, '/settings')),
              _buildMenuItem(context, Icons.description_outlined, context.tr('settings_privacy'), () {}),
              _buildMenuItem(context, Icons.send_outlined, 'Telegram', () {}),
              _buildMenuItem(context, Icons.headset_mic_outlined, context.tr('profile_help'), () {}),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenMenuItem(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenWalletScreen()));
        _loadTokenBalance();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.toll, color: Color(0xFFFFAA00), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                context.tr('tokens_title'),
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Mulish'),
              ),
            ),
            if (_tokenLoaded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD600).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_fmtTokens(_tokenBalance)} tkn',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFFFAA00), fontFamily: 'Mulish'),
                ),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}
