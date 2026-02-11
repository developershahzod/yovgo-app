import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class MapScreenNew extends StatefulWidget {
  const MapScreenNew({Key? key}) : super(key: key);

  @override
  State<MapScreenNew> createState() => _MapScreenNewState();
}

class _MapScreenNewState extends State<MapScreenNew> {
  bool _showLocationDialog = false;
  String _selectedFilter = '';
  List<Map<String, dynamic>> _carWashes = [];
  List<Map<String, dynamic>> _filteredCarWashes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final PanelController _panelController = PanelController();
  final FocusNode _searchFocusNode = FocusNode();
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(41.2995, 69.2401);
  Set<Marker> _markers = {};
  double _dragStartY = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCarWashes();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && _panelController.isAttached) {
        _panelController.animatePanelToPosition(0.5, duration: const Duration(milliseconds: 300));
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
          _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
          // Reload car washes with actual location
          _loadCarWashes();
        }
      }
    } catch (_) {}
  }

  Future<void> _loadCarWashes() async {
    try {
      final resp = await FullApiService.get('/api/mobile/car-washes/nearby', queryParameters: {
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
        'radius_km': 50,
        'limit': 50,
      });
      if (mounted && resp.statusCode == 200) {
        final partners = (resp.data['partners'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        setState(() {
          _carWashes = partners;
          _filteredCarWashes = partners;
          _isLoading = false;
        });
        _buildMarkers();
      }
    } catch (_) {}
    if (mounted && _isLoading) setState(() => _isLoading = false);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = _selectedFilter == filter ? '' : filter;
      _filteredCarWashes = _carWashes.where((p) {
        if (_selectedFilter == '24/7') return p['is_24_hours'] == true;
        if (_selectedFilter == 'open') return p['is_open'] == true;
        if (_selectedFilter == 'premium') return p['is_premium'] == true;
        return true;
      }).toList();
      if (_selectedFilter == 'nearest') {
        _filteredCarWashes.sort((a, b) => ((a['distance'] ?? 999) as num).compareTo((b['distance'] ?? 999) as num));
      } else if (_selectedFilter == 'rating') {
        _filteredCarWashes.sort((a, b) => ((b['rating'] ?? 0) as num).compareTo((a['rating'] ?? 0) as num));
      }
    });
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCarWashes = _carWashes;
      } else {
        _filteredCarWashes = _carWashes.where((p) {
          final name = (p['name'] ?? '').toString().toLowerCase();
          final addr = (p['address'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase()) || addr.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = screenHeight * 0.22;
    final maxHeight = screenHeight * 0.92;

    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: minHeight,
        maxHeight: maxHeight,
        parallaxEnabled: true,
        parallaxOffset: 0.3,
        isDraggable: true,
        backdropEnabled: true,
        backdropOpacity: 0.3,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
        panelBuilder: (scrollController) => _buildPanel(scrollController),
        body: Stack(
          children: [
            // Map - no GestureDetector wrapper so zoom/pan works on iOS
            _buildMapView(),
            // My Location Button
            Positioned(
              right: 16,
              bottom: minHeight + 16,
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: IconButton(
                  icon: Icon(Icons.my_location, color: AppTheme.primaryCyan, size: 22),
                  onPressed: () => _getCurrentLocation(),
                ),
              ),
            ),
            // Location Permission Dialog
            if (_showLocationDialog) _buildLocationDialog(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.zero,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search_rounded, color: AppTheme.primaryCyan, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _onSearch,
                      onTap: () {
                        if (_panelController.isAttached) {
                          _panelController.animatePanelToPosition(0.5, duration: const Duration(milliseconds: 300));
                        }
                      },
                      style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: context.tr('map_search'),
                        hintStyle: TextStyle(color: const Color(0xFFADB5BD), fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 20),
                      onPressed: () { _searchController.clear(); _onSearch(''); },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('premium', 'Premium', Icons.workspace_premium, AppTheme.darkNavy),
                const SizedBox(width: 8),
                _buildFilterChip('24/7', '24/7', Icons.access_time, AppTheme.green),
                const SizedBox(width: 8),
                _buildFilterChip('open', context.tr('map_open_now'), Icons.schedule, AppTheme.primaryCyan),
                const SizedBox(width: 8),
                _buildFilterChip('nearest', context.tr('map_nearby'), Icons.near_me, AppTheme.primaryCyan),
                const SizedBox(width: 8),
                _buildFilterChip('rating', context.tr('detail_rating'), Icons.star, AppTheme.yellow),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Car wash list
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
          else if (_filteredCarWashes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text(context.tr('saved_empty'), style: TextStyle(color: AppTheme.textSecondary, fontSize: 15))),
            )
          else
            ..._filteredCarWashes.map((p) => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: _buildCarWashCard(p),
            )),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _buildMarkers() {
    final markers = <Marker>{};
    for (final p in _carWashes) {
      final lat = (p['latitude'] as num?)?.toDouble();
      final lng = (p['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) continue;
      final locId = p['location_id']?.toString();
      final id = locId ?? p['id']?.toString() ?? '';
      final markerKey = '${id}_${lat}_${lng}';
      markers.add(Marker(
        markerId: MarkerId(markerKey),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: p['name'] ?? 'Car Wash',
          snippet: p['address'] ?? '',
          onTap: () => Navigator.pushNamed(context, '/car-wash-detail', arguments: p),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      ));
    }
    if (mounted) setState(() => _markers = markers);
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 13,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
    );
  }

  Widget _buildMapMarker(String name, double rating) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.darkNavy,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryCyan, size: 14),
              const SizedBox(width: 3),
              Text(
                name.length > 12 ? '${name.substring(0, 12)}...' : name,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Icon(Icons.star, color: AppTheme.yellow, size: 10),
              const SizedBox(width: 2),
              Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        // Arrow
        CustomPaint(size: const Size(12, 6), painter: _TrianglePainter(AppTheme.darkNavy)),
      ],
    );
  }

  Widget _buildFilterChip(String id, String label, IconData icon, Color color) {
    final isSelected = _selectedFilter == id;
    return GestureDetector(
      onTap: () => _applyFilter(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.textPrimary, fontFamily: 'Mulish')),
          ],
        ),
      ),
    );
  }

  Widget _buildCarWashCard(Map<String, dynamic> p) {
    final name = p['name'] ?? 'Car Wash';
    final address = p['address'] ?? '';
    final distance = p['distance'] != null ? '${(p['distance'] as num).toStringAsFixed(1)} km' : '';
    final rating = (p['rating'] ?? 0).toDouble();
    final isOpen = p['is_open'] == true;
    final status = p['status'] ?? (isOpen ? context.tr('detail_open') : context.tr('detail_closed'));

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/car-wash-detail', arguments: p),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _getCarWashImage(p),
                  ),
                  // Rating badge
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14, color: AppTheme.yellow),
                          const SizedBox(width: 3),
                          Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen ? AppTheme.primaryCyan : AppTheme.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(status.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Name
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(address, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            if (distance.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryCyan),
                  const SizedBox(width: 4),
                  Text(distance, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryCyan)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getCarWashImage(Map<String, dynamic> p) {
    final imageUrl = (p['banner_url'] ?? p['image_url'] ?? p['logo_url'] ?? p['photo_url'] ?? '').toString();
    final gallery = p['gallery_urls'];
    final firstGallery = (gallery is List && gallery.isNotEmpty) ? gallery.first.toString() : '';
    final url = imageUrl.isNotEmpty ? imageUrl : firstGallery;

    if (url.isNotEmpty && url.startsWith('http')) {
      return Image.network(
        url,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultCarWashImage(),
      );
    }
    return _defaultCarWashImage();
  }

  Widget _defaultCarWashImage() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2332),
        image: DecorationImage(
          image: AssetImage('assets/images/194b66145883c040db1229c8b27859f09f39f78f.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLocationDialog() {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Geolokatsiyangizga\nruxsat bering', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
              const SizedBox(height: 14),
              Text(
                'Sizga yaqin avtomoykalarni ko\'rishimiz uchun sozlamalarda joylashuv ma\'lumotiga ruxsat bering',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5, fontFamily: 'Mulish'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: OutlinedButton(
                  onPressed: () => setState(() => _showLocationDialog = false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Hozir emas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showLocationDialog = false),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryCyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  child: Text('Sozlamalarni ochish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Mulish')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD4D0C4)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    // Draw grid lines to simulate map
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw some "roads"
    final roadPaint = Paint()..color = const Color(0xFFCCC8BC)..strokeWidth = 3..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.35), roadPaint);
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.55), roadPaint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.65, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.5, size.height), roadPaint);
    // Green areas
    final greenPaint = Paint()..color = const Color(0xFFD4E8C4).withOpacity(0.5)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, size.height * 0.1, 80, 60), greenPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.7, 100, 50), greenPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
