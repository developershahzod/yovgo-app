import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  bool _isPremium = false;
  String _fullName = '';
  String _phone = '';
  int _carWashCount = 0;
  int _visitCount = 0;
  int _savedAmount = 0;
  int _vehicleCount = 0;
  int _cardCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final loggedIn = await FullApiService.isLoggedIn();
      if (!loggedIn) {
        if (mounted) setState(() => _isLoggedIn = false);
        return;
      }
      
      setState(() => _isLoggedIn = true);
      
      // Load user profile
      try {
        final response = await FullApiService.get('/api/user/me');
        if (mounted && response.statusCode == 200) {
          final userData = response.data;
          setState(() {
            _fullName = userData['full_name'] ?? '';
            _phone = userData['phone_number'] ?? '';
          });
        }
      } catch (_) {}
      
      // Load vehicles
      try {
        final vehicles = await FullApiService.getVehicles();
        if (mounted) setState(() => _vehicleCount = vehicles.length);
      } catch (_) {}
      
      // Load visit stats via mobile API
      try {
        final resp = await FullApiService.get('/api/mobile/users/stats');
        if (mounted && resp.statusCode == 200) {
          final stats = resp.data['stats'] ?? resp.data;
          setState(() {
            _visitCount = stats['total_visits'] ?? 0;
            _savedAmount = stats['total_savings'] ?? stats['total_saved'] ?? 0;
            _carWashCount = stats['total_car_washes'] ?? 0;
          });
        }
      } catch (_) {}
      
      // Load subscription status
      try {
        final sub = await FullApiService.getSubscriptionStatus();
        if (mounted && sub['status'] == 'active') {
          setState(() => _isPremium = true);
        }
      } catch (_) {}
      
      // Load saved cards
      try {
        final cards = await FullApiService.getSavedCards();
        if (mounted) {
          setState(() => _cardCount = (cards['contracts'] as List?)?.length ?? 0);
        }
      } catch (_) {}
    } catch (e) {
      if (mounted) {
        setState(() => _isLoggedIn = false);
      }
    }
  }

  String _formatNumber(int n) {
    final str = n.toString();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              // Profile header with avatar
              _buildProfileHeader(),
              const SizedBox(height: 16),
              // Stats row
              if (_isLoggedIn) ...[
                _buildStatsRow(),
                const SizedBox(height: 24),
              ],
              // Menu section 1 - Account
              _buildMenuRow(Icons.directions_car_outlined, context.tr('profile_vehicles'),
                  trailing: _vehicleCount > 0 ? '$_vehicleCount ta' : null,
                  onTap: () => Navigator.pushNamed(context, '/cars')),
              _buildDivider(),
              _buildMenuRow(Icons.history, context.tr('profile_history'),
                  onTap: () => Navigator.pushNamed(context, '/visit-history')),
              _buildDivider(),
              _buildMenuRow(Icons.credit_card_outlined, context.tr('profile_payment_methods'),
                  trailing: _cardCount > 0 ? '$_cardCount' : null,
                  onTap: () => Navigator.pushNamed(context, '/payment-cards')),
              
              const SizedBox(height: 24),
              // Divider line
              Container(height: 8, color: const Color(0xFFF5F5F5)),
              const SizedBox(height: 8),
              
              // Menu section 2 - Settings
              _buildMenuRow(Icons.settings_outlined, context.tr('profile_settings'),
                  onTap: () => Navigator.pushNamed(context, '/settings')),
              _buildDivider(),
              _buildMenuRow(Icons.description_outlined, context.tr('settings_privacy'),
                  onTap: () => _showPrivacyPolicy()),
              _buildDivider(),
              _buildMenuRow(Icons.send_outlined, 'Telegram',
                  onTap: () => _openTelegram()),
              _buildDivider(),
              _buildMenuRow(Icons.support_agent_outlined, context.tr('profile_help'),
                  onTap: () => _openHelpCenter()),
              if (_isLoggedIn) ...[              
                const SizedBox(height: 24),
                Container(height: 8, color: const Color(0xFFF5F5F5)),
                const SizedBox(height: 8),
                _buildMenuRow(Icons.logout, context.tr('profile_logout'), onTap: () => _handleLogout()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (!_isLoggedIn) {
      return Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/avatar-types.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('profile_login'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Mulish',
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('auth_register'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish',
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.tr('auth_login'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                  const SizedBox(width: 8),
                  const Icon(Icons.login, size: 20),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final name = _fullName.isNotEmpty ? _fullName : 'Foydalanuvchi';
    final phone = _phone.isNotEmpty ? _phone : '';

    return Row(
      children: [
        // Avatar with cyan border
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryCyan, width: 2.5),
          ),
          child: const CircleAvatar(
            radius: 37,
            backgroundImage: AssetImage('assets/images/avatar-types.png'),
            backgroundColor: Color(0xFFF0F4F9),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium badge
              if (_isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    context.tr('subscriber'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Mulish',
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Mulish',
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Mulish',
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatBox(Icons.home_outlined, '$_carWashCount', context.tr('home_nearest').toUpperCase())),
        const SizedBox(width: 8),
        Expanded(child: _buildStatBox(Icons.bolt, '$_visitCount', context.tr('home_recent').toUpperCase())),
        const SizedBox(width: 8),
        Expanded(child: _buildStatBox(Icons.attach_money, _formatNumber(_savedAmount), context.tr('sub_best_value').toUpperCase())),
      ],
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppTheme.textPrimary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Mulish',
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String label, {String? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppTheme.textPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Mulish',
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right, color: AppTheme.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF0F0F0));
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('privacy_policy'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${context.tr('privacy_policy_title')}\n\n'
                  '${context.tr('privacy_policy_section1_title')}\n${context.tr('privacy_policy_section1')}\n\n'
                  '${context.tr('privacy_policy_section2_title')}\n${context.tr('privacy_policy_section2')}\n\n'
                  '${context.tr('privacy_policy_section3_title')}\n${context.tr('privacy_policy_section3')}\n\n'
                  '${context.tr('privacy_policy_section4_title')}\n${context.tr('privacy_policy_section4')}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('auth_logout'), style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
        content: Text(context.tr('auth_logout_confirm'), style: const TextStyle(fontFamily: 'Mulish')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.tr('cancel'))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(context.tr('auth_logout'), style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await FullApiService.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _openTelegram() async {
    final Uri url = Uri.parse('https://t.me/yuvgo_support');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('telegram_error'))),
        );
      }
    }
  }

  void _openHelpCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('help_center'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildHelpItem('Obuna haqida', 'Obuna rejalari va to\'lovlar haqida'),
                  _buildHelpItem('QR kod skanerlash', 'QR kodni qanday skanerlash kerak'),
                  _buildHelpItem('Biz bilan bog\'lanish', 'Telefon: +998 71 123 45 67\nEmail: support@yuvgo.uz'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
