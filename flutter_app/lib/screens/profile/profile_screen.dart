import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/auth_service.dart';
import '../../services/visit_service.dart';
import '../../services/subscription_service.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  int _totalVisits = 0;
  int _activeSubscriptions = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = await AuthService.getCurrentUser();
      final subscriptions = await SubscriptionService.getUserSubscriptions();
      final stats = await VisitService.getVisitStats();
      
      setState(() {
        _user = user;
        _activeSubscriptions = subscriptions.where((s) => s.isActive).length;
        _totalVisits = stats?['total_visits'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
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
                              _user?.fullName ?? 'Пользователь',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user?.phoneNumber ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('$_totalVisits', 'Визитов'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('$_activeSubscriptions', 'Подписки'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Menu items
                _buildMenuItem(
                  Icons.card_membership_outlined,
                  'Мои подписки',
                  () => Navigator.pushNamed(context, '/subscriptions'),
                ),
                _buildMenuItem(
                  Icons.history_outlined,
                  'История визитов',
                  () => Navigator.pushNamed(context, '/visits'),
                ),
                _buildMenuItem(
                  Icons.qr_code_scanner_outlined,
                  'QR Сканер',
                  () => Navigator.pushNamed(context, '/qr'),
                ),
                _buildMenuItem(
                  Icons.map_outlined,
                  'Карта автомоек',
                  () => Navigator.pushNamed(context, '/map'),
                ),
                _buildMenuItem(
                  Icons.help_outline,
                  'Помощь',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Раздел в разработке')),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.info_outline,
                  'О приложении',
                  () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'YuvGo',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 YuvGo. Все права защищены.',
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _handleLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                    ),
                    child: const Text('Выйти'),
                  ),
                ),
                
                const SizedBox(height: 100),
              ],
            ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }

  String _getInitials() {
    if (_user?.fullName == null || _user!.fullName!.isEmpty) {
      return 'U';
    }
    final parts = _user!.fullName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _user!.fullName![0].toUpperCase();
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.iconGray),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.iconGray,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/welcome',
          (route) => false,
        );
      }
    }
  }
}
