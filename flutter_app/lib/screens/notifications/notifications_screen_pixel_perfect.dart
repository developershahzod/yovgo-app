import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class NotificationsScreenPixelPerfect extends StatefulWidget {
  const NotificationsScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  State<NotificationsScreenPixelPerfect> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreenPixelPerfect> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await FullApiService.getNotifications(limit: 50);
      if (mounted) {
        setState(() {
          _notifications = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await FullApiService.markAllNotificationsRead();
      setState(() {
        for (var n in _notifications) {
          n['is_read'] = true;
        }
      });
    } catch (_) {}
  }

  Future<void> _openNotification(Map<String, dynamic> notif) async {
    // Mark as read
    final id = notif['id']?.toString();
    if (id != null && notif['is_read'] != true) {
      try {
        await FullApiService.markNotificationRead(id);
        setState(() => notif['is_read'] = true);
      } catch (_) {}
    }
    // Navigate to detail
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => _NotificationDetailScreen(notification: notif),
      ));
    }
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) return '${context.tr('day_today')}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      if (diff.inDays == 1) return '${context.tr('day_yesterday')}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      if (diff.inDays < 7) return '${diff.inDays} ${context.tr('notif_days_ago')}';
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  IconData _notifIcon(String? type) {
    switch (type) {
      case 'promotion': return Icons.local_offer;
      case 'subscription': return Icons.workspace_premium;
      case 'payment': return Icons.payment;
      case 'visit': return Icons.local_car_wash;
      case 'update': return Icons.system_update;
      default: return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadNotifications,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              final n = _notifications[index];
                              return _buildNotificationItem(n);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppTheme.primaryCyan.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_off_outlined, size: 56, color: AppTheme.primaryCyan),
          ),
          const SizedBox(height: 20),
          Text(context.tr('notif_empty'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(context.tr('notif_empty_desc'), style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final unreadCount = _notifications.where((n) => n['is_read'] != true).length;
    return Container(
      height: 56,
      decoration: BoxDecoration(color: AppTheme.white.withOpacity(0.85)),
      child: Stack(
        children: [
          Positioned(
            left: 16, top: 0, bottom: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Center(child: Icon(Icons.arrow_back, size: 24, color: AppTheme.textPrimary)),
            ),
          ),
          Center(
            child: Text(context.tr('notif_title'), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 16, top: 0, bottom: 0,
              child: GestureDetector(
                onTap: _markAllRead,
                child: const Center(child: Icon(Icons.done_all, size: 24, color: AppTheme.primaryCyan)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> n) {
    final title = (n['title'] ?? '').toString();
    final body = (n['body'] ?? n['message'] ?? n['description'] ?? '').toString();
    final time = _formatTime((n['created_at'] ?? n['sent_at'] ?? '').toString());
    final isRead = n['is_read'] == true;
    final type = (n['type'] ?? n['notification_type'] ?? '').toString();

    return GestureDetector(
      onTap: () => _openNotification(n),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : AppTheme.primaryCyan.withOpacity(0.03),
          border: const Border(bottom: BorderSide(color: AppTheme.lightGray, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isRead ? AppTheme.lightGray : AppTheme.primaryCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_notifIcon(type), size: 24, color: isRead ? AppTheme.textSecondary : AppTheme.primaryCyan),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isRead) ...[
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.red, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(title, style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: isRead ? FontWeight.w600 : FontWeight.w900, fontFamily: 'Mulish', height: 1.2), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(body, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Mulish', height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'Mulish')),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Detail Screen ───
class _NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notification;
  const _NotificationDetailScreen({required this.notification});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final months = ['yanvar','fevral','mart','aprel','may','iyun','iyul','avgust','sentabr','oktabr','noyabr','dekabr'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'promotion': return Icons.local_offer;
      case 'subscription': return Icons.workspace_premium;
      case 'payment': return Icons.payment;
      case 'visit': return Icons.local_car_wash;
      case 'update': return Icons.system_update;
      default: return Icons.notifications_outlined;
    }
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'promotion': return Colors.orange;
      case 'subscription': return Colors.purple;
      case 'payment': return Colors.green;
      case 'visit': return AppTheme.primaryCyan;
      case 'update': return Colors.blue;
      default: return AppTheme.primaryCyan;
    }
  }

  String _typeLabel(String? type) {
    switch (type) {
      case 'promotion': return 'Aksiya';
      case 'subscription': return 'Obuna';
      case 'payment': return 'To\'lov';
      case 'visit': return 'Tashrif';
      case 'update': return 'Yangilanish';
      default: return 'Bildirishnoma';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = (notification['title'] ?? '').toString();
    final body = (notification['body'] ?? notification['message'] ?? notification['description'] ?? '').toString();
    final date = _formatDate((notification['created_at'] ?? notification['sent_at'] ?? '').toString());
    final type = (notification['type'] ?? notification['notification_type'] ?? '').toString();
    final color = _typeColor(type);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.tr('notif_detail'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge + date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_typeIcon(type), size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(_typeLabel(type), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color, fontFamily: 'Mulish')),
                    ],
                  ),
                ),
                const Spacer(),
                Text(date, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
              ],
            ),
            const SizedBox(height: 24),

            // Icon
            Center(
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(_typeIcon(type), size: 40, color: color),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: AppTheme.textPrimary, height: 1.3)),
            const SizedBox(height: 16),

            // Divider
            const Divider(height: 1, color: AppTheme.lightGray),
            const SizedBox(height: 16),

            // Body
            Text(body, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Mulish', color: AppTheme.textPrimary, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
