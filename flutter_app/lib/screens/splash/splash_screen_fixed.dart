import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final token = prefs.getString('auth_token');
    
    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // For demo, go directly to main
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryCyan,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryCyan,
                  AppTheme.primaryCyan.withBlue(220),
                ],
              ),
            ),
          ),
          
          // Animated waves at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 200),
              painter: WavePainter(isTop: true),
            ),
          ),
          
          // Animated waves at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 200),
              painter: WavePainter(isTop: false),
            ),
          ),
          
          // Logo in center
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/Light BG Default.png',
                            height: 48,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                'YuvGO',
                                style: TextStyle(
                                  color: AppTheme.primaryCyan,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Mulish',
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tagline
                        Text(
                          'Avtomobil yuvish oson!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Loading indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          
          // Home indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final bool isTop;
  
  WavePainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    if (isTop) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height * 0.6);
      
      // Wave curve
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.8,
        size.width * 0.5, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4,
        size.width, size.height * 0.6,
      );
      
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height * 0.4);
      
      // Wave curve
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.2,
        size.width * 0.5, size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.6,
        size.width, size.height * 0.4,
      );
      
      path.lineTo(size.width, size.height);
      path.close();
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => false;
}
