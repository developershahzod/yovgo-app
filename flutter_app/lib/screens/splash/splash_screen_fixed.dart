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
      // Token exists but no name — send to login which handles name collection
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

// ─── Wave painter — pixel-perfect 2-band design ───────────────────────────────
// Screenshot analysis:
//   TOP band : navy from top edge. Wavy bottom edge.
//              Band is THIN at left edge, THICK at x≈w/4, THIN at x≈w/2,
//              THICK at x≈3w/4, THIN at right edge.
//              → bottom edge = centerY + amp * sin(2 * 2π * x/w + phase)
//              → sin starts at 0 at x=0 (thin), peaks at x=w/4 (thick)
//   BOT band : exact vertical mirror of top band.
//              Wavy top edge = centerY - amp * sin(2 * 2π * x/w + phase)
//   centerY top  = 21% of height
//   centerY bot  = 79% of height
//   amplitude    = 9% of height
//   animation    : slow scroll, 6s period
class _TopWavePainter extends CustomPainter {
  final double t; // 0..1 animation phase

  _TopWavePainter(this.t);

  static const Color _navy = Color(0xFF0D1B2A);
  static const int _steps = 500;

  // Top band bottom edge: sin starts at 0 (thin at edges), peaks at 1/4 and 3/4
  double _topEdgeY(double x, double w, double centerY, double amp) {
    return centerY + amp * sin(2 * 2 * pi * (x / w) + 2 * pi * t);
  }

  // Bottom band top edge: exact mirror of top edge
  double _botEdgeY(double x, double w, double centerY, double amp) {
    return centerY - amp * sin(2 * 2 * pi * (x / w) + 2 * pi * t);
  }

  void _drawTopBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final centerY = size.height * 0.21;
    final amp = size.height * 0.09;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    // trace wave right → left along bottom edge of band
    for (int i = _steps; i >= 0; i--) {
      final x = w * i / _steps;
      path.lineTo(x, _topEdgeY(x, w, centerY, amp));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBottomBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final centerY = h * 0.79;
    final amp = h * 0.09;

    final path = Path();
    // trace wave left → right along top edge of band
    path.moveTo(0, _botEdgeY(0, w, centerY, amp));
    for (int i = 1; i <= _steps; i++) {
      final x = w * i / _steps;
      path.lineTo(x, _botEdgeY(x, w, centerY, amp));
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
    _drawTopBand(canvas, size, paint);
    _drawBottomBand(canvas, size, paint);
  }

  @override
  bool shouldRepaint(_TopWavePainter old) => old.t != t;
}
