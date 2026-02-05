import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class QrScannerScreenPixelPerfect extends StatefulWidget {
  const QrScannerScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  State<QrScannerScreenPixelPerfect> createState() => _QrScannerScreenPixelPerfectState();
}

class _QrScannerScreenPixelPerfectState extends State<QrScannerScreenPixelPerfect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Dark background with QR code image
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2A2A2A),
            ),
          ),

          // QR Code image in center
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=240x240&data=YUVGO_CAR_WASH',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: Icon(Icons.qr_code, size: 180, color: Colors.black),
                  );
                },
              ),
            ),
          ),

          // Cyan scanner frame
          Center(
            child: CustomPaint(
              size: const Size(280, 280),
              painter: ScannerFramePainter(),
            ),
          ),

          // Top info button
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Icon(Icons.info_outline, color: Colors.white, size: 20),
            ),
          ),

          // Bottom content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Scan text
                Text(
                  'Scan For Our',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                    height: 1.2,
                  ),
                ),
                Text(
                  'Car Washing Area',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Mashinani almashtirish text
                Text(
                  'Mashinani almashtirish',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(height: 12),

                // Car selector
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Car icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: AppTheme.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Car info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMW i7',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
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
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '85',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'O 777 OO',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14,
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
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.textPrimary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
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

    final cornerLength = 40.0;
    final radius = 16.0;

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
