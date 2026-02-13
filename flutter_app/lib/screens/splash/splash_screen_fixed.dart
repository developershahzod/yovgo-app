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
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _logoController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _waveSlide;

  @override
  void initState() {
    super.initState();

    // Wave animation — smooth continuous flowing motion
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    _waveSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );

    // Logo controller (kept for compatibility, not used for animation)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );
    _logoFade = Tween<double>(begin: 1.0, end: 1.0).animate(_logoController);
    _logoScale = Tween<double>(begin: 1.0, end: 1.0).animate(_logoController);
    _logoSlide = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_logoController);

    // Shimmer glow animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
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
    _waveController.dispose();
    _logoController.dispose();
    _shimmerController.dispose();
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF00BFFE), Color(0xFF00A8E8)],
              ),
            ),
          ),

          // Animated top waves (dark navy)
          AnimatedBuilder(
            animation: _waveSlide,
            builder: (context, child) {
              return Positioned(
                top: -30,
                left: -60,
                right: -60,
                child: CustomPaint(
                  size: Size(size.width + 120, size.height * 0.38),
                  painter: _AnimatedWavePainter(
                    isTop: true,
                    animValue: _waveSlide.value,
                  ),
                ),
              );
            },
          ),

          // Animated bottom waves (dark navy)
          AnimatedBuilder(
            animation: _waveSlide,
            builder: (context, child) {
              return Positioned(
                bottom: -30,
                left: -60,
                right: -60,
                child: CustomPaint(
                  size: Size(size.width + 120, size.height * 0.38),
                  painter: _AnimatedWavePainter(
                    isTop: false,
                    animValue: _waveSlide.value,
                  ),
                ),
              );
            },
          ),

          // Logo centered — animated entrance
          Center(
            child: SlideTransition(
              position: _logoSlide,
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15 + 0.1 * _shimmerController.value),
                              blurRadius: 30 + 15 * _shimmerController.value,
                              spreadRadius: 5 + 5 * _shimmerController.value,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedWavePainter extends CustomPainter {
  final bool isTop;
  final double animValue;

  _AnimatedWavePainter({required this.isTop, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0A0C13)
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Gentle animated horizontal offset for smooth flowing wave
    final shift = sin(animValue * 2 * pi) * w * 0.04;
    final shift2 = sin((animValue + 0.35) * 2 * pi) * w * 0.035;

    // Wave band thickness
    final bandH = h * 0.20;

    if (isTop) {
      // Wave band 1 — top edge, thick S-curve
      final p1 = Path();
      p1.moveTo(-60, 0);
      p1.lineTo(w + 60, 0);
      // Bottom edge of band 1: wide S-curve
      p1.lineTo(w + 60, h * 0.18 + shift);
      p1.cubicTo(
        w * 0.72 + shift, h * 0.02,
        w * 0.28 + shift, h * 0.42,
        -60, h * 0.12 + shift,
      );
      p1.close();
      canvas.drawPath(p1, paint);

      // Wave band 2 — below band 1 with gap, thick S-curve
      final y2Top = h * 0.30;
      final p2 = Path();
      // Top edge of band 2
      p2.moveTo(-60, y2Top + shift2);
      p2.cubicTo(
        w * 0.30 + shift2, y2Top + bandH * 1.6,
        w * 0.70 + shift2, y2Top - bandH * 0.6,
        w + 60, y2Top + bandH * 0.5 + shift2,
      );
      // Bottom edge of band 2
      p2.lineTo(w + 60, y2Top + bandH + shift2);
      p2.cubicTo(
        w * 0.70 + shift2, y2Top + bandH - bandH * 0.6,
        w * 0.30 + shift2, y2Top + bandH + bandH * 1.6,
        -60, y2Top + bandH * 0.5 + shift2,
      );
      p2.close();
      canvas.drawPath(p2, paint);
    } else {
      // Wave band 1 — upper band in bottom section
      final y1Top = h * 0.30;
      final p1 = Path();
      // Top edge
      p1.moveTo(-60, y1Top - shift);
      p1.cubicTo(
        w * 0.30 - shift, y1Top - bandH * 0.6,
        w * 0.70 - shift, y1Top + bandH * 1.6,
        w + 60, y1Top + bandH * 0.5 - shift,
      );
      // Bottom edge
      p1.lineTo(w + 60, y1Top + bandH - shift);
      p1.cubicTo(
        w * 0.70 - shift, y1Top + bandH + bandH * 1.6,
        w * 0.30 - shift, y1Top + bandH - bandH * 0.6,
        -60, y1Top + bandH * 0.5 - shift,
      );
      p1.close();
      canvas.drawPath(p1, paint);

      // Wave band 2 — bottom edge, thick S-curve
      final p2 = Path();
      // Top edge of band 2: wide S-curve
      p2.moveTo(-60, h * 0.72 - shift2);
      p2.cubicTo(
        w * 0.28 - shift2, h * 0.58,
        w * 0.72 - shift2, h * 0.98,
        w + 60, h * 0.82 - shift2,
      );
      // Fill to bottom
      p2.lineTo(w + 60, h + 30);
      p2.lineTo(-60, h + 30);
      p2.close();
      canvas.drawPath(p2, paint);
    }
  }

  @override
  bool shouldRepaint(_AnimatedWavePainter oldDelegate) => oldDelegate.animValue != animValue;
}
