import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/favorites_service.dart';

class SavedScreenPixelPerfect extends StatefulWidget {
  const SavedScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  State<SavedScreenPixelPerfect> createState() => _SavedScreenPixelPerfectState();
}

class _SavedScreenPixelPerfectState extends State<SavedScreenPixelPerfect> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoritesService.getFavorites();
    if (mounted) setState(() { _favorites = favs; _isLoading = false; });
  }

  Future<void> _removeFavorite(String id) async {
    await FavoritesService.removeFavorite(id);
    await _loadFavorites();
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
                  : _favorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_border, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text('Saqlanganlar yo\'q', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
                              const SizedBox(height: 8),
                              Text('Sevimli avtomoykalarni saqlang', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _favorites.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final f = _favorites[index];
                            return _buildSavedCarWashCard(
                              name: (f['name'] ?? 'Avtomoyqa').toString(),
                              address: (f['address'] ?? '').toString(),
                              distance: '',
                              rating: double.tryParse(f['rating']?.toString() ?? '') ?? 4.5,
                              status: f['is_open'] == true ? 'Ochiq' : 'Yopiq',
                              statusColor: f['is_open'] == true ? Colors.green : Colors.red,
                              statusBgColor: f['is_open'] == true ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              context: context,
                              partnerId: f['id']?.toString() ?? '',
                              partnerData: f,
                            );
                          },
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
    required String partnerId,
    Map<String, dynamic>? partnerData,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/car-wash-detail', arguments: partnerData),
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
                  child: (partnerData?['image_url'] ?? partnerData?['photo_url'] ?? '').toString().isNotEmpty
                      ? Image.network(
                          (partnerData?['image_url'] ?? partnerData?['photo_url'] ?? '').toString(),
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppTheme.lightGray, child: const Center(child: Icon(Icons.local_car_wash, size: 48, color: Colors.grey))),
                        )
                      : Container(color: AppTheme.lightGray, child: const Center(child: Icon(Icons.local_car_wash, size: 48, color: Colors.grey))),
                ),
                // Remove bookmark button
                Positioned(
                  right: 12,
                  top: 12,
                  child: GestureDetector(
                    onTap: () => _removeFavorite(partnerId),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.bookmark, color: AppTheme.primaryCyan, size: 20),
                    ),
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
