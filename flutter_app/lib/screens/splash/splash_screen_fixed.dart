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
// Screenshot analysis:
//   - Cyan bg #00BFFE
//   - TOP band: navy solid from top edge, wavy bottom edge
//     Wave shape: starts HIGH on left (~10% h), dips LOW in center (~26% h),
//     rises back HIGH on right (~10% h) → 1 full inverted-U cycle
//     → achieved with -sin (or phase=0.25 offset) so left edge is at peak
//   - BOT band: exact vertical mirror of top band
//   - Wave center: 18% from top / 82% from top
//   - Amplitude: 8% of screen height
//   - Animation: both bands scroll together (same phase t)
class _TopWavePainter extends CustomPainter {
  final double t;
  _TopWavePainter(this.t);

  static const Color _navy = Color(0xFF0D1B2A);
  static const int _steps = 300;

  // Wave y at position x. Uses -sin so left edge starts at peak (band is thick),
  // dips to trough in center (band is thin), returns to peak at right edge.
  double _waveY(double x, double w, double centerY, double amp, double phase) {
    return centerY - amp * sin(2 * pi * (x / w + phase));
  }

  // Solid band from screen top down to wavy bottom edge
  void _drawTopBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final centerY = size.height * 0.18;
    final amp = size.height * 0.08;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    // Trace wave right→left
    for (int i = _steps; i >= 0; i--) {
      final x = w * i / _steps;
      path.lineTo(x, _waveY(x, w, centerY, amp, t));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Solid band from screen bottom up to wavy top edge
  void _drawBottomBand(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final centerY = h * 0.82;
    final amp = h * 0.08;

    final path = Path();
    // Trace wave left→right — bottom band uses +sin (mirror of top)
    path.moveTo(0, centerY + amp * sin(2 * pi * (0.0 + t)));
    for (int i = 1; i <= _steps; i++) {
      final x = w * i / _steps;
      path.lineTo(x, centerY + amp * sin(2 * pi * (x / w + t)));
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
