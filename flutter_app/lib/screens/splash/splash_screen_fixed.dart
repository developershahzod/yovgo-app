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
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final isLoggedIn = await FullApiService.isLoggedIn();
    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF00BFFE),
      body: Stack(
        children: [
          // Cyan background
          Container(color: const Color(0xFF00BFFE)),

          // Top waves (dark navy)
          Positioned(
            top: -20,
            left: -40,
            right: -40,
            child: CustomPaint(
              size: Size(size.width + 80, 220),
              painter: _SplashWavePainter(isTop: true),
            ),
          ),

          // Bottom waves (dark navy)
          Positioned(
            bottom: -20,
            left: -40,
            right: -40,
            child: CustomPaint(
              size: Size(size.width + 80, 220),
              painter: _SplashWavePainter(isTop: false),
            ),
          ),

          // YUVGO logo centered
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'YUV',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Mulish',
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'GO',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0A0C13),
                      fontFamily: 'Mulish',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashWavePainter extends CustomPainter {
  final bool isTop;
  _SplashWavePainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0A0C13)
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    if (isTop) {
      // Wave band 1 — flows from top-left down then up to top-right
      final p1 = Path();
      p1.moveTo(-40, 0);
      p1.lineTo(w + 40, 0);
      p1.lineTo(w + 40, h * 0.32);
      p1.cubicTo(w * 0.75, h * 0.05, w * 0.25, h * 0.55, -40, h * 0.18);
      p1.close();
      canvas.drawPath(p1, paint);

      // Wave band 2 — parallel S-curve below
      final p2 = Path();
      p2.moveTo(-40, h * 0.38);
      p2.cubicTo(w * 0.25, h * 0.75, w * 0.75, h * 0.22, w + 40, h * 0.55);
      p2.lineTo(w + 40, h * 0.75);
      p2.cubicTo(w * 0.75, h * 0.42, w * 0.25, h * 0.95, -40, h * 0.58);
      p2.close();
      canvas.drawPath(p2, paint);
    } else {
      // Wave band 1 — mirror of top band 2
      final p1 = Path();
      p1.moveTo(-40, h * 0.25);
      p1.cubicTo(w * 0.25, h * 0.58, w * 0.75, h * 0.05, w + 40, h * 0.42);
      p1.lineTo(w + 40, h * 0.62);
      p1.cubicTo(w * 0.75, h * 0.25, w * 0.25, h * 0.78, -40, h * 0.45);
      p1.close();
      canvas.drawPath(p1, paint);

      // Wave band 2 — flows to bottom edge
      final p2 = Path();
      p2.moveTo(-40, h * 0.68);
      p2.cubicTo(w * 0.25, h * 0.95, w * 0.75, h * 0.55, w + 40, h * 0.82);
      p2.lineTo(w + 40, h + 20);
      p2.lineTo(-40, h + 20);
      p2.close();
      canvas.drawPath(p2, paint);
    }
  }

  @override
  bool shouldRepaint(_SplashWavePainter oldDelegate) => false;
}
