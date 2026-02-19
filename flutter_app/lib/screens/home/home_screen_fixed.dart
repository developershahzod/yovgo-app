import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';
import '../../widgets/ios_weather_icon.dart';
import '../../widgets/permission_modal.dart';
import '../main_navigation_fixed.dart';

class HomeScreenFixed extends StatefulWidget {
  const HomeScreenFixed({Key? key}) : super(key: key);

  static final GlobalKey<_HomeScreenFixedState> globalKey = GlobalKey<_HomeScreenFixedState>();

  @override
  State<HomeScreenFixed> createState() => _HomeScreenFixedState();
}

class _HomeScreenFixedState extends State<HomeScreenFixed> {
  // Global shared location state — ask permission once across all screens
  bool _locationPermissionAsked = false;
  static bool _locationObtained = false;
  static double _cachedLat = 41.311;
  static double _cachedLng = 69.279;

  // Auth state
  bool _isLoggedIn = false;

  // Subscription data
  bool _hasSubscription = false;
  String _planName = '';
  String _endDate = '';
  int _usedVisits = 0;
  int _totalVisits = 0;
  int _savedAmount = 0;

  // Car washes
  List<Map<String, dynamic>> _nearbyCarWashes = [];

  // Recent visits
  List<Map<String, dynamic>> _recentVisits = [];

  // Weather
  Map<String, dynamic>? _weatherData;
  bool _weatherLoading = true;

  // Promo plan for banner
  Map<String, dynamic>? _promoPlan;

  // User location
  double _userLat = 41.311;
  double _userLng = 69.279;

