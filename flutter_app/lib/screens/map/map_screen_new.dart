import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';
import '../home/home_screen_fixed.dart';

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

  // Search state
  bool _isSearchActive = false;
  bool _hasSearched = false;
  List<String> _searchHistory = [];
  static const _historyKey = 'map_search_history';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCarWashes();
    _loadSearchHistory();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() => _isSearchActive = true);
        if (_panelController.isAttached) {
          _panelController.animatePanelToPosition(0.85, duration: const Duration(milliseconds: 300));
        }
      }
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey);
    if (mounted && raw != null) setState(() => _searchHistory = raw);
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, _searchHistory);
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    _searchHistory.remove(query.trim().toLowerCase());
    _searchHistory.insert(0, query.trim().toLowerCase());
    if (_searchHistory.length > 10) _searchHistory = _searchHistory.sublist(0, 10);
    _saveSearchHistory();
  }

  void _removeFromHistory(String query) {
    setState(() => _searchHistory.remove(query));
    _saveSearchHistory();
  }

  void _clearHistory() {
    setState(() => _searchHistory.clear());
    _saveSearchHistory();
  }

  Future<void> _getCurrentLocation() async {
    // Use shared location from HomeScreenFixed if already obtained
    final cachedLat = SharedLocationState.cachedLat;
    final cachedLng = SharedLocationState.cachedLng;
    final alreadyObtained = SharedLocationState.locationObtained;

    if (alreadyObtained) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(cachedLat, cachedLng);
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        _loadCarWashes();
      }
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      // Never request permission from map — home screen handles that
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ).timeout(const Duration(seconds: 8));
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
          _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
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
      _hasSearched = query.isNotEmpty;
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

  void _submitSearch(String query) {
    if (query.trim().isNotEmpty) {
      _addToHistory(query.trim());
    }
    _onSearch(query);
    setState(() => _isSearchActive = false);
    _searchFocusNode.unfocus();
  }

  void _selectHistoryItem(String query) {
    _searchController.text = query;
    _submitSearch(query);
  }

  void _exitSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    _onSearch('');
    setState(() { _isSearchActive = false; _hasSearched = false; });
    if (_panelController.isAttached) {
      _panelController.animatePanelToPosition(0.0, duration: const Duration(milliseconds: 300));
    }
  }

  List<String> _getMatchingHistory(String query) {
    if (query.isEmpty) return [];
    return _searchHistory.where((h) => h.contains(query.toLowerCase())).toList();
  }

  List<String> _getSuggestions(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _carWashes
        .map((p) => (p['name'] ?? '').toString())
        .where((n) => n.toLowerCase().contains(q))
        .toSet()
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = screenHeight * 0.22;
    final maxHeight = screenHeight * 0.68;

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
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 20, offset: Offset(0, -5))],
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
                  boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8, offset: Offset(0, 2))],
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: _onSearch,
                            onSubmitted: _submitSearch,
                            textInputAction: TextInputAction.search,
                            onTap: () {
                              setState(() => _isSearchActive = true);
                              if (_panelController.isAttached) {
                                _panelController.animatePanelToPosition(0.85, duration: const Duration(milliseconds: 300));
                              }
                            },
                            style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: context.tr('map_search'),
                              hintStyle: TextStyle(color: AppTheme.textTertiary, fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearch('');
                              setState(() => _hasSearched = false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 22, height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.textTertiary, width: 1.5),
                                ),
                                child: Icon(Icons.close, color: AppTheme.textTertiary, size: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _exitSearch,
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Search active: show history/suggestions/empty
          if (_isSearchActive) ...[
            _buildSearchContent(),
          ] else ...[
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
            else if (_hasSearched && _filteredCarWashes.isEmpty)
              _buildEmptySearchResult(_searchController.text)
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
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ─── Marker system ───
  double _currentZoom = 13.0;
  final Map<String, BitmapDescriptor> _labelIconCache = {};
  final Map<int, BitmapDescriptor> _clusterIcons = {};
  bool _isRebuildingMarkers = false;

  // Pixel ratio for sharp rendering
  double get _dpr => MediaQuery.of(context).devicePixelRatio.clamp(2.0, 3.0);

  /// Create a pill-shaped label marker: [📍 Name  ★ 4.8]
  Future<BitmapDescriptor> _createLabelIcon(String name, double rating, bool isPremium) async {
    final cacheKey = '${name}_${rating}_${isPremium}_${_dpr.toInt()}';
    if (_labelIconCache.containsKey(cacheKey)) return _labelIconCache[cacheKey]!;

    final dpr = _dpr;
    final displayName = name.length > 14 ? '${name.substring(0, 14)}…' : name;
    final ratingStr = rating > 0 ? rating.toStringAsFixed(1) : '';

    // Measure texts
    final namePainter = TextPainter(
      text: TextSpan(text: displayName, style: TextStyle(fontSize: 11 * dpr, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
      textDirection: TextDirection.ltr,
    )..layout();

    TextPainter? ratingPainter;
    if (ratingStr.isNotEmpty) {
      ratingPainter = TextPainter(
        text: TextSpan(text: ratingStr, style: TextStyle(fontSize: 11 * dpr, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
        textDirection: TextDirection.ltr,
      )..layout();
    }

    // Calculate dimensions
    final iconSize = 14 * dpr;
    final starSize = 12 * dpr;
    final hPad = 10 * dpr;
    final gap = 4 * dpr;
    final arrowH = 6 * dpr;

    double pillW = hPad + iconSize + gap + namePainter.width + hPad;
    if (ratingPainter != null) {
      pillW += gap * 2 + starSize + gap / 2 + ratingPainter.width;
    }
    final pillH = 28 * dpr;
    final totalW = pillW;
    final totalH = pillH + arrowH + 2 * dpr;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bgColor = isPremium ? const Color(0xFF00BFFE) : const Color(0xFF1A2332);
    final radius = pillH / 2;

    // Pill background
    final pillRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, pillW, pillH), Radius.circular(radius));
    canvas.drawRRect(pillRect, Paint()..color = bgColor);

    // Shadow effect (subtle)
    final shadowPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * dpr);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 2 * dpr, pillW, pillH), Radius.circular(radius)), shadowPaint);
    canvas.drawRRect(pillRect, Paint()..color = bgColor);

    // Location pin icon (simple circle + dot)
    final pinCx = hPad + iconSize / 2;
    final pinCy = pillH / 2;
    canvas.drawCircle(Offset(pinCx, pinCy - 1 * dpr), 5 * dpr, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(pinCx, pinCy - 1 * dpr), 2.2 * dpr, Paint()..color = bgColor);
    // Pin point
    final pinPath = Path()
      ..moveTo(pinCx - 3 * dpr, pinCy + 2.5 * dpr)
      ..lineTo(pinCx, pinCy + 6 * dpr)
      ..lineTo(pinCx + 3 * dpr, pinCy + 2.5 * dpr)
      ..close();
    canvas.drawPath(pinPath, Paint()..color = Colors.white);

    // Name text
    final nameX = hPad + iconSize + gap;
    final nameY = (pillH - namePainter.height) / 2;
    namePainter.paint(canvas, Offset(nameX, nameY));

    // Star + rating
    if (ratingPainter != null) {
      final starX = nameX + namePainter.width + gap * 2;
      final starY = (pillH - starSize) / 2;
      // Draw star
      _drawStar(canvas, Offset(starX + starSize / 2, starY + starSize / 2), starSize / 2, const Color(0xFFFFD600));
      // Rating text
      final rtX = starX + starSize + gap / 2;
      final rtY = (pillH - ratingPainter.height) / 2;
      ratingPainter.paint(canvas, Offset(rtX, rtY));
    }

    // Arrow pointer at bottom center
    final arrowPath = Path()
      ..moveTo(totalW / 2 - 6 * dpr, pillH)
      ..lineTo(totalW / 2, pillH + arrowH)
      ..lineTo(totalW / 2 + 6 * dpr, pillH)
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = bgColor);

    final picture = recorder.endRecording();
    final img = await picture.toImage(totalW.ceil(), totalH.ceil());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    final icon = BitmapDescriptor.bytes(data!.buffer.asUint8List());
    _labelIconCache[cacheKey] = icon;
    return icon;
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / 5;
      final innerAngle = angle + math.pi / 5;
      final outerX = center.dx + radius * math.cos(angle);
      final outerY = center.dy + radius * math.sin(angle);
      final innerX = center.dx + radius * 0.4 * math.cos(innerAngle);
      final innerY = center.dy + radius * 0.4 * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  /// Create cluster icon showing count
  Future<BitmapDescriptor> _createClusterIcon(int count) async {
    if (_clusterIcons.containsKey(count)) return _clusterIcons[count]!;
    final dpr = _dpr;
    final size = 48 * dpr;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Outer circle
    final outerPaint = Paint()..color = const Color(0xFF1A2332);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);
    // White border
    final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5 * dpr;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 1.25 * dpr, borderPaint);
    // Count text
    final tp = TextPainter(
      text: TextSpan(text: '$count', style: TextStyle(color: Colors.white, fontSize: 18 * dpr, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size - tp.width) / 2, (size - tp.height) / 2));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.ceil(), size.ceil());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    _clusterIcons[count] = BitmapDescriptor.bytes(data!.buffer.asUint8List());
    return _clusterIcons[count]!;
  }

  /// Get dynamic cluster threshold based on zoom level
  double _clusterThreshold() {
    // At zoom 10: 0.02 (~2km), at zoom 13: 0.004 (~400m), at zoom 15+: 0 (no clustering)
    if (_currentZoom >= 15.5) return 0.0; // No clustering at high zoom
    if (_currentZoom >= 14) return 0.001;
    if (_currentZoom >= 13) return 0.003;
    if (_currentZoom >= 12) return 0.006;
    if (_currentZoom >= 11) return 0.012;
    return 0.025;
  }

  void _onCameraIdle() async {
    if (_mapController == null) return;
    final zoom = await _mapController!.getZoomLevel();
    final oldThreshold = _clusterThreshold();
    _currentZoom = zoom;
    final newThreshold = _clusterThreshold();
    // Only rebuild if threshold changed
    if ((oldThreshold - newThreshold).abs() > 0.0001) {
      _buildMarkers();
    }
  }

  Future<void> _buildMarkers() async {
    if (_isRebuildingMarkers) return;
    _isRebuildingMarkers = true;

    try {
      final threshold = _clusterThreshold();
      final used = <int, bool>{};
      final clusters = <List<Map<String, dynamic>>>[];

      for (int i = 0; i < _carWashes.length; i++) {
        if (used[i] == true) continue;
        final lat = (_carWashes[i]['latitude'] as num?)?.toDouble();
        final lng = (_carWashes[i]['longitude'] as num?)?.toDouble();
        if (lat == null || lng == null) continue;

        final cluster = <Map<String, dynamic>>[_carWashes[i]];
        used[i] = true;

        if (threshold > 0) {
          for (int j = i + 1; j < _carWashes.length; j++) {
            if (used[j] == true) continue;
            final lat2 = (_carWashes[j]['latitude'] as num?)?.toDouble();
            final lng2 = (_carWashes[j]['longitude'] as num?)?.toDouble();
            if (lat2 == null || lng2 == null) continue;
            if ((lat - lat2).abs() < threshold && (lng - lng2).abs() < threshold) {
              cluster.add(_carWashes[j]);
              used[j] = true;
            }
          }
        }
        clusters.add(cluster);
      }

      final markers = <Marker>{};
      for (final cluster in clusters) {
        if (cluster.length == 1) {
          final p = cluster.first;
          final lat = (p['latitude'] as num).toDouble();
          final lng = (p['longitude'] as num).toDouble();
          final name = (p['name'] ?? '').toString();
          final rating = (p['rating'] as num?)?.toDouble() ?? 0.0;
          final isPremium = p['is_premium'] == true;
          final id = p['location_id']?.toString() ?? p['id']?.toString() ?? '$lat$lng';

          final icon = await _createLabelIcon(name, rating, isPremium);
          markers.add(Marker(
            markerId: MarkerId('label_$id'),
            position: LatLng(lat, lng),
            icon: icon,
            anchor: const Offset(0.5, 1.0),
            onTap: () => Navigator.pushNamed(context, '/car-wash-detail', arguments: p),
          ));
        } else {
          // Cluster marker
          double avgLat = 0, avgLng = 0;
          for (final p in cluster) {
            avgLat += (p['latitude'] as num).toDouble();
            avgLng += (p['longitude'] as num).toDouble();
          }
          avgLat /= cluster.length;
          avgLng /= cluster.length;
          final clusterIcon = await _createClusterIcon(cluster.length);
          markers.add(Marker(
            markerId: MarkerId('cluster_${avgLat.toStringAsFixed(5)}_${avgLng.toStringAsFixed(5)}'),
            position: LatLng(avgLat, avgLng),
            icon: clusterIcon,
            anchor: const Offset(0.5, 0.5),
            onTap: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(avgLat, avgLng), _currentZoom + 2),
              );
            },
          ));
        }
      }
      if (mounted) setState(() => _markers = markers);
    } finally {
      _isRebuildingMarkers = false;
    }
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
      onCameraIdle: _onCameraIdle,
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
        padding: const EdgeInsets.only(left: 4, right: 14, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? color : const Color(0xFFE8ECF0), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15, color: isSelected ? Colors.white : color),
            ),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.textPrimary, fontFamily: 'Mulish')),
          ],
        ),
      ),
    );
  }

  String _getStatusText(Map<String, dynamic> p) {
    // Use pre-computed status from API if available
    final apiStatus = p['status']?.toString() ?? '';
    if (apiStatus.isNotEmpty) return apiStatus;
    final isOpen = p['is_open'] == true;
    final is24h = p['is_24_hours'] == true;
    if (is24h) return context.tr('open_24_7');
    final wh = p['working_hours'];
    final closeTime = (wh is Map ? wh['close'] : null)?.toString() ?? p['closing_time']?.toString() ?? p['close_time']?.toString() ?? '';
    final openTime = (wh is Map ? wh['open'] : null)?.toString() ?? p['opening_time']?.toString() ?? p['open_time']?.toString() ?? '';
    if (isOpen && closeTime.isNotEmpty) {
      final t = closeTime.length >= 5 ? closeTime.substring(0, 5) : closeTime;
      return '${context.tr('open_until')} $t';
    }
    if (!isOpen && openTime.isNotEmpty) {
      final t = openTime.length >= 5 ? openTime.substring(0, 5) : openTime;
      return '${context.tr('closed_until')} $t';
    }
    return isOpen ? context.tr('status_open') : context.tr('status_closed');
  }

  Color _getStatusColor(Map<String, dynamic> p) {
    final isOpen = p['is_open'] == true;
    final is24h = p['is_24_hours'] == true;
    if (is24h) return const Color(0xFF5CCC27);
    return isOpen ? AppTheme.primaryCyan : const Color(0xFFFC3E3E);
  }

  Widget _buildCarWashCard(Map<String, dynamic> p) {
    final name = p['name'] ?? context.tr('car_wash_default');
    final address = p['address'] ?? '';
    final distNum = p['distance'] != null ? (p['distance'] as num).toDouble() : 0.0;
    final distance = distNum > 0
        ? (distNum < 1 ? '${(distNum * 1000).toInt()} m' : '${distNum.toStringAsFixed(1)} km')
        : '';
    final rating = (p['rating'] ?? 0).toDouble();
    final statusText = _getStatusText(p);
    final statusColor = _getStatusColor(p);

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
                  _getCarWashImage(p),
                  // Rating badge
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0, 0, 0.55),
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
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor, fontFamily: 'Mulish')),
            ],
          ),
          const SizedBox(height: 6),
          // Name
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
          if (address.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(address, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontFamily: 'Mulish'), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (distance.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryCyan),
                const SizedBox(width: 4),
                Text(distance, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryCyan, fontFamily: 'Mulish')),
              ],
            ),
          ],
        ],
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
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultCarWashImage(),
      );
    }
    return _defaultCarWashImage();
  }

  Widget _defaultCarWashImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2332),
        image: DecorationImage(
          image: AssetImage('assets/images/194b66145883c040db1229c8b27859f09f39f78f.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      // Show full history
      if (_searchHistory.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('search_history'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
                GestureDetector(
                  onTap: _clearHistory,
                  child: Text(context.tr('clear_all'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryCyan, fontFamily: 'Mulish')),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
              ),
              child: Column(
                children: _searchHistory.asMap().entries.map((entry) {
                  final i = entry.key;
                  final h = entry.value;
                  return Column(
                    children: [
                      if (i > 0) Divider(height: 1, color: const Color(0xFFE8ECF0)),
                      _buildHistoryItem(h),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    // Typing: show matching history + suggestions
    final matchingHistory = _getMatchingHistory(query);
    final suggestions = _getSuggestions(query)
        .where((s) => !matchingHistory.contains(s.toLowerCase()))
        .toList();

    if (matchingHistory.isEmpty && suggestions.isEmpty) {
      return _buildEmptySearchResult(query);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Matching history
          if (matchingHistory.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
              ),
              child: Column(
                children: matchingHistory.asMap().entries.map((entry) {
                  final i = entry.key;
                  final h = entry.value;
                  return Column(
                    children: [
                      if (i > 0) Divider(height: 1, color: const Color(0xFFE8ECF0)),
                      _buildHistoryItem(h),
                    ],
                  );
                }).toList(),
              ),
            ),
          if (matchingHistory.isNotEmpty && suggestions.isNotEmpty)
            const SizedBox(height: 10),
          // Suggestions
          if (suggestions.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
              ),
              child: Column(
                children: suggestions.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  return Column(
                    children: [
                      if (i > 0) Divider(height: 1, color: const Color(0xFFE8ECF0)),
                      _buildSuggestionItem(s, query),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    return GestureDetector(
      onTap: () => _selectHistoryItem(text),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 20, color: AppTheme.textTertiary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
            ),
            GestureDetector(
              onTap: () => _removeFromHistory(text),
              child: Text(context.tr('delete_item'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textTertiary, fontFamily: 'Mulish')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String name, String query) {
    final q = query.toLowerCase();
    final lower = name.toLowerCase();
    final matchStart = lower.indexOf(q);

    return GestureDetector(
      onTap: () {
        _searchController.text = name;
        _submitSearch(name);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: AppTheme.textTertiary),
            const SizedBox(width: 12),
            Expanded(
              child: matchStart >= 0
                  ? RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppTheme.textPrimary, fontFamily: 'Mulish'),
                        children: [
                          if (matchStart > 0) TextSpan(text: name.substring(0, matchStart)),
                          TextSpan(text: name.substring(matchStart, matchStart + q.length), style: const TextStyle(fontWeight: FontWeight.w800)),
                          if (matchStart + q.length < name.length) TextSpan(text: name.substring(matchStart + q.length)),
                        ],
                      ),
                    )
                  : Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchResult(String query) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 191, 254, 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 48, color: AppTheme.primaryCyan),
          ),
          const SizedBox(height: 24),
          Text(context.tr('nothing_found'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
          const SizedBox(height: 8),
          Text(
            '"$query" ${context.tr('nothing_found_desc')}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish', height: 1.4),
          ),
        ],
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
              Text(context.tr('location_permission_title'), textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, fontFamily: 'Mulish')),
              const SizedBox(height: 14),
              Text(
                context.tr('location_permission_desc'),
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
                  child: Text(context.tr('not_now'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showLocationDialog = false),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryCyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  child: Text(context.tr('open_settings'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Mulish')),
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
