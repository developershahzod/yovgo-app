import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

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
          'Saqlanganlar',
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
          _buildSavedCarWashCard(
            context,
            name: 'Black Star Car Wash',
            address: 'Motouruchilar Street 32, Tashkent',
            distance: '500 m',
            rating: 4.6,
            status: '22:00 GACHA OCHIQ',
            statusColor: AppTheme.green,
            openTime: '22:00 GACHA OCHIQ',
          ),
          const SizedBox(height: 12),
          _buildSavedCarWashCard(
            context,
            name: 'Wash N Go Car Wash',
            address: 'Tutror mahallasi, 35 uy, Chilonzor, 100174',
            distance: '900 m',
            rating: 4.6,
            status: 'YOPIQ 8:00 GACHA',
            statusColor: AppTheme.red,
            openTime: 'YOPIQ 8:00 GACHA',
          ),
          const SizedBox(height: 12),
          _buildSavedCarWashCard(
            context,
            name: 'DJ Car Wash',
            address: 'Gim-dador ko\'chasi 28, Toshkent',
            distance: '1.2 km',
            rating: 4.8,
            status: '22:00 GACHA OCHIQ',
            statusColor: AppTheme.green,
            openTime: '22:00 GACHA OCHIQ',
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCarWashCard(
    BuildContext context, {
    required String name,
    required String address,
    required String distance,
    required double rating,
    required String status,
    required Color statusColor,
    required String openTime,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/car-wash-detail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 14, color: AppTheme.yellow),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: AppTheme.primaryCyan,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.location_on, size: 12, color: AppTheme.primaryCyan),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
