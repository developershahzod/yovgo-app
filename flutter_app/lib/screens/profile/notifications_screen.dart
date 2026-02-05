import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Obuna faollashtirildi',
      message: 'Premium 90 kunlik obunangiz muvaffaqiyatli faollashtirildi',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'subscription',
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Tashrif muvaffaqiyatli',
      message: 'Black Star Car Wash ga tashrifingiz qayd etildi',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'visit',
      isRead: true,
    ),
    AppNotification(
      id: '3',
      title: 'Maxsus taklif',
      message: '30% chegirma bilan yangi Premium obunani sotib oling!',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: 'promo',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bildirishnomalar', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Barchasini o\'qish'),
            ),
        ],
      ),
      body: _notifications.isEmpty ? _buildEmptyState() : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bildirishnomalar yo\'q',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            'Yangi bildirishnomalar bu yerda ko\'rinadi',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(_notifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    IconData icon;
    Color iconColor;
    
    switch (notification.type) {
      case 'subscription':
        icon = Icons.workspace_premium;
        iconColor = AppColors.primary;
        break;
      case 'visit':
        icon = Icons.local_car_wash;
        iconColor = AppColors.success;
        break;
      case 'promo':
        icon = Icons.local_offer;
        iconColor = AppColors.warning;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppColors.info;
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
      },
      child: GestureDetector(
        onTap: () => _markAsRead(notification),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead ? AppColors.border : AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification.date),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markAsRead(AppNotification notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} daqiqa oldin';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} soat oldin';
    } else if (difference.inDays == 1) {
      return 'Kecha';
    } else {
      return '${difference.inDays} kun oldin';
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
  });
}
