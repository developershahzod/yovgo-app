import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

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
      if (mounted && resp.statusCode == 200) {
        final notifs = (resp.data['notifications'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        setState(() { _notifications = notifs; _isLoading = false; });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await FullApiService.post('/api/mobile/notifications/read-all', data: {});
      setState(() {
        for (var n in _notifications) {
          n['is_read'] = true;
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.tr('notif_title'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
        centerTitle: true,
        actions: [
          if (_notifications.any((n) => n['is_read'] != true))
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(context.tr('notif_mark_read'), style: TextStyle(fontSize: 13, color: AppTheme.primaryCyan, fontFamily: 'Mulish')),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 191, 254, 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, size: 64, color: AppTheme.primaryCyan),
          ),
          const SizedBox(height: 24),
          Text(context.tr('notif_empty'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) => _buildNotificationCard(_notifications[index]),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final type = (n['type'] ?? '').toString();
    final isRead = n['is_read'] == true;
    final title = (n['title'] ?? '').toString();
    final message = (n['message'] ?? n['body'] ?? '').toString();
    DateTime? date;
    try { date = DateTime.parse(n['created_at'] ?? ''); } catch (_) {}

    IconData icon;
    Color iconColor;
    switch (type) {
      case 'subscription':
        icon = Icons.workspace_premium;
        iconColor = AppTheme.primaryCyan;
        break;
      case 'visit':
        icon = Icons.local_car_wash;
        iconColor = const Color(0xFF5CCC27);
        break;
      case 'promo':
        icon = Icons.local_offer;
        iconColor = const Color(0xFFFFAB00);
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppTheme.primaryCyan;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color.fromRGBO(0, 191, 254, 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isRead ? const Color(0xFFF0F0F0) : const Color.fromRGBO(0, 191, 254, 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: Color.fromRGBO(iconColor.red, iconColor.green, iconColor.blue, 0.1),
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
                      child: Text(title, style: TextStyle(fontSize: 14, fontWeight: isRead ? FontWeight.w500 : FontWeight.w700, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
                    ),
                    if (!isRead)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryCyan, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                if (date != null) ...[const SizedBox(height: 8), Text(_formatDate(date), style: TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontFamily: 'Mulish'))],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${context.tr('minutes_ago')}';
    if (diff.inHours < 24) return '${diff.inHours} ${context.tr('hours_ago')}';
    if (diff.inDays == 0) return context.tr('today');
    if (diff.inDays == 1) return context.tr('yesterday');
    return '${diff.inDays} ${context.tr('days_ago')}';
  }
}
