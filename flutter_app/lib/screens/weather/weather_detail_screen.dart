import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';
import '../../widgets/ios_weather_icon.dart';
import '../../l10n/language_provider.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final washRating = weatherData?['wash_rating'] ?? 0;
    final recommendation = weatherData?['recommendation'] ?? context.tr('home_weather_good');
    final forecast = (weatherData?['forecast'] as List?) ?? [];
    final currentTemp = weatherData?['current_temp'] ?? weatherData?['temp'] ?? '';
    final currentWeather = weatherData?['current_weather'] ?? 'sunny';
    final wind = weatherData?['wind'] ?? '';
    final rainChance = weatherData?['rain_chance'] ?? '';
    final humidity = weatherData?['humidity'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large gauge
            Center(
              child: SizedBox(
                width: 200,
                height: 140,
                child: CustomPaint(
                  painter: LargeGaugePainter(washRating is int ? washRating : (washRating as num).toInt()),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tavfsiya card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('weather_recommendation'),
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: AppTheme.primaryCyan, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                  fontFamily: 'Mulish',
                                ),
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
            const SizedBox(height: 16),

            // Current weather card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('weather_current_temp'),
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'Mulish'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IosWeatherIcon(type: currentWeather.toString(), size: 28),
                        const SizedBox(width: 10),
                        Text(
                          '$currentTemp',
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Mulish'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weather stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherStatIcon(const IosWeatherIcon(type: 'cloudy', size: 28), '$wind', context.tr('weather_wind')),
                    _buildWeatherStatIcon(const IosWeatherIcon(type: 'rain', size: 28), '$rainChance', context.tr('weather_rain')),
                    _buildWeatherStatIcon(const IosWeatherIcon(type: 'fog', size: 28), '$humidity', context.tr('weather_dust')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Haftalik prognoz
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.tr('weather_weekly'),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weekly forecast list from API
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (int i = 0; i < forecast.length && i < 7; i++)
                    _buildForecastRowIcon(
                      forecast[i]['day']?.toString() ?? '',
                      (forecast[i]['wash_rating'] ?? 0) is int ? forecast[i]['wash_rating'] : (forecast[i]['wash_rating'] as num).toInt(),
                      forecast[i]['high']?.toString() ?? forecast[i]['temp']?.toString() ?? '',
                      forecast[i]['low']?.toString() ?? '',
                      forecast[i]['weather']?.toString() ?? 'sunny',
                      i == 0,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStatIcon(Widget icon, String value, String label) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontFamily: 'Mulish',
          ),
        ),
      ],
    );
  }

  Widget _buildForecastRowIcon(String day, int percent, String high, String low, String weatherType, bool isToday) {
    Color progressColor;
    if (percent >= 70) {
      progressColor = const Color(0xFF5CCC27);
    } else if (percent >= 40) {
      progressColor = const Color(0xFFFFD600);
    } else {
      progressColor = const Color(0xFFFC3E3E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isToday ? AppTheme.primaryCyan.withOpacity(0.1) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: AppTheme.primaryCyan, width: 1) : null,
      ),
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 50,
            child: Text(
              day,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
              ),
            ),
          ),
          // Percent
          SizedBox(
            width: 40,
            child: Text(
              '$percent%',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ),
          // Progress bar
          Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          // Temperatures
          Text(
            'K: $high',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'T: $low',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(width: 8),
          // Weather icon
          IosWeatherIcon(type: weatherType, size: 22),
        ],
      ),
    );
  }
}

class LargeGaugePainter extends CustomPainter {
  final int percentage;

  LargeGaugePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 20;

    // Background arc
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
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
        Color(0xFFFC3E3E),
        Color(0xFFFFD600),
        Color(0xFF5CCC27),
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );

    // Holat text
    final holatPainter = TextPainter(
      text: TextSpan(
        text: 'Holat: A\'lo',
        style: TextStyle(
          color: const Color(0xFF8F96A0),
          fontSize: 12,
          fontFamily: 'Mulish',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    holatPainter.layout();
    holatPainter.paint(
      canvas,
      Offset(center.dx - holatPainter.width / 2, center.dy - 60),
    );

    // Percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: const TextStyle(
          color: Color(0xFF0A0C13),
          fontSize: 48,
          fontWeight: FontWeight.w900,
          fontFamily: 'Mulish',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - 45),
    );

    // Indicator dot
    final angle = math.pi + sweepAngle;
    final dotX = center.dx + radius * math.cos(angle);
    final dotY = center.dy + radius * math.sin(angle);
    
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(dotX, dotY), 8, dotPaint);
    
    final dotBorderPaint = Paint()
      ..color = const Color(0xFF5CCC27)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawCircle(Offset(dotX, dotY), 8, dotBorderPaint);
  }

  @override
  bool shouldRepaint(LargeGaugePainter oldDelegate) => oldDelegate.percentage != percentage;
}
