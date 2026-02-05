import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Yuvish reytingi',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Gauge
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: CircularGaugePainter(percentage: 92),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Holat: Alo',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '92%',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Card
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
                          'Tavfsiya',
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
                    '4 kun davomida yog\'ingarchilik kutilmaydi. Yuvish uchun mukammal havo!',
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
            
            // Weather Card with Map
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
                    'Hozirgi havo harorati:',
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
                                Text(
                                  '☀️',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Quyoshli',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kunduz: +24°',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              'Tunda: +10°',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.map,
                                size: 40,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.location_on,
                                size: 32,
                                color: AppTheme.primaryCyan,
                              ),
                            ),
                          ],
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
                  _buildConditionItem('💨', '24 km/h', 'Shamol'),
                  Container(width: 1, height: 40, color: AppTheme.borderGray),
                  _buildConditionItem('☁️', '10%', 'Yomg\'ir'),
                  Container(width: 1, height: 40, color: AppTheme.borderGray),
                  _buildConditionItem('☀️', '10%', 'Chang'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Weekly Forecast
            Text(
              'Haftalik prognoz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildForecastItem('Bugun', 92, '+24°', '+10°', '☀️'),
            const SizedBox(height: 12),
            _buildForecastItem('Sesh', 85, '+22°', '+5°', '☀️'),
            const SizedBox(height: 12),
            _buildForecastItem('Chor', 72, '+16°', '+4°', '☁️'),
            const SizedBox(height: 12),
            _buildForecastItem('Pay', 22, '+24°', '+10°', '☁️'),
            const SizedBox(height: 12),
            _buildForecastItem('Jum', 48, '+10°', '+3°', '💨'),
            const SizedBox(height: 12),
            _buildForecastItem('Shan', 70, '+16°', '+4°', '☁️'),
            const SizedBox(height: 12),
            _buildForecastItem('Yak', 12, '+3°', '-2°', '☁️'),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
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

  Widget _buildForecastItem(String day, int percentage, String high, String low, String emoji) {
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
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                  left: percentage * 0.01 * 200 - 6,
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
          Text(emoji, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class CircularGaugePainter extends CustomPainter {
  final int percentage;

  CircularGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 16.0;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Gradient arc
    final gradientColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
    ];

    final sweepAngle = (percentage / 100) * math.pi * 1.5;

    for (int i = 0; i < gradientColors.length - 1; i++) {
      final startAngle = math.pi * 0.75 + (i / (gradientColors.length - 1)) * math.pi * 1.5;
      final endAngle = math.pi * 0.75 + ((i + 1) / (gradientColors.length - 1)) * math.pi * 1.5;
      
      if (startAngle < math.pi * 0.75 + sweepAngle) {
        final paint = Paint()
          ..shader = LinearGradient(
            colors: [gradientColors[i], gradientColors[i + 1]],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        final actualEndAngle = endAngle > math.pi * 0.75 + sweepAngle
            ? math.pi * 0.75 + sweepAngle
            : endAngle;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          actualEndAngle - startAngle,
          false,
          paint,
        );
      }
    }

    // End indicator dot
    final endAngle = math.pi * 0.75 + sweepAngle;
    final endX = center.dx + radius * math.cos(endAngle);
    final endY = center.dy + radius * math.sin(endAngle);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(endX, endY), 10, dotPaint);

    final dotBorderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(Offset(endX, endY), 10, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
