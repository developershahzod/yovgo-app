import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';
import '../../widgets/ios_weather_icon.dart';
import '../main_navigation_fixed.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = true;
  int _washRating = 0;
  String _recommendation = '';
  String _recommendationTitle = '';
  Map<String, dynamic> _current = {};
  List<Map<String, dynamic>> _forecast = [];
  List<Map<String, dynamic>> _factors = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final lang = context.read<LanguageProvider>().languageCode;
      final resp = await FullApiService.get('/api/mobile/weather', queryParameters: {
        'latitude': 41.311,
        'longitude': 69.279,
        'lang': lang,
      });
      if (mounted && resp.statusCode == 200) {
        final data = resp.data;
        setState(() {
          _washRating = int.tryParse(data['wash_rating']?.toString() ?? '') ?? 0;
          _recommendation = (data['recommendation'] ?? '').toString();
          _recommendationTitle = (data['recommendation_title'] ?? '').toString();
          _current = data['current'] is Map ? Map<String, dynamic>.from(data['current']) : {};
          final fc = data['forecast'];
          _forecast = (fc is List)
              ? fc.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList()
              : [];
          final factors = data['factors'];
          _factors = (factors is List)
              ? factors.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList()
              : [];
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Weather fetch error: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  String _weatherLabel(String type) {
    final labels = {
      'sunny': 'weather_sunny', 'cloudy': 'weather_cloudy',
      'rain': 'weather_rainy', 'drizzle': 'weather_drizzle',
      'snow': 'weather_snowy', 'thunderstorm': 'weather_thunder',
      'fog': 'weather_foggy',
    };
    return context.tr(labels[type] ?? 'weather_sunny');
  }

  /// Convert 0–100 percentage to 1–10 score
  int _toScore(int pct) => ((pct / 10).round()).clamp(1, 10);

  /// Build default factors if API doesn't return them
  List<Map<String, dynamic>> _getFactors() {
    if (_factors.isNotEmpty) return _factors;
    final curType = (_current['weather_type'] ?? 'sunny').toString();
    final curWind = int.tryParse(_current['wind_speed']?.toString() ?? '') ?? 0;
    final curHumidity = int.tryParse(_current['humidity']?.toString() ?? '') ?? 0;
    return [
      {
        'icon': curType,
        'label': _weatherLabel(curType),
      },
      {
        'icon': 'cloudy',
        'label': '${context.tr('weather_wind')}: $curWind km/h',
      },
      {
        'icon': 'fog',
        'label': '${context.tr('weather_dust')}: $curHumidity%',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final score = _toScore(_washRating);
    final curType = (_current['weather_type'] ?? 'sunny').toString();
    final curTemp = int.tryParse(_current['temperature']?.toString() ?? '') ?? 0;
    final curTempMin = int.tryParse(_current['temp_min']?.toString() ?? _current['temperature_min']?.toString() ?? '') ?? (curTemp - 14);
    final factors = _getFactors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('weather_title'),
          style: const TextStyle(
            color: Color(0xFF0A0C13),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDDE1E7), width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.info_outline_rounded, color: Color(0xFF0A0C13), size: 20),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchWeather,
              color: AppTheme.primaryCyan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // ── Large half-circle gauge ──
                    Center(
                      child: SizedBox(
                        width: 260,
                        height: 160,
                        child: CustomPaint(
                          painter: _ScoreGaugePainter(score: score),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                context.tr('weather_recommendation'),
                                style: const TextStyle(
                                  color: Color(0xFF9BA3AF),
                                  fontSize: 14,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$score/10',
                                style: const TextStyle(
                                  color: Color(0xFF0A0C13),
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Mulish',
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Recommendation title + subtitle ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            _recommendationTitle.isNotEmpty
                                ? _recommendationTitle
                                : (_washRating >= 70
                                    ? context.tr('weather_good_day')
                                    : _washRating >= 40
                                        ? context.tr('weather_caution')
                                        : context.tr('weather_postpone')),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF0A0C13),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _recommendation.isNotEmpty ? _recommendation : context.tr('weather_changes'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF9BA3AF),
                              fontSize: 13,
                              fontFamily: 'Mulish',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── 3 factor cards row ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          for (int i = 0; i < factors.length && i < 3; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            Expanded(child: _buildFactorCard(
                              factors[i]['icon']?.toString() ?? 'cloudy',
                              factors[i]['label']?.toString() ?? '',
                            )),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Info note ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF9BA3AF)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              context.tr('weather_note'),
                              style: const TextStyle(
                                color: Color(0xFF9BA3AF),
                                fontSize: 12,
                                fontFamily: 'Mulish',
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Current weather card with map ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
                        ),
                        child: Row(
                          children: [
                            // Left: weather info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr('weather_current_label'),
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IosWeatherIcon(type: curType, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          _weatherLabel(curType),
                                          style: const TextStyle(
                                            color: Color(0xFF0A0C13),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Mulish',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${context.tr('weather_day_temp')}: ${curTemp >= 0 ? "+" : ""}$curTemp°',
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${context.tr('weather_night_temp')}: ${curTempMin >= 0 ? "+" : ""}$curTempMin°',
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Right: map placeholder
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Container(
                                width: 120,
                                height: 110,
                                color: const Color(0xFFE8F0F8),
                                child: Stack(
                                  children: [
                                    // Grid lines to simulate map
                                    CustomPaint(
                                      size: const Size(120, 110),
                                      painter: _MapGridPainter(),
                                    ),
                                    // Location dot
                                    const Center(
                                      child: Icon(Icons.location_on, color: Color(0xFF00BFFE), size: 28),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Haftalik prognoz ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.tr('weather_weekly'),
                          style: const TextStyle(
                            color: Color(0xFF0A0C13),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _forecast.asMap().entries.map((entry) {
                          final i = entry.key;
                          final day = entry.value;
                          final weekday = i == 0 ? context.tr('day_today') : (day['weekday'] ?? day['day'] ?? '').toString();
                          final rawRating = int.tryParse(day['wash_rating']?.toString() ?? '') ?? 0;
                          final dayScore = _toScore(rawRating);
                          final temp = (day['temp'] ?? day['high'] ?? '').toString();
                          final tempMin = (day['temp_min'] ?? day['low'] ?? '').toString();
                          final weather = (day['weather'] ?? 'sunny').toString();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildForecastRow(weekday, dayScore, temp, tempMin, weather, i == 0),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            MainNavigationFixed.switchToTab(1);
          },
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                context.tr('weather_nearest'),
                style: const TextStyle(
                  color: Color(0xFF0A0C13),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactorCard(String weatherType, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IosWeatherIcon(type: weatherType, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0A0C13),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastRow(String day, int score, String high, String low, String weatherType, bool isToday) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFFF0FAFE) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: AppTheme.primaryCyan, width: 1) : null,
      ),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 68,
            child: Text(
              day,
              style: TextStyle(
                color: const Color(0xFF0A0C13),
                fontSize: day.length > 5 ? 11 : 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Score X/10
          SizedBox(
            width: 36,
            child: Text(
              '$score/10',
              style: const TextStyle(
                color: Color(0xFF0A0C13),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ),
          // Gradient bar with dot indicator
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                final dotPos = ((score - 1) / 9 * barWidth).clamp(6.0, barWidth - 6.0);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFC3E3E), Color(0xFFFFD600), Color(0xFF5CCC27)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Positioned(
                      left: dotPos - 6,
                      top: -3,
                      child: Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: score >= 7 ? const Color(0xFF5CCC27) : score >= 4 ? const Color(0xFFFFD600) : const Color(0xFFFC3E3E),
                            width: 2.5,
                          ),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          // Temps
          Text(
            high.isNotEmpty ? '+$high°' : '',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontFamily: 'Mulish'),
          ),
          const SizedBox(width: 4),
          Text(
            low.isNotEmpty ? '+$low°' : '',
            style: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 12, fontFamily: 'Mulish'),
          ),
          const SizedBox(width: 8),
          IosWeatherIcon(type: weatherType, size: 20),
        ],
      ),
    );
  }
}

/// Half-circle gauge showing X/10 score with white dot indicator
class _ScoreGaugePainter extends CustomPainter {
  final int score; // 1–10

  _ScoreGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2 - 18;
    const strokeWidth = 18.0;

    // Background arc
    final bgPaint = Paint()
      ..color = const Color(0xFFF2F4F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, math.pi, false, bgPaint,
    );

    // Gradient arc (red → yellow → green)
    final sweepAngle = ((score - 1) / 9) * math.pi;
    if (sweepAngle > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: math.pi,
        endAngle: math.pi * 2,
        colors: const [
          Color(0xFFFC3E3E),
          Color(0xFFFF8C00),
          Color(0xFFFFD600),
          Color(0xFF5CCC27),
        ],
      );
      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, math.pi, sweepAngle, false, progressPaint);
    }

    // White dot indicator on arc edge
    final endAngle = math.pi + sweepAngle;
    final dotX = center.dx + radius * math.cos(endAngle);
    final dotY = center.dy + radius * math.sin(endAngle);

    canvas.drawCircle(Offset(dotX, dotY), 9,
      Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(dotX, dotY), 9,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    // Inner filled white circle (prominent dot)
    canvas.drawCircle(Offset(dotX, dotY), 6,
      Paint()..color = Colors.white..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_ScoreGaugePainter old) => old.score != score;
}

/// Simple map grid painter for the weather card background
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0DCE8)
      ..strokeWidth = 0.8;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Diagonal road lines
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;
    canvas.drawLine(const Offset(0, 40), Offset(size.width, 70), roadPaint);
    canvas.drawLine(const Offset(0, 80), Offset(size.width, 40), roadPaint);
    canvas.drawLine(const Offset(60, 0), Offset(40, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}
