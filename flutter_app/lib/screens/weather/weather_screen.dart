import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';
import '../../widgets/ios_weather_icon.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = true;
  int _washRating = 0;
  String _recommendation = '';
  Map<String, dynamic> _current = {};
  List<Map<String, dynamic>> _forecast = [];

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
          _current = data['current'] is Map ? Map<String, dynamic>.from(data['current']) : {};
          final fc = data['forecast'];
          _forecast = (fc is List)
              ? fc.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList()
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

  String _ratingLabel(int rating) {
    if (rating >= 80) return context.tr('rating_excellent');
    if (rating >= 60) return context.tr('rating_good');
    if (rating >= 40) return context.tr('rating_average');
    if (rating >= 20) return context.tr('rating_bad');
    return context.tr('rating_very_bad');
  }

  @override
  Widget build(BuildContext context) {
    final curTemp = int.tryParse(_current['temperature']?.toString() ?? '') ?? 0;
    final curType = (_current['weather_type'] ?? 'sunny').toString();
    final curWind = int.tryParse(_current['wind_speed']?.toString() ?? '') ?? 0;
    final curHumidity = int.tryParse(_current['humidity']?.toString() ?? '') ?? 0;

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
          context.tr('wash_rating'),
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchWeather,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Half-circle gauge
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 130,
                        child: CustomPaint(
                          painter: _HalfCircleGaugePainter(percentage: _washRating),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _ratingLabel(_washRating),
                                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'Mulish'),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$_washRating%',
                                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, fontFamily: 'Mulish', height: 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recommendation Card
                    if (_recommendation.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(16),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryCyan.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: AppTheme.primaryCyan,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    context.tr('weather_recommendation'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _recommendation,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Current Weather Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
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
                          Text(
                            context.tr('weather_current_temp'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IosWeatherIcon(type: curType, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          _weatherLabel(curType),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${context.tr("weather_temp")}: ${curTemp >= 0 ? "+" : ""}$curTemp°',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '${_current['city'] ?? 'Toshkent'}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGray,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${curTemp >= 0 ? "+" : ""}$curTemp°',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Current Conditions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildConditionItemIcon(const IosWeatherIcon(type: 'cloudy', size: 28), '$curWind km/h', context.tr('weather_wind')),
                          Container(width: 1, height: 40, color: AppTheme.borderGray),
                          _buildConditionItemIcon(const IosWeatherIcon(type: 'rain', size: 28), '$curHumidity%', context.tr('weather_dust')),
                          Container(width: 1, height: 40, color: AppTheme.borderGray),
                          _buildConditionItemIcon(IosWeatherIcon(type: curType, size: 28), _weatherLabel(curType), context.tr('weather_current_temp')),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Weekly Forecast
                    Text(
                      context.tr('weather_weekly'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ..._forecast.asMap().entries.map((entry) {
                      final i = entry.key;
                      final day = entry.value;
                      final weekday = i == 0 ? context.tr('day_today') : (day['weekday'] ?? '').toString();
                      final rating = int.tryParse(day['wash_rating']?.toString() ?? '') ?? 0;
                      final temp = (day['temp'] ?? '').toString();
                      final tempMin = (day['temp_min'] ?? '').toString();
                      final weather = (day['weather'] ?? 'sunny').toString();
                      return Padding(
                        padding: EdgeInsets.only(bottom: i < _forecast.length - 1 ? 12 : 0),
                        child: _buildForecastItem(weekday, rating, temp, tempMin, weather),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildConditionItemIcon(Widget icon, String value, String label) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(String day, int percentage, String high, String low, String weatherType) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Positioned(
                      left: (percentage * 0.01 * barWidth).clamp(6, barWidth - 6) - 6,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.green, width: 3),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Icon(Icons.arrow_upward, size: 12, color: AppTheme.textSecondary),
              Text(
                high,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_downward, size: 12, color: AppTheme.textSecondary),
              Text(
                low,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IosWeatherIcon(type: weatherType, size: 22),
        ],
      ),
    );
  }
}

/// Half-circle gauge painter matching the home screen style
class _HalfCircleGaugePainter extends CustomPainter {
  final int percentage;

  _HalfCircleGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 8);
    final radius = size.width / 2 - 16;
    const strokeWidth = 14.0;

    // Background arc (light gray half-circle)
    final bgPaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Gradient arc (red → orange → yellow → green)
    final sweepAngle = (percentage / 100) * math.pi;
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

    // End indicator dot
    final endAngle = math.pi + sweepAngle;
    final dotX = center.dx + radius * math.cos(endAngle);
    final dotY = center.dy + radius * math.sin(endAngle);

    canvas.drawCircle(Offset(dotX, dotY), 7, Paint()..color = Colors.white);

    // Dot border color based on percentage
    Color dotColor;
    if (percentage >= 70) {
      dotColor = const Color(0xFF5CCC27);
    } else if (percentage >= 40) {
      dotColor = const Color(0xFFFFD600);
    } else {
      dotColor = const Color(0xFFFC3E3E);
    }
    canvas.drawCircle(
      Offset(dotX, dotY),
      7,
      Paint()
        ..color = dotColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_HalfCircleGaugePainter old) => old.percentage != percentage;
}
