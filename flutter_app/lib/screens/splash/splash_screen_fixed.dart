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
// Screenshot: 2 full sine cycles across width, center 20%/80%, amplitude 7%
// TOP  band: navy from top, wavy bottom edge using -sin (peaks at both edges)
// BOT  band: navy from bottom, wavy top edge using +sin (exact vertical mirror)
// Both bands animated with same phase t → scroll together
class _TopWavePainter extends CustomPainter {
  final double t;
  _TopWavePainter(this.t);

  static const Color _navy = Color(0xFF0D1B2A);
  static const int _steps = 400;
  // 2 full cycles across screen width
  static const double _cycles = 2.0;

  // Top band wave: -sin gives peaks at x=0 and x=w, trough in middle
  double _topWaveY(double x, double w, double centerY, double amp) {
    return centerY - amp * sin(_cycles * 2 * pi * (x / w + t));
  }

  // Bottom band wave: +sin — exact vertical mirror of top
  double _botWaveY(double x, double w, double centerY, double amp) {
    return centerY + amp * sin(_cycles * 2 * pi * (x / w + t));
  }

  // Solid band from screen top down to wavy bottom edge
  void _drawTopBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final centerY = size.height * 0.20;
    final amp = size.height * 0.07;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    for (int i = _steps; i >= 0; i--) {
      final x = w * i / _steps;
      path.lineTo(x, _topWaveY(x, w, centerY, amp));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Solid band from screen bottom up to wavy top edge
  void _drawBottomBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final centerY = h * 0.80;
    final amp = h * 0.07;

    final path = Path();
    path.moveTo(0, _botWaveY(0, w, centerY, amp));
    for (int i = 1; i <= _steps; i++) {
      final x = w * i / _steps;
      path.lineTo(x, _botWaveY(x, w, centerY, amp));
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
