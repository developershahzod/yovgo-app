import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';

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
      final resp = await FullApiService.get('/api/mobile/weather', queryParameters: {
        'latitude': 41.311,
        'longitude': 69.279,
        'lang': 'uz',
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

  String _weatherEmoji(String type) {
    switch (type) {
      case 'sunny': return '☀️';
      case 'cloudy': return '☁️';
      case 'rain': return '🌧️';
      case 'drizzle': return '🌦️';
      case 'snow': return '❄️';
      case 'thunderstorm': return '⛈️';
      case 'fog': return '🌫️';
      default: return '☀️';
    }
  }

  String _weatherLabel(String type) {
    switch (type) {
      case 'sunny': return 'Quyoshli';
      case 'cloudy': return 'Bulutli';
      case 'rain': return 'Yomg\'irli';
      case 'drizzle': return 'Mayda yomg\'ir';
      case 'snow': return 'Qorli';
      case 'thunderstorm': return 'Momaqaldiroq';
      case 'fog': return 'Tumanli';
      default: return 'Quyoshli';
    }
  }

  String _ratingLabel(int rating) {
    if (rating >= 80) return 'Holat: A\'lo';
    if (rating >= 60) return 'Holat: Yaxshi';
    if (rating >= 40) return 'Holat: O\'rtacha';
    if (rating >= 20) return 'Holat: Yomon';
    return 'Holat: Juda yomon';
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
          'Yuvish reytingi',
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
                    // Circular Gauge
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: CircularGaugePainter(percentage: _washRating),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _ratingLabel(_washRating),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_washRating%',
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
                                          _weatherEmoji(curType),
                                          style: const TextStyle(fontSize: 20),
                                        ),
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
                                      'Harorat: ${curTemp >= 0 ? "+" : ""}$curTemp°',
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
                          _buildConditionItem('💨', '$curWind km/h', 'Shamol'),
                          Container(width: 1, height: 40, color: AppTheme.borderGray),
                          _buildConditionItem('💧', '$curHumidity%', 'Namlik'),
                          Container(width: 1, height: 40, color: AppTheme.borderGray),
                          _buildConditionItem(_weatherEmoji(curType), _weatherLabel(curType), 'Havo'),
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
                    
                    ..._forecast.asMap().entries.map((entry) {
                      final i = entry.key;
                      final day = entry.value;
                      final weekday = i == 0 ? 'Bugun' : (day['weekday'] ?? '').toString();
                      final rating = int.tryParse(day['wash_rating']?.toString() ?? '') ?? 0;
                      final temp = (day['temp'] ?? '').toString();
                      final tempMin = (day['temp_min'] ?? '').toString();
                      final weather = (day['weather'] ?? 'sunny').toString();
                      return Padding(
                        padding: EdgeInsets.only(bottom: i < _forecast.length - 1 ? 12 : 0),
                        child: _buildForecastItem(weekday, rating, temp, tempMin, _weatherEmoji(weather)),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildConditionItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
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
          Text(emoji, style: const TextStyle(fontSize: 20)),
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
