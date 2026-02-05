import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Yuvish reytingi',
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
                  painter: LargeGaugePainter(92),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tavfsiya',
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
                            SizedBox(
                              width: 280,
                              child: Text(
                                '4 kun davomida yog\'ingarchilik kutilmaydi. Yuvish uchun mukammal havo!',
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current weather card with map
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Weather info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hozirgi havo harorati:',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                                fontFamily: 'Mulish',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('☀️', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  'Quyoshli',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kunduzi: +24°',
                              style: TextStyle(
                                color: AppTheme.primaryCyan,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                              ),
                            ),
                            Text(
                              'Tunda: +10°',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Mini map
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Container(
                        width: 140,
                        height: 120,
                        color: const Color(0xFFE8F4E8),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(Icons.map, color: Colors.grey[400], size: 40),
                            ),
                            // Location marker
                            Positioned(
                              top: 40,
                              right: 50,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryCyan,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on, color: Colors.white, size: 10),
                                    Text(
                                      'Black Star',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
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
                    _buildWeatherStat('🌬️', '24 km/h', 'Shamol'),
                    _buildWeatherStat('💧', '10%', 'Yomg\'ir'),
                    _buildWeatherStat('🌊', '10%', 'Chang'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Haftalik prognoz
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Haftalik prognoz',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weekly forecast list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildForecastRow('Bugun', 92, '+24°', '+10°', '☀️', true),
                  _buildForecastRow('Sesh', 85, '+22°', '+5°', '☀️', false),
                  _buildForecastRow('Chor', 72, '+16°', '+4°', '⛅', false),
                  _buildForecastRow('Pay', 22, '+24°', '+10°', '🌧️', false),
                  _buildForecastRow('Jum', 48, '+10°', '+3°', '🌬️', false),
                  _buildForecastRow('Shan', 70, '+16°', '+4°', '☁️', false),
                  _buildForecastRow('Yak', 12, '+3°', '-2°', '☁️', false),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
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

  Widget _buildForecastRow(String day, int percent, String high, String low, String emoji, bool isToday) {
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
          // Emoji
          Text(emoji, style: TextStyle(fontSize: 20)),
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
