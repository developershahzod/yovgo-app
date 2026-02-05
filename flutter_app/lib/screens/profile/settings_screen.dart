import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String _selectedLanguage = 'uz';

  final Map<String, Map<String, String>> _languages = {
    'uz': {'name': "O'zbekcha", 'flag': '🇺🇿'},
    'ru': {'name': 'Русский', 'flag': '🇷🇺'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sozlanmalar',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: 'Bildirishnoma',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              activeColor: AppTheme.primaryCyan,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Ilova tili',
            subtitle: _languages[_selectedLanguage]!['name']!,
            onTap: () {
              _showLanguageSelector(context);
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'Loyiha haqida',
            onTap: () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(width: 16),
            Expanded(
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
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Ilova tilini tanlang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption('uz', "O'zbekcha", '🇺🇿'),
              _buildLanguageOption('ru', 'Русский', '🇷🇺'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text('YUV', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryCyan)),
            Text('GO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.darkNavy)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versiya: 1.0.0',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'YuvGO - O\'zbekistondagi eng qulay avtomobil yuvish xizmati. Obuna orqali barcha hamkor avtomoykalardan foydalaning.',
              style: TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 YuvGO. Barcha huquqlar himoyalangan.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Yopish', style: TextStyle(color: AppTheme.primaryCyan)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name, String flag) {
    final isSelected = _selectedLanguage == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: AppTheme.white,
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppTheme.primaryCyan,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
