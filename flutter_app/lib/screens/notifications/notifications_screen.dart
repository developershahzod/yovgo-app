import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final resp = await FullApiService.get('/api/mobile/notifications');
      if (resp.statusCode == 200 && resp.data != null) {
        final list = (resp.data['notifications'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        if (mounted) setState(() { _notifications = list; _isLoading = false; });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} ${context.tr('notif_minutes_ago')}';
      if (diff.inHours < 24) return '${diff.inHours} ${context.tr('notif_hours_ago')}';
      return '${diff.inDays} ${context.tr('notif_days_ago')}';
    } catch (_) {
      return dateStr;
    }
  }

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
          context.tr('notif_title'),
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(context.tr('notif_empty'), style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      final type = (n['type'] ?? '').toString();
                      IconData icon = Icons.notifications;
                      Color iconColor = AppTheme.primaryCyan;
                      if (type.contains('promo') || type.contains('campaign')) { icon = Icons.campaign; iconColor = AppTheme.red; }
                      else if (type.contains('visit')) { icon = Icons.directions_car; iconColor = AppTheme.primaryCyan; }
                      else if (type.contains('save') || type.contains('offer')) { icon = Icons.local_offer; iconColor = AppTheme.orange; }
                      else if (type.contains('sub')) { icon = Icons.verified; iconColor = AppTheme.blue; }
                      return _buildNotificationItem(
                        icon: icon,
                        iconColor: iconColor,
                        iconBg: iconColor.withOpacity(0.1),
                        title: n['title'] ?? '',
                        description: n['message'] ?? n['body'] ?? '',
                        time: _formatTime((n['created_at'] ?? n['sent_at'] ?? '').toString()),
                        isNew: n['is_read'] == false,
                      );
                    },
                  ),
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
