import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/full_api_service.dart';

class WashRatingScreen extends StatefulWidget {
  const WashRatingScreen({super.key});

  @override
  State<WashRatingScreen> createState() => _WashRatingScreenState();
}

class _WashRatingScreenState extends State<WashRatingScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['success'] == true) {
        setState(() {
          _weatherData = args;
          _isLoading = false;
        });
      } else {
        _loadWeather();
      }
    });
  }

  Future<void> _loadWeather() async {
    setState(() => _isLoading = true);
    try {
      final data = await FullApiService.getWeatherData();
      if (mounted) setState(() { _weatherData = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _washRating {
    final r = _weatherData?['wash_rating'];
    if (r is int) return r;
    if (r is num) return r.toInt();
    return 0;
  }

  String get _recommendation => _weatherData?['recommendation'] ?? '';

  Map<String, dynamic> get _current => (_weatherData?['current'] as Map<String, dynamic>?) ?? {};

  List<dynamic> get _forecast => (_weatherData?['forecast'] as List?) ?? [];

  String _statusLabel(int rating) {
    if (rating >= 80) return "A'lo";
    if (rating >= 60) return 'Yaxshi';
    if (rating >= 40) return "O'rtacha";
    if (rating >= 20) return 'Yomon';
    return 'Juda yomon';
  }

  IconData _weatherTypeIcon(String type) {
    switch (type) {
      case 'sunny': return Icons.wb_sunny;
      case 'partly_cloudy': return Icons.wb_cloudy;
      case 'cloudy': return Icons.cloud;
      case 'drizzle': return Icons.grain;
      case 'rain': return Icons.water_drop;
      case 'snow': return Icons.ac_unit;
      case 'thunderstorm': return Icons.flash_on;
      case 'fog': return Icons.blur_on;
      default: return Icons.wb_sunny;
    }
  }

  Color _weatherTypeColor(String type) {
    switch (type) {
      case 'sunny': return Colors.amber;
      case 'partly_cloudy': return Colors.orange;
      case 'cloudy': return Colors.grey;
      case 'drizzle': return Colors.blueGrey;
      case 'rain': return AppColors.primary;
      case 'snow': return Colors.lightBlue;
      case 'thunderstorm': return Colors.deepOrange;
      case 'fog': return Colors.grey;
      default: return Colors.amber;
    }
  }

  String _weatherTypeLabel(String type) {
    switch (type) {
      case 'sunny': return 'Quyoshli';
      case 'partly_cloudy': return 'Qisman bulutli';
      case 'cloudy': return 'Bulutli';
      case 'drizzle': return 'Mayda yomg\'ir';
      case 'rain': return 'Yomg\'irli';
      case 'snow': return 'Qorli';
      case 'thunderstorm': return 'Momaqaldiroq';
      case 'fog': return 'Tumanli';
      default: return 'Ochiq';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Yuvish reytingi', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWeather,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildRatingGauge(),
                    _buildRecommendation(),
                    _buildCurrentWeather(),
                    _buildWeeklyForecast(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRatingGauge() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: 220,
            height: 140,
            child: CustomPaint(
              painter: GaugePainter(percentage: _washRating / 100),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Holat: ${_statusLabel(_washRating)}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_washRating%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation() {
    final isGood = _washRating >= 50;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isGood ? AppColors.primary : AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isGood ? AppColors.primary : AppColors.error).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isGood ? AppColors.primary : AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isGood ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tavsiya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isGood ? AppColors.primary : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _recommendation,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    final temp = _current['temperature'] ?? 0;
    final weatherType = _current['weather_type'] ?? 'sunny';
    final humidity = _current['humidity'] ?? 0;
    final windSpeed = _current['wind_speed'] ?? 0;
    final city = _current['city'] ?? 'Toshkent';
    
    // Get today's temp range from forecast
    String tempRange = '';
    if (_forecast.isNotEmpty) {
      tempRange = '${_forecast[0]['temp'] ?? ''}  /  ${_forecast[0]['temp_min'] ?? ''}';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$city — Hozirgi ob-havo:', style: AppTextStyles.labelMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(_weatherTypeIcon(weatherType), color: _weatherTypeColor(weatherType), size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${temp > 0 ? "+" : ""}$temp° — ${_weatherTypeLabel(weatherType)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (tempRange.isNotEmpty)
                    Text(
                      tempRange,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat(Icons.air, '${windSpeed} km/h', 'Shamol'),
              _buildWeatherStat(Icons.water_drop, '$humidity%', 'Namlik'),
              _buildWeatherStat(
                Icons.umbrella,
                '${_forecast.isNotEmpty ? _forecast[0]['precip_prob'] ?? 0 : 0}%',
                'Yomg\'ir',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildWeeklyForecast() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Haftalik prognoz', style: AppTextStyles.h5),
          const SizedBox(height: 16),
          for (int i = 0; i < _forecast.length; i++)
            _buildForecastRow(_forecast[i], i == 0),
        ],
      ),
    );
  }

  Widget _buildForecastRow(dynamic forecastItem, bool isToday) {
    final f = forecastItem as Map<String, dynamic>;
    final weekday = f['weekday']?.toString() ?? '';
    final rating = (f['wash_rating'] is int) ? f['wash_rating'] as int : ((f['wash_rating'] as num?)?.toInt() ?? 0);
    final temp = f['temp']?.toString() ?? '';
    final tempMin = f['temp_min']?.toString() ?? '';
    final weatherType = f['weather']?.toString() ?? 'sunny';

    Color ratingColor;
    if (rating >= 70) {
      ratingColor = AppColors.success;
    } else if (rating >= 40) {
      ratingColor = AppColors.warning;
    } else {
      ratingColor = AppColors.error;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              isToday ? 'Bugun' : weekday,
              style: isToday
                  ? AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)
                  : AppTextStyles.labelMedium,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 38,
            child: Text(
              '$rating%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ratingColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: rating / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: ratingColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(temp, style: AppTextStyles.bodySmall),
          const SizedBox(width: 4),
          Text(tempMin, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
          const SizedBox(width: 8),
          Icon(_weatherTypeIcon(weatherType), size: 20, color: _weatherTypeColor(weatherType)),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;

  GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Gradient arc
    final gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: 2 * math.pi,
      colors: const [
        Color(0xFFEF4444), // Red
        Color(0xFFF97316), // Orange
        Color(0xFFFBBF24), // Yellow
        Color(0xFF84CC16), // Light green
        Color(0xFF10B981), // Green
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * percentage,
      false,
      gradientPaint,
    );

    // Indicator dot
    final angle = math.pi + (math.pi * percentage);
    final dotX = center.dx + radius * math.cos(angle);
    final dotY = center.dy + radius * math.sin(angle);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(dotX, dotY), 10, dotPaint);
    canvas.drawCircle(Offset(dotX, dotY), 10, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
