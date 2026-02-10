import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class CarWashDetailScreenNew extends StatefulWidget {
  const CarWashDetailScreenNew({Key? key}) : super(key: key);

  @override
  State<CarWashDetailScreenNew> createState() => _CarWashDetailScreenNewState();
}

class _CarWashDetailScreenNewState extends State<CarWashDetailScreenNew> {
  int _currentImageIndex = 0;
  bool _isLoading = true;
  bool _descExpanded = false;
  Map<String, dynamic>? _partner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_partner == null) _loadPartnerData();
  }

  Future<void> _loadPartnerData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      setState(() { _partner = args; _isLoading = false; });
      return;
    }
    String? partnerId;
    if (args is String) partnerId = args;
    if (partnerId != null) {
      try {
        final data = await FullApiService.get('/api/mobile/car-washes/$partnerId');
        if (mounted && data.statusCode == 200) {
          setState(() { _partner = data.data is Map ? data.data['partner'] ?? data.data : null; _isLoading = false; });
          return;
        }
      } catch (_) {}
    }
    try {
      final data = await FullApiService.get('/api/mobile/car-washes/nearby', queryParameters: {'latitude': 41.311, 'longitude': 69.279});
      if (mounted && data.statusCode == 200) {
        final partners = data.data['partners'] as List?;
        if (partners != null && partners.isNotEmpty) {
          setState(() { _partner = partners.first; _isLoading = false; });
          return;
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final p = _partner ?? {};
    final name = p['name'] ?? 'Car Wash';
    final description = (p['description'] ?? '') as String;
    final address = p['address'] ?? '';
    final phone = p['phone_number'] ?? '+998 93 956 6961';
    final rating = (p['rating'] ?? 5.0).toDouble();
    final isPremium = p['is_premium'] == true;
    final isOpen = p['is_open'] != false;
    final workingHours = p['working_hours'];
    final lat = p['latitude'];
    final lng = p['longitude'];
    final imageUrl = p['image_url'] ?? p['photo_url'] ?? p['logo_url'] ?? '';
    final galleryUrls = (p['gallery_urls'] as List?)?.cast<String>() ?? [];
    final allImages = <String>[
      if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) imageUrl,
      ...galleryUrls.where((u) => u.startsWith('http')),
    ];

    final defaultDesc = '$name bu shunchaki avtoyuvish shoxobchasi emas, bu sizning avtomobilingizga bo\'lgan hurmatimiz namunasidir. Biz eng zamonaviy texnologiyalar va premium sifatli kimyoviy vositalar yordamida avtomobilingizni yangiday ko\'rinishga keltiramiz. Har bir detal biz uchun muhim!';
    final descText = description.isNotEmpty ? description : defaultDesc;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with carousel
                _buildHeroImage(allImages),

                // Content overlapping image
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges row
                          _buildBadges(isPremium, isOpen),
                          const SizedBox(height: 16),

                          // Name
                          Text(
                            name,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                          ),
                          const SizedBox(height: 8),

                          // Description with expand
                          _buildDescription(descText),
                          const SizedBox(height: 20),

                          // Info cards: wash time + rating
                          _buildInfoCards(rating),
                          const SizedBox(height: 16),

                          // Phone
                          _buildPhoneRow(phone),

                          // Divider
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 24),

                          // Qulayliklari
                          if (_getAmenities(p).isNotEmpty) ...[
                            const Text('Qulayliklari', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                            const SizedBox(height: 16),
                            ..._getAmenities(p).map((a) => _buildBorderedItem(_amenityIcon(a), a)),

                            // Divider
                            const SizedBox(height: 24),
                            const Divider(height: 1, color: Color(0xFFF0F0F0)),
                            const SizedBox(height: 24),
                          ],

                          // Qo'shimcha servislar
                          if (_getAdditionalServices(p).isNotEmpty) ...[
                            const Text('Qo\'shimcha servislar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                            const SizedBox(height: 16),
                            ..._getAdditionalServices(p).map((s) => _buildBorderedItem(_serviceIcon(s), s)),
                            const SizedBox(height: 8),
                            Text(
                              'Qo\'shimcha servislar obuna tarifiga kirmaydi va alohida to\'lov talab qilinadi',
                              style: TextStyle(fontSize: 12, color: const Color(0xFF8F96A0), height: 1.4),
                            ),
                          ],

                          // Divider
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 24),

                          // Manzil (Address + Map)
                          const Text('Manzil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                          const SizedBox(height: 12),
                          _buildMapSection(lat, lng),
                          if (address.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFFFC3E3E), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(address, style: const TextStyle(fontSize: 14, color: Color(0xFF0A0C13), height: 1.4)),
                                ),
                              ],
                            ),
                          ],

                          // Divider
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 24),

                          // Ish vaqti
                          const Text('Ish vaqti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                          const SizedBox(height: 12),
                          _buildWorkingHoursRow('Dushanba - Juma', _getHours(workingHours, 'weekday')),
                          _buildWorkingHoursRow('Shanba', _getHours(workingHours, 'saturday')),
                          _buildWorkingHoursRow('Yakshanba', _getHours(workingHours, 'sunday')),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top bar (back, bookmark, share)
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleBtn(Icons.arrow_back, () => Navigator.pop(context)),
                    Row(
                      children: [
                        _buildCircleBtn(Icons.bookmark_border, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saqlanganlarga qo\'shildi'), duration: Duration(seconds: 1)),
                          );
                        }),
                        const SizedBox(width: 12),
                        _buildCircleBtn(Icons.ios_share, () {
                          final shareText = '$name - $address\nYuvGO ilovasida ko\'ring!';
                          Clipboard.setData(ClipboardData(text: shareText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nusxalandi!'), duration: Duration(seconds: 1)),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _buildBottomBar(lat, lng),
          ),
        ],
      ),
    );
  }

  // ─── Hero Image ───
  Widget _buildHeroImage(List<String> images) {
    final imageCount = images.isEmpty ? 1 : images.length;
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: imageCount,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemBuilder: (context, index) {
              if (images.isNotEmpty && index < images.length) {
                return Image.network(images[index], fit: BoxFit.cover, width: double.infinity,
                  errorBuilder: (_, __, ___) => _fallbackImage());
              }
              return _fallbackImage();
            },
          ),
          // Carousel dots (only show if more than 1 image)
          if (imageCount > 1)
            Positioned(
              bottom: 36,
              left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageCount, (i) => Container(
                  width: i == _currentImageIndex ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _currentImageIndex ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/194b66145883c040db1229c8b27859f09f39f78f.png',
      fit: BoxFit.cover, width: double.infinity,
      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A2332)),
    );
  }

  // ─── Badges ───
  Widget _buildBadges(bool isPremium, bool isOpen) {
    return Row(
      children: [
        if (isPremium) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0C13),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                const Text('PREMIUM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOpen ? const Color(0xFF5CCC27).withOpacity(0.15) : const Color(0xFFFC3E3E).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 14, color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E)),
              const SizedBox(width: 4),
              Text(
                isOpen ? '24/7 OCHIQ' : 'YOPIQ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E), fontFamily: 'Mulish'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Description with expand ───
  Widget _buildDescription(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: _descExpanded ? text : (text.length > 120 ? '${text.substring(0, 120)}...' : text),
                style: const TextStyle(fontSize: 14, color: Color(0xFF646D79), height: 1.5, fontFamily: 'Mulish'),
              ),
              if (text.length > 120)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => setState(() => _descExpanded = !_descExpanded),
                    child: Text(
                      _descExpanded ? ' yashirish' : 'ko\'rsatish',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0A0C13), fontFamily: 'Mulish'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Info Cards ───
  Widget _buildInfoCards(double rating) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.directions_car_outlined, size: 20, color: Color(0xFF0A0C13)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('~60 min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                    Text('YUVISH VAQTI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF8F96A0), letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.star, size: 20, color: const Color(0xFFFFB800)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                        const SizedBox(width: 4),
                        Icon(Icons.info_outline, size: 14, color: const Color(0xFF8F96A0)),
                      ],
                    ),
                    Text('REYTING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF8F96A0), letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Phone Row ───
  Widget _buildPhoneRow(String phone) {
    if (phone.isEmpty) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => _makePhoneCall(phone),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone_outlined, color: Color(0xFF00BFFE), size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phone, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                const Text('QO\'NG\'IROQ QILISH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF00BFFE), fontFamily: 'Mulish', letterSpacing: 0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bordered list item ───
  Widget _buildBorderedItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF0A0C13)),
          const SizedBox(width: 14),
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        ],
      ),
    );
  }

  // ─── Map Section ───
  Widget _buildMapSection(dynamic lat, dynamic lng) {
    final hasCoords = lat != null && lng != null;
    final mapUrl = hasCoords
        ? 'https://static-maps.yandex.ru/v1?ll=${lng},${lat}&z=15&size=600,300&l=map&pt=${lng},${lat},pm2rdm'
        : '';

    return GestureDetector(
      onTap: () {
        if (hasCoords) _showMapPicker(lat, lng);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 180,
          width: double.infinity,
          color: const Color(0xFFF5F7FA),
          child: hasCoords && mapUrl.isNotEmpty
              ? Image.network(mapUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.map_outlined, size: 48, color: Color(0xFFCCCCCC))))
              : const Center(child: Icon(Icons.map_outlined, size: 48, color: Color(0xFFCCCCCC))),
        ),
      ),
    );
  }

  // ─── Map Picker Dialog ───
  void _showMapPicker(dynamic lat, dynamic lng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Qaysi ilovada ko\'rishni xohlaysiz?', style: TextStyle(fontSize: 15, color: const Color(0xFF8F96A0))),
              const SizedBox(height: 8),
              _mapOption('YandexMap', () {
                Navigator.pop(ctx);
                launchUrl(Uri.parse('yandexmaps://maps.yandex.ru/?pt=$lng,$lat&z=15'), mode: LaunchMode.externalApplication);
              }),
              const Divider(height: 1),
              _mapOption('Google Map', () {
                Navigator.pop(ctx);
                launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'));
              }),
              const Divider(height: 1),
              _mapOption('Maps', () {
                Navigator.pop(ctx);
                launchUrl(Uri.parse('https://maps.apple.com/?daddr=$lat,$lng'));
              }),
              const SizedBox(height: 8),
              const Divider(height: 1),
              _mapOption('Ortga', () => Navigator.pop(ctx), isBold: true),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapOption(String label, VoidCallback onTap, {bool isBold = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isBold ? const Color(0xFF0A0C13) : const Color(0xFF00BFFE),
              fontFamily: 'Mulish',
            ),
          ),
        ),
      ),
    );
  }

  // ─── Working Hours ───
  String _getHours(dynamic workingHours, String type) {
    if (workingHours is Map) {
      return workingHours[type] ?? '08:00 - 02:00';
    }
    return '08:00 - 02:00';
  }

  Widget _buildWorkingHoursRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
          Text(hours, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
        ],
      ),
    );
  }

  // ─── Bottom Bar ───
  Widget _buildBottomBar(dynamic lat, dynamic lng) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Marshrut button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (lat != null && lng != null) _showMapPicker(lat, lng);
                },
                icon: const Icon(Icons.navigation_outlined, size: 18),
                label: const Text('Marshrut', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0C13),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // QR / Obuna button
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/qr'),
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('QR kodni skanerlash', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD600),
                    foregroundColor: const Color(0xFF0A0C13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Circle Button ───
  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: Colors.white, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF0A0C13)),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    try { await launchUrl(url); } catch (_) {}
  }

  // ─── Amenities & Services helpers ───
  List<String> _getAmenities(Map p) {
    final raw = p['amenities'];
    if (raw is List) return raw.cast<String>();
    return [];
  }

  List<String> _getAdditionalServices(Map p) {
    final raw = p['additional_services'];
    if (raw is List) return raw.cast<String>();
    return [];
  }

  IconData _amenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kutish') || lower.contains('zal')) return Icons.weekend_outlined;
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi;
    if (lower.contains('o\'yin') || lower.contains('game')) return Icons.sports_esports_outlined;
    if (lower.contains('do\'kon') || lower.contains('shop') || lower.contains('market')) return Icons.store_outlined;
    if (lower.contains('cafe') || lower.contains('kofe') || lower.contains('choy')) return Icons.local_cafe_outlined;
    if (lower.contains('tualet') || lower.contains('wc')) return Icons.wc_outlined;
    if (lower.contains('parking') || lower.contains('avto')) return Icons.local_parking_outlined;
    if (lower.contains('bolalar') || lower.contains('child')) return Icons.child_care_outlined;
    if (lower.contains('namoz') || lower.contains('masjid')) return Icons.mosque_outlined;
    return Icons.check_circle_outline;
  }

  IconData _serviceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('detail')) return Icons.auto_awesome_outlined;
    if (lower.contains('ustaxona') || lower.contains('repair')) return Icons.build_outlined;
    if (lower.contains('moy') || lower.contains('oil')) return Icons.oil_barrel_outlined;
    if (lower.contains('yoqilg\'i') || lower.contains('benzin') || lower.contains('gas')) return Icons.local_gas_station_outlined;
    if (lower.contains('elektr') || lower.contains('zaryadlash') || lower.contains('ev')) return Icons.ev_station_outlined;
    if (lower.contains('polish') || lower.contains('sayqal')) return Icons.auto_fix_high_outlined;
    if (lower.contains('shina') || lower.contains('tire')) return Icons.tire_repair_outlined;
    if (lower.contains('tonirovka') || lower.contains('tint')) return Icons.filter_frames_outlined;
    return Icons.miscellaneous_services_outlined;
  }
}
