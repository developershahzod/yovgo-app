import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/full_api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }
    final isLoggedIn = await FullApiService.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    // User has token — check if profile is complete (has full_name)
    final profileComplete = await FullApiService.isProfileComplete();
    if (!mounted) return;
    if (profileComplete) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Token exists but no name — send to register to complete profile
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF00BFFE),
      body: Stack(
        children: [
          // All 4 wave bands drawn in one full-screen painter
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) => Positioned.fill(
              child: CustomPaint(
                painter: _TopWavePainter(_waveController.value),
              ),
            ),
          ),

          // Centered logo
          Center(
            child: Image.asset(
              'assets/images/Logo.png',
              width: size.width * 0.58,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Wave painter: pixel-perfect match to screenshot ─────────────────────────
// 4 bands: 2 from top (scroll L→R), 2 from bottom (scroll R→L)
// Each band is ~10% screen height thick, amplitude ~6% screen height
class _TopWavePainter extends CustomPainter {
  final double t;
  _TopWavePainter(this.t);

  static const Color _navy = Color(0xFF0D1B2A);

  // Build a smooth wave path using cubic bezier curves (1 full sine cycle across width)
  Path _wavePath(Size size, double centerY, double amp, double phase) {
    final w = size.width;
    final path = Path();
    const segments = 2; // 2 full sine cycles across screen width
    final segW = w / segments;

    path.moveTo(0, centerY + amp * sin(2 * pi * phase));

    for (int i = 0; i < segments; i++) {
      final x0 = i * segW;
      final x1 = (i + 0.5) * segW;
      final x2 = (i + 1.0) * segW;
      final y0 = centerY + amp * sin(2 * pi * (x0 / w + phase));
      final y1 = centerY + amp * sin(2 * pi * (x1 / w + phase));
      final y2 = centerY + amp * sin(2 * pi * (x2 / w + phase));
      // Cubic bezier through midpoints
      path.cubicTo(
        x0 + segW * 0.25, y0,
        x1 - segW * 0.25, y1,
        x1, y1,
      );
      path.cubicTo(
        x1 + segW * 0.25, y1,
        x2 - segW * 0.25, y2,
        x2, y2,
      );
    }
    return path;
  }

  // Draw a band from screen top down to a wavy bottom edge
  void _drawTopBand(Canvas canvas, Size size, Paint paint,
      double bottomCenterY, double amp, double phase) {
    final w = size.width;
    final wavePath = _wavePath(size, bottomCenterY, amp, phase);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, bottomCenterY + amp + 2)
      ..addPath(wavePath, Offset.zero)
      ..lineTo(0, bottomCenterY + amp + 2)
      ..close();

    // Simpler approach: fill from top to wave
    final fillPath = Path();
    fillPath.moveTo(0, 0);
    fillPath.lineTo(w, 0);
    // Draw wave right edge
    fillPath.lineTo(w, bottomCenterY + amp * sin(2 * pi * (1.0 + phase)));
    // Trace wave right→left
    const steps = 120;
    for (int i = steps; i >= 0; i--) {
      final x = w * i / steps;
      final y = bottomCenterY + amp * sin(2 * pi * (x / w + phase));
      fillPath.lineTo(x, y);
    }
    fillPath.close();
    canvas.drawPath(fillPath, paint);
  }

  // Draw a floating band between two wavy edges (same phase = same shape, offset by thickness)
  void _drawFloatingBand(Canvas canvas, Size size, Paint paint,
      double topCenterY, double thickness, double amp, double phase) {
    final w = size.width;
    const steps = 120;

    final path = Path();
    // Top wave edge left→right
    for (int i = 0; i <= steps; i++) {
      final x = w * i / steps;
      final y = topCenterY + amp * sin(2 * pi * (x / w + phase));
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    // Bottom wave edge right→left (shifted down by thickness)
    for (int i = steps; i >= 0; i--) {
      final x = w * i / steps;
      final y = topCenterY + thickness + amp * sin(2 * pi * (x / w + phase));
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Draw a band from screen bottom up to a wavy top edge
  void _drawBottomBand(Canvas canvas, Size size, Paint paint,
      double topCenterY, double amp, double phase) {
    final w = size.width;
    final h = size.height;
    const steps = 120;

    final path = Path();
    // Start at top-left of wave
    path.moveTo(0, topCenterY + amp * sin(2 * pi * phase));
    // Trace wave left→right (same direction as _drawFloatingBand top edge)
    for (int i = 1; i <= steps; i++) {
      final x = w * i / steps;
      final y = topCenterY + amp * sin(2 * pi * (x / w + phase));
      path.lineTo(x, y);
    }
    // Close down to bottom-right, across bottom, up to start
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _navy..style = PaintingStyle.fill;
    final h = size.height;

    // Amplitude: ~6% of screen height for big smooth S-curves
    final amp = h * 0.06;
    // Band thickness: ~9% of screen height
    final thick = h * 0.09;

    // Top group scrolls left→right
    final phaseTop = t;
    // Bottom group scrolls right→left (opposite direction = mirror effect)
    final phaseBot = -t;

    // ── TOP: BAND 1 solid from top, wavy bottom edge at ~18% ──
    _drawTopBand(canvas, size, paint, h * 0.18, amp, phaseTop);

    // ── TOP: BAND 2 floating, top edge at ~27%, thickness 9% ──
    _drawFloatingBand(canvas, size, paint, h * 0.27, thick, amp, phaseTop);

    // ── BOTTOM: BAND 3 floating, bottom edge at ~73% (= 1 - 0.27), thickness 9% ──
    // top edge at 73%-9% = 64%
    _drawFloatingBand(canvas, size, paint, h * 0.64, thick, amp, phaseBot);

    // ── BOTTOM: BAND 4 solid from bottom, wavy top edge at ~82% (= 1 - 0.18) ──
    _drawBottomBand(canvas, size, paint, h * 0.82, amp, phaseBot);
  }

  @override
  bool shouldRepaint(_TopWavePainter old) => old.t != t;
}

// Unused — kept for compatibility
class _BottomWavePainter extends CustomPainter {
  final double t;
  _BottomWavePainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(_BottomWavePainter old) => false;
}
