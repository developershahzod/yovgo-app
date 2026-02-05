import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class NotificationsScreenPixelPerfect extends StatelessWidget {
  const NotificationsScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(context),
            // Notifications list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildNotificationItem(
                    title: 'Yangi yil chegirmasi!',
                    description: 'YUVGO da yangi yil chegirmasiga ega bo\'ling.',
                    time: 'Bugun, 16:27',
                    isNew: true,
                    hasImage: true,
                    imageType: 'discount',
                  ),
                  _buildNotificationItem(
                    title: 'Yangilanish!',
                    description: 'Endilikda ilovada 1tadan ortiq mashinalaringizni bir vaqtda registratsiya qila olasiz',
                    time: 'Kecha, 14:20',
                    isNew: false,
                    hasImage: true,
                    imageType: 'update',
                  ),
                  _buildNotificationItem(
                    title: '120 000 so\'m tejaldi!',
                    description: 'Siz obuna orqali 120 000 so\'m tejadingiz',
                    time: '29.09.2024, 14:20',
                    isNew: false,
                    hasImage: false,
                  ),
                  _buildNotificationItem(
                    title: 'Premium obunangiz tez orada tugaydi.',
                    description: 'Premium imkoniyatlarni yo\'qotmaslik uchun obunani yangilashni unutmang. 😊',
                    time: '18.09.2024, 14:20',
                    isNew: false,
                    hasImage: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.85),
      ),
      child: Stack(
        children: [
          // Back button
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          // Title
          const Center(
            child: Text(
              'Bildirishnomalar',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ),
          // Read all button
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {},
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.done_all,
                    size: 24,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String time,
    required bool isNew,
    bool hasImage = false,
    String? imageType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.lightGray, width: 0.5),
          bottom: BorderSide(color: AppTheme.lightGray, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with new indicator
                Row(
                  children: [
                    if (isNew) ...[
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppTheme.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mulish',
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Time
                Text(
                  time,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                  ),
                ),
              ],
            ),
          ),
          // Image
          if (hasImage) ...[
            const SizedBox(width: 16),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: imageType == 'discount' 
                    ? AppTheme.primaryCyan.withOpacity(0.2)
                    : AppTheme.lightCyan,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  imageType == 'discount' 
                      ? Icons.local_offer
                      : Icons.system_update,
                  size: 32,
                  color: AppTheme.primaryCyan,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
