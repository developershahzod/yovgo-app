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
      duration: const Duration(milliseconds: 6000),
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
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
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

// ─── Wave painter — pixel-perfect design ──────────────────────────────────────
// Screenshot has 4 separate navy wave stripes:
//   TOP area (2 stripes):
//     Stripe A: solid navy from screen top down to a wavy bottom edge (~10% h)
//     Stripe B: floating navy ribbon centered at ~20% h, thickness ~6% h
//   BOTTOM area (2 stripes) — exact vertical mirror:
//     Stripe C: floating navy ribbon centered at ~80% h, thickness ~6% h
//     Stripe D: solid navy from screen bottom up to a wavy top edge (~90% h)
//   Wave shape: 1 full sine cycle across width, amplitude ~3.5% h
//   Animation: slow horizontal scroll, 6s period
class _TopWavePainter extends CustomPainter {
  final double t; // 0..1 animation phase
  _TopWavePainter(this.t);

  static const Color _navy = Color(0xFF0D1B2A);
  static const int _steps = 400;

  // Sine wave Y value — 1 cycle across width
  double _wave(double x, double w, double centerY, double amp) {
    return centerY + amp * sin(2 * pi * (x / w + t));
  }

  // Draw a floating ribbon: wavy top edge and wavy bottom edge (offset by thickness)
  void _drawRibbon(Canvas canvas, Size size, Paint paint,
      double centerFrac, double thickFrac, double ampFrac) {
    final w = size.width;
    final h = size.height;
    final center = h * centerFrac;
    final half = h * thickFrac / 2;
    final amp = h * ampFrac;

    final path = Path();
    // Top edge of ribbon left→right
    path.moveTo(0, _wave(0, w, center - half, amp));
    for (int i = 1; i <= _steps; i++) {
      final x = w * i / _steps;
      path.lineTo(x, _wave(x, w, center - half, amp));
    }
    // Bottom edge of ribbon right→left
    for (int i = _steps; i >= 0; i--) {
      final x = w * i / _steps;
      path.lineTo(x, _wave(x, w, center + half, amp));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Draw a band anchored to screen top: solid from y=0 down to wavy bottom edge
  void _drawTopAnchoredBand(Canvas canvas, Size size, Paint paint,
      double edgeCenterFrac, double ampFrac) {
    final w = size.width;
    final h = size.height;
    final centerY = h * edgeCenterFrac;
    final amp = h * ampFrac;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    for (int i = _steps; i >= 0; i--) {
      final x = w * i / _steps;
      path.lineTo(x, _wave(x, w, centerY, amp));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Draw a band anchored to screen bottom: solid from wavy top edge down to y=h
  void _drawBottomAnchoredBand(Canvas canvas, Size size, Paint paint,
      double edgeCenterFrac, double ampFrac) {
    final w = size.width;
    final h = size.height;
    final centerY = h * edgeCenterFrac;
    final amp = h * ampFrac;

    final path = Path();
    path.moveTo(0, _wave(0, w, centerY, amp));
    for (int i = 1; i <= _steps; i++) {
      final x = w * i / _steps;
      path.lineTo(x, _wave(x, w, centerY, amp));
    }
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _navy
      ..style = PaintingStyle.fill;

    // Stripe A: anchored to top edge, wavy bottom at ~10% h
    _drawTopAnchoredBand(canvas, size, paint, 0.10, 0.035);
    // Stripe B: floating ribbon centered at ~20% h, thickness ~6% h
    _drawRibbon(canvas, size, paint, 0.205, 0.06, 0.035);
    // Stripe C: floating ribbon centered at ~80% h (mirror of B)
    _drawRibbon(canvas, size, paint, 0.795, 0.06, 0.035);
    // Stripe D: anchored to bottom edge, wavy top at ~90% h (mirror of A)
    _drawBottomAnchoredBand(canvas, size, paint, 0.90, 0.035);
  }

  @override
  bool shouldRepaint(_TopWavePainter old) => old.t != t;
}
