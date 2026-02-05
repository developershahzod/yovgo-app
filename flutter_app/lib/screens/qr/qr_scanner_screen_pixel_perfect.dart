import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class QrScannerScreenPixelPerfect extends StatefulWidget {
  const QrScannerScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  State<QrScannerScreenPixelPerfect> createState() => _QrScannerScreenPixelPerfectState();
}

class _QrScannerScreenPixelPerfectState extends State<QrScannerScreenPixelPerfect> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C13),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview placeholder (dark background)
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1A1D24),
              ),
            ),

            // Scanner frame in center
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scanner frame with animation
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        // Corner frame
                        CustomPaint(
                          size: const Size(280, 280),
                          painter: ScannerFramePainter(),
                        ),
                        // Animated scan line
                        AnimatedBuilder(
                          animation: _scanLineAnimation,
                          builder: (context, _) {
                            return Positioned(
                              top: _scanLineAnimation.value * 260 + 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.primaryCyan,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Top info button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  _showInfoDialog(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                  ),
                  child: Icon(Icons.info_outline, color: Colors.white, size: 22),
                ),
              ),
            ),

            // Bottom content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0A0C13).withOpacity(0.8),
                      const Color(0xFF0A0C13),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Scan text
                    Text(
                      'Scan For Our',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Mulish',
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Car Washing Area',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Mulish',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Mashinani almashtirish text
                    Text(
                      'Mashinani almashtirish',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Car selector
                    GestureDetector(
                      onTap: () {
                        _showCarSelector(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Car icon
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.directions_car,
                                color: AppTheme.textPrimary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Car info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BMW i7',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0F0F0),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '85',
                                          style: TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Mulish',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'O 777 OO',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Mulish',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Dropdown icon
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.textPrimary,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'QR kod skanerlash',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        content: Text(
          'Avtomoykaдаги QR kodni skanerlang va to\'lovni amalga oshiring.',
          style: TextStyle(
            fontFamily: 'Mulish',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tushunarli',
              style: TextStyle(
                color: AppTheme.primaryCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCarSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Mashinani tanlang',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 16),
            _buildCarOption('BMW i7', '85', 'O 777 OO', true),
            const SizedBox(height: 12),
            _buildCarOption('Chevrolet Tracker', '01', 'A 123 BC', false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCarOption(String name, String region, String plate, bool isSelected) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryCyan.withOpacity(0.1) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: AppTheme.primaryCyan, width: 2) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.directions_car, color: AppTheme.textPrimary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(region, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Text(plate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryCyan, size: 24),
          ],
        ),
      ),
    );
  }
}

class ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final cornerLength = 50.0;
    final radius = 20.0;

    // Top left corner
    final topLeftPath = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..lineTo(cornerLength, 0);
    canvas.drawPath(topLeftPath, paint);

    // Top right corner
    final topRightPath = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(topRightPath, paint);

    // Bottom left corner
    final bottomLeftPath = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(Offset(radius, size.height), radius: Radius.circular(radius))
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeftPath, paint);

    // Bottom right corner
    final bottomRightPath = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(Offset(size.width, size.height - radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
