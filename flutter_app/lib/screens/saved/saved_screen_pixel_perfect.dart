import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SavedScreenPixelPerfect extends StatelessWidget {
  const SavedScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(context),
            // Saved car washes list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSavedCarWashCard(
                    name: 'Black Star Car Wash',
                    address: 'Matbuotchilar Street 32, Tashkent',
                    distance: '500 m',
                    rating: 4.6,
                    status: '22:00 gacha ochiq',
                    statusColor: AppTheme.primaryCyan,
                    statusBgColor: AppTheme.lightCyan,
                    context: context,
                  ),
                  const SizedBox(height: 16),
                  _buildSavedCarWashCard(
                    name: 'Wash N Go Car Wash',
                    address: 'Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent',
                    distance: '900 m',
                    rating: 4.6,
                    status: 'Yopiq 8:00 gacha',
                    statusColor: AppTheme.red,
                    statusBgColor: AppTheme.lightRed,
                    context: context,
                  ),
                  const SizedBox(height: 100),
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
              'Saqlanganlar',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCarWashCard({
    required String name,
    required String address,
    required String distance,
    required double rating,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/car-wash-detail'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/194b66145883c040db1229c8b27859f09f39f78f.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.lightGray,
                      );
                    },
                  ),
                ),
                // Rating badge
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.yellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Status badge
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Name
          Text(
            name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              fontFamily: 'Mulish',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Address
          Text(
            address,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Mulish',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Distance
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppTheme.primaryCyan,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(
                  color: AppTheme.primaryCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