  // Notification count
  int _unreadNotifCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadHomeData();
    });
  }

  void refreshData() {
    if (mounted) _loadHomeData();
  }

  /// Try to get user location in the background. Never blocks API loading.
  /// After location is obtained, reloads car washes with real coords.
  Future<void> _getUserLocationInBackground() async {
    // Always start with cached/default coords
    _userLat = _cachedLat;
    _userLng = _cachedLng;

    // If we already obtained real coords this session, just use them
    if (_locationObtained) return;

    try {
      final status = await Permission.locationWhenInUse.status;

      if (status.isGranted) {
        // Already granted — proceed to get position
      } else if (!_locationPermissionAsked) {
        // First time this screen instance — show UI modal → native iOS dialog
        _locationPermissionAsked = true;
        if (!mounted) return;
        final granted = await showLocationPermissionModal(context);
        if (!granted) return;
        // Re-check after modal flow
        final newStatus = await Permission.locationWhenInUse.status;
        if (!newStatus.isGranted) return;
      } else {
        return; // Already asked this session, don't ask again
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 8));

      _cachedLat = position.latitude;
      _cachedLng = position.longitude;
      _locationObtained = true;

      if (mounted) {
        setState(() {
          _userLat = position.latitude;
          _userLng = position.longitude;
        });
        // Reload car washes with real location
        _loadNearbyCarWashes();
      }
    } catch (_) {
      // Geolocation not available or timed out — keep default Tashkent coords
    }
  }

  Future<void> _loadNearbyCarWashes() async {
    try {
      final lat = _userLat != 0 ? _userLat : 41.311;
      final lng = _userLng != 0 ? _userLng : 69.279;
      final resp = await FullApiService.get('/api/mobile/car-washes/nearby',
          queryParameters: {'latitude': lat, 'longitude': lng, 'radius': 50});
      if (mounted && resp.statusCode == 200) {
        final data = resp.data;
        final partners = ((data['partners'] as List?) ??
                (data['car_washes'] as List?) ??
                [])
            .cast<Map<String, dynamic>>();
        setState(() => _nearbyCarWashes = partners);
      }
    } catch (_) {}
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0; // Earth radius in km
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  Future<void> _loadHomeData() async {
    // 1. Start location request in background (non-blocking)
    //    This will reload car washes when location arrives.
    _getUserLocationInBackground();

    // 2. Load all API data immediately with default/cached coords
    //    These don't need to wait for location.
    final loggedIn = await FullApiService.isLoggedIn();
    if (mounted) setState(() => _isLoggedIn = loggedIn);

    // Load subscription
    try {
      final res = await FullApiService.getSubscriptionStatus();
      final sub = res['subscription'] as Map<String, dynamic>?;
      if (mounted && sub != null && sub['status'] == 'active') {
        setState(() {
          _hasSubscription = true;
          _planName = sub['plan_name'] ?? sub['name'] ?? '';
          _usedVisits = sub['used_visits'] ?? sub['visits_used'] ?? 0;
          final isUnlimited = sub['is_unlimited'] == true;
          if (isUnlimited) {
            _totalVisits = -1;
          } else {
            _totalVisits = sub['total_visits'] ?? sub['visit_limit'] ?? 0;
            if (_totalVisits == 0) {
              final rem = sub['remaining_visits'] ?? sub['visits_remaining'] ?? 0;
              _totalVisits = _usedVisits + ((rem as num).toInt());
            }
          }
          _savedAmount = sub['saved_amount'] ?? (_usedVisits * 15000);
          final endStr = sub['end_date']?.toString();
          if (endStr != null && endStr.isNotEmpty) {
            try {
              final dt = DateTime.parse(endStr);
              final months = ['Yanvar','Fevral','Mart','Aprel','May','Iyun','Iyul','Avgust','Sentabr','Oktabr','Noyabr','Dekabr'];
              _endDate = '${months[dt.month - 1]} ${dt.day}';
            } catch (_) {
              _endDate = endStr;
            }
          }
        });
      }
    } catch (_) {}

    // Load weather with cached/default location
    try {
      String lang = 'uz';
      try { lang = context.read<LanguageProvider>().languageCode; } catch (_) {}
      final weather = await FullApiService.getWeatherData(
        latitude: _userLat != 0 ? _userLat : 41.311,
        longitude: _userLng != 0 ? _userLng : 69.279,
        lang: lang,
      ).timeout(const Duration(seconds: 10));
      if (mounted) setState(() { _weatherData = weather; _weatherLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _weatherLoading = false);
    }

    // Load promo plan
    try {
      final resp = await FullApiService.get('/api/mobile/subscriptions/plans');
      if (mounted && resp.statusCode == 200) {
        final plans = (resp.data['plans'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        if (plans.isNotEmpty) {
          plans.sort((a, b) => (b['duration_days'] ?? 0).compareTo(a['duration_days'] ?? 0));
          setState(() => _promoPlan = plans.first);
        }
      }
    } catch (_) {}

    // Load nearby car washes with default/cached coords (will reload when real location arrives)
    await _loadNearbyCarWashes();

    // Load recent visits (only for logged-in users)
    if (_isLoggedIn) {
      try {
        final visits = await FullApiService.getVisitHistory(limit: 3);
        if (mounted) setState(() => _recentVisits = visits.cast<Map<String, dynamic>>());
      } catch (_) {}
    }

    // Load unread notification count
    try {
      final resp = await FullApiService.get('/api/mobile/notifications');
      if (mounted && resp.statusCode == 200) {
        final notifs = resp.data['notifications'] as List? ?? [];
        final unread = notifs.where((n) => n['is_read'] != true).length;
        setState(() => _unreadNotifCount = unread);
      }
    } catch (_) {}
  }

  String _getCarWashStatus(Map<String, dynamic> p) {
    final isOpen = p['is_open'] == true;
    final is24h = p['is_24_hours'] == true;
    if (is24h) return context.tr('status_open_24h');
    final wh = p['working_hours'];
    final closeTime = (wh is Map ? wh['close'] : null)?.toString() ?? '';
    final openTime = (wh is Map ? wh['open'] : null)?.toString() ?? '';
    if (isOpen && closeTime.isNotEmpty) {
      final t = closeTime.length >= 5 ? closeTime.substring(0, 5) : closeTime;
      return context.tr('status_open_until').replaceFirst('%s', t);
    }
    if (!isOpen && openTime.isNotEmpty) {
      final t = openTime.length >= 5 ? openTime.substring(0, 5) : openTime;
      return context.tr('status_closed_until').replaceFirst('%s', t);
    }
    return isOpen ? context.tr('status_open') : context.tr('status_closed');
  }

  String _formatNumber(int n) {
    final str = n.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) buffer.write(' ');
    }
    return buffer.toString().split('').reversed.join();
  }

  Widget _safeWidget(Widget Function() builder, {String label = ''}) {
    try {
      return builder();
    } catch (e) {
      debugPrint('HomeScreen widget error [$label]: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppTheme.primaryCyan,
            onRefresh: _loadHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _safeWidget(_buildTopBar, label: 'topBar'),
                  const SizedBox(height: 16),
                  if (_hasSubscription) _safeWidget(_buildPremiumCard, label: 'premiumCard'),
                  if (_hasSubscription) const SizedBox(height: 16),
                  _safeWidget(_buildWeatherWidget, label: 'weather'),
                  const SizedBox(height: 16),
                  if (!_hasSubscription) _safeWidget(_buildSubscriptionBanner, label: 'subBanner'),
                  if (!_hasSubscription) const SizedBox(height: 16),
                  _safeWidget(_buildCategoriesSection, label: 'categories'),
                  const SizedBox(height: 24),
                  _safeWidget(_buildNearestCarWashesSection, label: 'nearbyWashes'),
                  if (_isLoggedIn) const SizedBox(height: 24),
                  if (_isLoggedIn) _safeWidget(_buildRecentVisitsSection, label: 'recentVisits'),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('HomeScreen build error: $e');
      // Trigger reload on next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryCyan),
        ),
      );
    }
  }

  Widget _buildTopBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.85),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // YUVGO Logo from image
              Image.asset(
                'assets/images/Light BG Default.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              Row(
                children: [
                  // Bookmark icon
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/saved'),
                    child: const Icon(
                      Icons.bookmark_outline,
                      size: 24,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Notification icon with badge
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/notifications'),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            size: 24,
                            color: AppTheme.textPrimary,
                          ),
                          if (_unreadNotifCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFC3E3E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromRGBO(255, 255, 255, 0.85),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _unreadNotifCount > 99 ? '99+' : '$_unreadNotifCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => MainNavigationFixed.switchToTab(3),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.primaryCyan,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 191, 254, 0.3),
                blurRadius: 14,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: const Color.fromRGBO(0, 122, 255, 0.2),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Inner glow effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromRGBO(255, 255, 255, 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  children: [
                    // Top section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Premium badge and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Premium badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 255, 255, 0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      color: const Color(0xFFFFEEEA),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 90 kunlik
                            Text(
                              _planName.isNotEmpty ? _planName : context.tr('days_short'),
                              style: TextStyle(
                                color: const Color(0xFFFFEEEA),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Mulish',
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Tugaydi
                            Text(
                              _endDate.isNotEmpty ? '${context.tr('sub_expires')}: $_endDate' : '${context.tr('sub_expires')}: ---',
                              style: TextStyle(
                                color: const Color(0xFFFFEEEA),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ],
                        ),
                        // Right side - Security icon
                        Container(
                          width: 28,
                          height: 28,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bottom section - Two info boxes
                    Row(
                      children: [
                        // Tejalgan pul box
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromRGBO(255, 255, 255, 0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr('saved_money'),
                                      style: TextStyle(
                                        color: const Color(0xFFFFEEEA),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Flexible(child: Text(
                                          _formatNumber(_savedAmount),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Mulish',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        const SizedBox(width: 2),
                                        Text(
                                          context.tr('currency'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Mulish',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Shu oy tashriflari box
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromRGBO(255, 255, 255, 0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr('monthly_visits'),
                                      style: TextStyle(
                                        color: const Color(0xFFFFEEEA),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '$_usedVisits/',
                                            style: TextStyle(
                                              color: const Color(0xFFFFEEEA),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                          TextSpan(
                                            text: _totalVisits == -1 ? '∞' : '$_totalVisits',
                                            style: TextStyle(
                                              color: const Color(0xFFFFEEEA),
                                              fontSize: _totalVisits == -1 ? 18 : 12,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    // Show loading shimmer while weather is being fetched
    if (_weatherLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 14, decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Container(width: 140, height: 11, decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final washRating = (_weatherData?['wash_rating'] ?? 0) is num ? (_weatherData!['wash_rating'] as num).toInt() : 0;
    final recommendation = _weatherData?['recommendation']?.toString() ?? context.tr('home_weather_good');
    final forecast = (_weatherData?['forecast'] as List?) ?? [];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/weather', arguments: _weatherData);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Wash rating section
              Row(
                children: [
                  // Gauge
                  SizedBox(
                    width: 60,
                    height: 38,
                    child: CustomPaint(
                      painter: GaugePainter(washRating.clamp(0, 100)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.tr('home_weather_title'),
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24,
                              color: const Color(0xFF8F96A0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendation,
                          style: TextStyle(
                            color: const Color(0xFF8F96A0),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mulish',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Weather forecast days
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < forecast.length && i < 6; i++)
                    _buildDayForecast(
                      forecast[i]['day']?.toString() ?? '',
                      forecast[i]['weather']?.toString() ?? 'sunny',
                      forecast[i]['temp']?.toString() ?? '',
                      '${forecast[i]['wash_rating'] ?? 0}%',
                      i == 0,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayForecast(String day, String weatherType, String temp, String percent, bool isSelected) {
    return Container(
      width: 47,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isSelected ? Border.all(color: const Color(0xFF1D99F2), width: 1) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 4),
          _buildWeatherIcon(weatherType),
          const SizedBox(height: 4),
          Text(
            temp,
            style: TextStyle(
              color: const Color(0xFF8F96A0),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            percent,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String type, {double size = 24}) {
    return IosWeatherIcon(type: type, size: size);
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => MainNavigationFixed.switchToTab(1),
              child: _buildCategoryCard(context.tr('premium_car_washes'), 'assets/images/af4f3f12083748892aa8cce089849a9c6258d073.png'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => MainNavigationFixed.switchToTab(1),
              child: _buildCategoryCard(context.tr('new_car_washes'), 'assets/images/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
                height: 1.2,
              ),
            ),
          ),
          Positioned(
            right: -20,
            bottom: -15,
            child: Image.asset(
              imagePath,
              width: 109,
              height: 109,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 109,
                  height: 109,
                  color: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearestCarWashesSection() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('home_nearest'),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
              GestureDetector(
                onTap: () => MainNavigationFixed.switchToTab(1),
                child: Text(
                  context.tr('home_see_all'),
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Car wash cards
        SizedBox(
          height: 310,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _nearbyCarWashes.isNotEmpty
              ? _nearbyCarWashes.take(5).map((p) {
                  double distKm = 0.0;
                  if (p['distance'] != null) {
                    distKm = double.tryParse(p['distance'].toString()) ?? 0.0;
                  } else {
                    // Calculate distance client-side using Haversine
                    final pLat = double.tryParse(p['latitude']?.toString() ?? '');
                    final pLng = double.tryParse(p['longitude']?.toString() ?? '');
                    if (pLat != null && pLng != null) {
                      distKm = _haversine(_userLat, _userLng, pLat, pLng);
                    }
                  }
                  final dist = distKm > 0
                      ? (distKm < 1 ? '${(distKm * 1000).toInt()} m' : '${distKm.toStringAsFixed(1)} km')
                      : '';
                  final imageUrl = (p['banner_url'] ?? p['image_url'] ?? p['logo_url'] ?? p['photo_url'] ?? ((p['gallery_urls'] is List && (p['gallery_urls'] as List).isNotEmpty) ? (p['gallery_urls'] as List).first : '')).toString();
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildCarWashCard(
                      p['name'] ?? 'Car Wash',
                      p['address'] ?? '',
                      dist,
                      (p['rating'] ?? 4.5).toDouble(),
                      _getCarWashStatus(p),
                      p['is_open'] == true,
                      imageUrl,
                      partnerData: p,
                    ),
                  );
                }).toList()
              : [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        context.tr('home_no_nearby'),
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontFamily: 'Mulish'),
                      ),
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarWashCard(
    String name,
    String address,
    String distance,
    double rating,
    String status,
    bool isOpen,
    String imagePath, {
    Map<String, dynamic>? partnerData,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/car-wash-detail',
          arguments: partnerData ?? {
            'name': name,
            'address': address,
            'rating': rating,
            'status': status,
            'is_open': isOpen,
          },
        );
      },
      child: Container(
        width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rating badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: imagePath.startsWith('http')
                  ? Image.network(
                      imagePath,
                      width: 300,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 300,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/194b66145883c040db1229c8b27859f09f39f78f.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 300,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2332),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/194b66145883c040db1229c8b27859f09f39f78f.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              ),
              // Rating badge
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Carousel dots
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Container(
                    width: i == 0 ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.white : const Color.fromRGBO(255, 255, 255, 0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpen ? const Color.fromRGBO(92, 204, 39, 0.1) : const Color.fromRGBO(252, 62, 62, 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  name,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(height: 4),
                // Address
                Text(
                  address,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Mulish',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Distance
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppTheme.primaryCyan),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: TextStyle(
                        color: AppTheme.primaryCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
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

// Car Wash Detail Page
class CarWashDetailPage extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final double rating;
  final String status;
  final bool isOpen;
  final String imagePath;

  const CarWashDetailPage({
    Key? key,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.status,
    required this.isOpen,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppTheme.lightGray);
                    },
                  ),
                  // Rating badge
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isOpen ? const Color.fromRGBO(92, 204, 39, 0.1) : const Color.fromRGBO(252, 62, 62, 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Address
                  Text(
                    address,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 15,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Distance
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppTheme.primaryCyan),
                      const SizedBox(width: 6),
                      Text(
                        distance,
                        style: TextStyle(
                          color: AppTheme.primaryCyan,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Info cards
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard('Ish vaqti', '08:00 - 22:00', Icons.access_time)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard('Telefon', '+998 90 123 45 67', Icons.phone)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Services section
                  Text(
                    'Xizmatlar',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildServiceChip('Avtomobil yuvish'),
                      _buildServiceChip('Ichki tozalash'),
                      _buildServiceChip('Polirovka'),
                      _buildServiceChip('Himoya qoplama'),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to QR scanner or booking
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'QR kod skanerlash',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryCyan, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 191, 254, 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.primaryCyan,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Mulish',
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final int percentage;

  GaugePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 4;

    // Background arc
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Gradient arc
    final gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: const [
        Color(0xFFD22929),
        Color(0xFFFFD600),
        Color(0xFF5CCC27),
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );

    // Percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: const TextStyle(
          color: Color(0xFF0A0C13),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'Mulish',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height - 2),
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) => oldDelegate.percentage != percentage;
}

extension HomeScreenMethods on _HomeScreenFixedState {
  String _formatPrice(num price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) buffer.write(' ');
    }
    return buffer.toString().split('').reversed.join();
  }

  Widget _buildSubscriptionBanner() {
    if (_promoPlan == null) {
      // Fallback: show static banner that navigates to subscriptions
      return _buildStaticBanner();
    }

    final plan = _promoPlan!;
    final price = num.tryParse(plan['price']?.toString() ?? '0') ?? 0;
    final days = plan['duration_days'] ?? 90;
    String lang = 'uz';
    try { lang = context.read<LanguageProvider>().languageCode; } catch (_) {}
    // Localized plan name
    String name;
    if (lang == 'ru' && (plan['name_ru'] ?? '').toString().isNotEmpty) {
      name = plan['name_ru'];
    } else if (lang == 'en' && (plan['name_en'] ?? '').toString().isNotEmpty) {
      name = plan['name_en'];
    } else {
      name = plan['name'] ?? '';
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/checkout', arguments: plan);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF0A2A3A),
                const Color(0xFF006B8F),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('home_subscribe_title'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatPrice(price)} ${lang == 'ru' ? 'сум' : lang == 'en' ? 'UZS' : 'so\'m'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 0.7),
                        fontSize: 13,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      context.tr('home_subscribe_btn'),
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticBanner() {
    return GestureDetector(
      onTap: () {
        MainNavigationFixed.switchToTab(3);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF0A2A3A),
                const Color(0xFF006B8F),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('home_subscribe_title'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('home_subscribe_desc'),
                      style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 0.7),
                        fontSize: 13,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  context.tr('home_subscribe_btn'),
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentVisitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('home_recent'),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/visit-history'),
                child: Text(
                  context.tr('home_see_all'),
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Recent visits list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _recentVisits.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      context.tr('home_no_recent'),
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                )
              : Column(
                  children: _recentVisits.asMap().entries.map((entry) {
                    final i = entry.key;
                    final v = entry.value;
                    final name = (v['partner_name'] ?? v['car_wash_name'] ?? 'Avtomoyqa').toString();
                    final address = (v['address'] ?? '').toString();
                    final carBrand = (v['vehicle_brand'] ?? v['car_brand'] ?? '').toString();
                    final region = (v['region'] ?? '').toString();
                    final plate = (v['plate_number'] ?? v['license_plate'] ?? '').toString();
                    final time = (v['visited_at'] ?? v['created_at'] ?? '').toString();
                    // Format time to HH:mm if it's a full datetime
                    String timeStr = time;
                    if (time.contains('T')) {
                      try {
                        final dt = DateTime.parse(time);
                        timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                      } catch (_) {}
                    }
                    return Padding(
                      padding: EdgeInsets.only(bottom: i < _recentVisits.length - 1 ? 12 : 0),
                      child: _buildRecentVisitItem(name, address, carBrand, region, plate, timeStr),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildRecentVisitItem(
    String name,
    String address,
    String carBrand,
    String region,
    String plateNumber,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Car wash icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 191, 254, 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_car_wash,
              color: AppTheme.primaryCyan,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Mulish',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 191, 254, 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        carBrand,
                        style: TextStyle(
                          color: AppTheme.primaryCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        region,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      plateNumber,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Time
          Text(
            time,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }
}

/// Public accessor for shared location state so other screens (map) can use cached coords
/// without requesting permission again.
class SharedLocationState {
  static double get cachedLat => _HomeScreenFixedState._cachedLat;
  static double get cachedLng => _HomeScreenFixedState._cachedLng;
  static bool get locationObtained => _HomeScreenFixedState._locationObtained;
  static bool get permissionAsked => false;
}

