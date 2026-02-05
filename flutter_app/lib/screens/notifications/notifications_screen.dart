import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

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
          'Bildirishnomalar',
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
          _buildNotificationItem(
            icon: Icons.campaign,
            iconColor: AppTheme.red,
            iconBg: AppTheme.red.withOpacity(0.1),
            title: 'Yangi aksiya!',
            description: 'YUVGo ilovasida 30% chegirma boshlanadi',
            time: '10 daqiqa oldin',
            isNew: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.directions_car,
            iconColor: AppTheme.primaryCyan,
            iconBg: AppTheme.primaryCyan.withOpacity(0.1),
            title: 'Yangilash!',
            description: 'E-avtomobil uchun elektr to\'ldirish punktlari qo\'shildi',
            time: '1 soat oldin',
            isNew: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.local_offer,
            iconColor: AppTheme.orange,
            iconBg: AppTheme.orange.withOpacity(0.1),
            title: '120 000 so\'m tejaldi',
            description: 'Siz avto yuvish xizmatlari uchun 120 000 so\'m tejalgan',
            time: '2 soat oldin',
            isNew: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.verified,
            iconColor: AppTheme.blue,
            iconBg: AppTheme.blue.withOpacity(0.1),
            title: 'Premium obunangiz faol',
            description: 'Premium obuna aktivlashtirildi va 90 kun davom etadi',
            time: '1 kun oldin',
            isNew: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required String time,
    required bool isNew,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: isNew ? Border.all(color: AppTheme.primaryCyan, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
