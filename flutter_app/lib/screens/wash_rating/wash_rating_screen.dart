import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WashRatingScreen extends StatefulWidget {
  const WashRatingScreen({super.key});

  @override
  State<WashRatingScreen> createState() => _WashRatingScreenState();
}

class _WashRatingScreenState extends State<WashRatingScreen> {
  final int _washRating = 92;
  
  final List<WeatherForecast> _weeklyForecast = [
    WeatherForecast(day: 'Bugun', percentage: 92, tempHigh: 24, tempLow: 10, icon: Icons.wb_sunny),
    WeatherForecast(day: 'Sesh', percentage: 85, tempHigh: 22, tempLow: 5, icon: Icons.wb_sunny),
    WeatherForecast(day: 'Chor', percentage: 72, tempHigh: 16, tempLow: 4, icon: Icons.cloud),
    WeatherForecast(day: 'Pay', percentage: 22, tempHigh: 24, tempLow: 10, icon: Icons.water_drop),
    WeatherForecast(day: 'Jum', percentage: 48, tempHigh: 10, tempLow: 3, icon: Icons.cloud),
    WeatherForecast(day: 'Shan', percentage: 70, tempHigh: 16, tempLow: 4, icon: Icons.wb_cloudy),
    WeatherForecast(day: 'Yak', percentage: 12, tempHigh: 3, tempLow: -2, icon: Icons.ac_unit),
  ];

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
      body: SingleChildScrollView(
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
                      'Holat: A\'lo',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tavsiya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '4 kun davomida yog\'ingarchilik kutilmaydi. Yuvish uchun mukammal havo.',
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
          const Text('Hozirgi havo harorati:', style: AppTextStyles.labelMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Colors.amber, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quyoshli',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Kunduz: +24°  |  Tunda: +10°',
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
              _buildWeatherStat(Icons.air, '24 km/h', 'Shamol'),
              _buildWeatherStat(Icons.water_drop, '10%', 'Yomg\'ir'),
              _buildWeatherStat(Icons.thermostat, '10%', 'Chang'),
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
          ..._weeklyForecast.map((forecast) => _buildForecastRow(forecast)),
        ],
      ),
    );
  }

  Widget _buildForecastRow(WeatherForecast forecast) {
    Color ratingColor;
    if (forecast.percentage >= 70) {
      ratingColor = AppColors.success;
    } else if (forecast.percentage >= 40) {
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
              forecast.day,
              style: AppTextStyles.labelMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${forecast.percentage}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ratingColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: forecast.percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: ratingColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'K: +${forecast.tempHigh}°',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(width: 4),
          Text(
            'T: ${forecast.tempLow > 0 ? '+' : ''}${forecast.tempLow}°',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(width: 8),
          Icon(forecast.icon, size: 20, color: Colors.amber),
        ],
      ),
    );
  }
}

class WeatherForecast {
  final String day;
  final int percentage;
  final int tempHigh;
  final int tempLow;
  final IconData icon;

  WeatherForecast({
    required this.day,
    required this.percentage,
    required this.tempHigh,
    required this.tempLow,
    required this.icon,
  });
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
