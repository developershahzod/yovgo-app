import 'package:flutter/material.dart';
import 'dart:math' as math;

class IosWeatherIcon extends StatelessWidget {
  final String type;
  final double size;
  const IosWeatherIcon({Key? key, required this.type, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _IosWeatherIconPainter(type, size)),
    );
  }
}

class _IosWeatherIconPainter extends CustomPainter {
  final String type;
  final double size;
  _IosWeatherIconPainter(this.type, this.size);

  @override
  void paint(Canvas canvas, Size s) {
    switch (type) {
      case 'sunny':
        _drawSun(canvas, s);
        break;
      case 'partly_cloudy':
        _drawPartlyCloudy(canvas, s);
        break;
      case 'cloudy':
        _drawCloud(canvas, s, const Color(0xFFB0BEC5));
        break;
      case 'drizzle':
        _drawCloud(canvas, s, const Color(0xFF90A4AE));
        _drawRainDrops(canvas, s, 2);
        break;
      case 'rain':
        _drawCloud(canvas, s, const Color(0xFF78909C));
        _drawRainDrops(canvas, s, 3);
        break;
      case 'snow':
        _drawCloud(canvas, s, const Color(0xFF90CAF9));
        _drawSnowflakes(canvas, s);
        break;
      case 'thunderstorm':
        _drawCloud(canvas, s, const Color(0xFF546E7A));
        _drawLightning(canvas, s);
        break;
      case 'fog':
        _drawFog(canvas, s);
        break;
      default:
        _drawSun(canvas, s);
    }
  }

  void _drawSun(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = s.width * 0.22;
    final rayPaint = Paint()
      ..color = const Color(0xFFFFCA28)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final inner = r + 2;
      final outer = r + s.width * 0.16;
      canvas.drawLine(
        Offset(cx + inner * math.cos(angle), cy + inner * math.sin(angle)),
        Offset(cx + outer * math.cos(angle), cy + outer * math.sin(angle)),
        rayPaint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFFFFCA28));
    canvas.drawCircle(Offset(cx - r * 0.2, cy - r * 0.2), r * 0.5, Paint()..color = const Color(0xFFFFF176));
  }

  void _drawCloud(Canvas canvas, Size s, Color color) {
    final p = Paint()..color = color;
    final w = s.width, h = s.height;
    final path = Path();
    path.addOval(Rect.fromCenter(center: Offset(w * 0.35, h * 0.42), width: w * 0.4, height: h * 0.32));
    path.addOval(Rect.fromCenter(center: Offset(w * 0.55, h * 0.32), width: w * 0.45, height: h * 0.38));
    path.addOval(Rect.fromCenter(center: Offset(w * 0.7, h * 0.42), width: w * 0.35, height: h * 0.28));
    path.addRect(Rect.fromLTRB(w * 0.18, h * 0.38, w * 0.85, h * 0.55));
    canvas.drawPath(path, p);
  }

  void _drawPartlyCloudy(Canvas canvas, Size s) {
    final cx = s.width * 0.7, cy = s.height * 0.28;
    final r = s.width * 0.15;
    final rayPaint = Paint()
      ..color = const Color(0xFFFFCA28).withOpacity(0.6)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      canvas.drawLine(
        Offset(cx + (r + 1) * math.cos(angle), cy + (r + 1) * math.sin(angle)),
        Offset(cx + (r + s.width * 0.1) * math.cos(angle), cy + (r + s.width * 0.1) * math.sin(angle)),
        rayPaint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFFFFCA28));
    _drawCloud(canvas, s, const Color(0xFFE0E0E0));
  }

  void _drawRainDrops(Canvas canvas, Size s, int count) {
    final dropPaint = Paint()
      ..color = const Color(0xFF42A5F5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final startX = s.width * 0.3;
    final spacing = s.width * 0.2;
    for (int i = 0; i < count; i++) {
      final x = startX + i * spacing;
      canvas.drawLine(Offset(x, s.height * 0.62), Offset(x - 2, s.height * 0.78), dropPaint);
    }
  }

  void _drawSnowflakes(Canvas canvas, Size s) {
    final dotPaint = Paint()..color = const Color(0xFF90CAF9);
    for (final p in [
      Offset(s.width * 0.3, s.height * 0.65),
      Offset(s.width * 0.5, s.height * 0.72),
      Offset(s.width * 0.7, s.height * 0.65),
    ]) {
      canvas.drawCircle(p, 2, dotPaint);
    }
  }

  void _drawLightning(Canvas canvas, Size s) {
    final path = Path()
      ..moveTo(s.width * 0.48, s.height * 0.5)
      ..lineTo(s.width * 0.4, s.height * 0.68)
      ..lineTo(s.width * 0.52, s.height * 0.66)
      ..lineTo(s.width * 0.44, s.height * 0.88)
      ..lineTo(s.width * 0.6, s.height * 0.6)
      ..lineTo(s.width * 0.5, s.height * 0.62)
      ..lineTo(s.width * 0.56, s.height * 0.5)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD600));
  }

  void _drawFog(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final y = s.height * (0.3 + i * 0.18);
      final indent = (i % 2 == 0) ? 0.15 : 0.2;
      canvas.drawLine(Offset(s.width * indent, y), Offset(s.width * (1 - indent), y), paint);
    }
  }

  @override
  bool shouldRepaint(_IosWeatherIconPainter old) => old.type != type || old.size != size;
}
