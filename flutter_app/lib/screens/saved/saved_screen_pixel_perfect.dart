import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
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
  double _userLat = 41.311;
  double _userLng = 69.279;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _loadFavorites();
  }

  Future<void> _loadLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).timeout(const Duration(seconds: 5));
        if (mounted) setState(() { _userLat = pos.latitude; _userLng = pos.longitude; });
      }
    } catch (_) {}
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoritesService.getFavorites();
    if (mounted) setState(() { _favorites = favs; _isLoading = false; });
  }

  Future<void> _removeFavorite(String id) async {
    await FavoritesService.removeFavorite(id);
    await _loadFavorites();
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  String _getDistance(Map<String, dynamic> p) {
    if (p['distance'] != null) {
      final d = (p['distance'] as num).toDouble();
      return d < 1 ? '${(d * 1000).toInt()} m' : '${d.toStringAsFixed(1)} km';
    }
    final lat = double.tryParse(p['latitude']?.toString() ?? '');
    final lng = double.tryParse(p['longitude']?.toString() ?? '');
    if (lat != null && lng != null) {
      final d = _haversine(_userLat, _userLng, lat, lng);
      return d < 1 ? '${(d * 1000).toInt()} m' : '${d.toStringAsFixed(1)} km';
    }
    return '';
  }

  String _getStatusText(Map<String, dynamic> p) {
    final isOpen = p['is_open'] == true;
    final is24h = p['is_24_hours'] == true;
    if (is24h) return '24/7 OCHIQ';
    final closeTime = p['closing_time']?.toString() ?? p['close_time']?.toString() ?? '';
    final openTime = p['opening_time']?.toString() ?? p['open_time']?.toString() ?? '';
    if (isOpen && closeTime.isNotEmpty) {
      final t = closeTime.length >= 5 ? closeTime.substring(0, 5) : closeTime;
      return '$t GACHA OCHIQ';
    }
    if (!isOpen && openTime.isNotEmpty) {
      final t = openTime.length >= 5 ? openTime.substring(0, 5) : openTime;
      return 'YOPIQ $t GACHA';
    }
    return isOpen ? 'GACHA OCHIQ' : 'YOPIQ';
  }

  Color _getStatusColor(Map<String, dynamic> p) {
    final isOpen = p['is_open'] == true;
    final is24h = p['is_24_hours'] == true;
    if (is24h) return const Color(0xFF5CCC27);
    return isOpen ? AppTheme.primaryCyan : const Color(0xFFFC3E3E);
  }

  String _getImageUrl(Map<String, dynamic> p) {
    final banner = (p['banner_url'] ?? '').toString();
    if (banner.isNotEmpty && banner.startsWith('http')) return banner;
    final img = (p['image_url'] ?? p['logo_url'] ?? p['photo_url'] ?? '').toString();
    if (img.isNotEmpty && img.startsWith('http')) return img;
    final gallery = p['gallery_urls'];
    if (gallery is List && gallery.isNotEmpty) {
      final first = gallery.first.toString();
      if (first.startsWith('http')) return first;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                              const Text('Saqlanganlar yo\'q', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
                              const SizedBox(height: 8),
                              const Text('Sevimli avtomoykalarni saqlang', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          itemCount: _favorites.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                          itemBuilder: (context, index) => _buildCard(_favorites[index]),
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
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 16, top: 0, bottom: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Center(child: Icon(Icons.arrow_back, size: 24, color: AppTheme.textPrimary)),
            ),
          ),
          const Center(
            child: Text(
              'Saqlanganlar',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> p) {
    final name = (p['name'] ?? 'Avtomoyqa').toString();
    final address = (p['address'] ?? '').toString();
    final rating = double.tryParse(p['rating']?.toString() ?? '') ?? 4.5;
    final distance = _getDistance(p);
    final statusText = _getStatusText(p);
    final statusColor = _getStatusColor(p);
    final imageUrl = _getImageUrl(p);
    final partnerId = p['id']?.toString() ?? '';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/car-wash-detail', arguments: p),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rating badge
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1A2332),
                            child: const Center(child: Icon(Icons.local_car_wash, size: 48, color: Colors.white38)),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF1A2332),
                          child: const Center(child: Icon(Icons.local_car_wash, size: 48, color: Colors.white38)),
                        ),
                  // Rating badge
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFD600)),
                          const SizedBox(width: 4),
                          Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Status badge
          Row(
            children: [
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                child: const Icon(Icons.access_time, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor, fontFamily: 'Mulish')),
            ],
          ),
          const SizedBox(height: 6),
          // Name
          Text(name, style: const TextStyle(color: Color(0xFF0A0C13), fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
          if (address.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(address, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'Mulish'), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (distance.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryCyan),
                const SizedBox(width: 4),
                Text(distance, style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Mulish')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
