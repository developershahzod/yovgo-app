import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false; // Simulated auth state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(),
                
                const SizedBox(height: 24),
                
                // Menu Items
                _buildMenuItem(
                  Icons.settings_outlined,
                  'Sozlamalar',
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  Icons.credit_card_outlined,
                  'To\'lov kartalari',
                  onTap: () => Navigator.pushNamed(context, '/payment-cards'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  Icons.directions_car_outlined,
                  'Mening mashinalarim',
                  onTap: () => Navigator.pushNamed(context, '/cars'),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  Icons.description_outlined,
                  'Maxfiylik siyosati',
                  onTap: () => _showPrivacyPolicy(),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  Icons.send_outlined,
                  'Telegram',
                  onTap: () => _openTelegram(),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  Icons.support_agent_outlined,
                  'Yordam markazi',
                  onTap: () => _openHelpCenter(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_isLoggedIn) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightGray,
                ),
                child: Icon(
                  Icons.person,
                  size: 36,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shakhzod Ismoilov',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+998 93 956 6961',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightGray,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 36,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tizimga kiring',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ilovaning barcha qulayliklaridan foydalanish uchun ro\'yxatdan o\'ting',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.3,
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
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tizimga kirish',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.login, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppTheme.textPrimary),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maxfiylik siyosati',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '''YuvGO Maxfiylik Siyosati

1. Ma'lumotlarni yig'ish
Biz foydalanuvchilarning shaxsiy ma'lumotlarini (ism, telefon raqami, email) faqat xizmat ko'rsatish maqsadida yig'amiz.

2. Ma'lumotlardan foydalanish
Yig'ilgan ma'lumotlar faqat xizmat sifatini oshirish va foydalanuvchi tajribasini yaxshilash uchun ishlatiladi.

3. Ma'lumotlarni himoya qilish
Barcha shaxsiy ma'lumotlar shifrlangan holda saqlanadi va uchinchi tomonlarga berilmaydi.

4. Cookie fayllar
Ilova cookie fayllardan foydalanuvchi sozlamalarini saqlash uchun foydalanadi.

5. Bog'lanish
Savollar uchun: support@yuvgo.uz''',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTelegram() async {
    final Uri url = Uri.parse('https://t.me/yuvgo_support');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Telegram ochilmadi')),
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
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yordam markazi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildHelpItem('Obuna haqida', 'Obuna rejalari va to\'lovlar haqida ma\'lumot'),
                  _buildHelpItem('QR kod skanerlash', 'QR kodni qanday skanerlash kerak'),
                  _buildHelpItem('Avtomoykalarda foydalanish', 'Xizmatdan qanday foydalanish'),
                  _buildHelpItem('To\'lov muammolari', 'To\'lov bilan bog\'liq savollar'),
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
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppTheme.textPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }
}
