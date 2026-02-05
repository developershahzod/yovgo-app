import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class QrScannerScreenFixed extends StatefulWidget {
  const QrScannerScreenFixed({Key? key}) : super(key: key);

  @override
  State<QrScannerScreenFixed> createState() => _QrScannerScreenFixedState();
}

class _QrScannerScreenFixedState extends State<QrScannerScreenFixed> {
  String _selectedVehicle = 'BMW i7';
  String _plateNumber = '85 | 0 777 00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera background simulation (dark gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar with info button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                          onPressed: () {
                            _showInfoDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // QR Scanner Frame
                _buildScannerFrame(),

                const SizedBox(height: 40),

                // Scan text
                const Text(
                  'Scan For Our\nCar Washing Area',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Mashinani almashtirish',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),

                const Spacer(),

                // Vehicle selector
                _buildVehicleSelector(),

                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame() {
    const double frameSize = 250;
    const double cornerLength = 40;
    const double cornerWidth = 4;

    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        children: [
          // QR Code placeholder (simulated)
          Center(
            child: Container(
              width: frameSize - 40,
              height: frameSize - 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.qr_code_2,
                size: 150,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),

          // Top-left corner
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(cornerLength, cornerWidth, true, true),
          ),

          // Top-right corner
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(cornerLength, cornerWidth, true, false),
          ),

          // Bottom-left corner
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(cornerLength, cornerWidth, false, true),
          ),

          // Bottom-right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(cornerLength, cornerWidth, false, false),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(double length, double width, bool isTop, bool isLeft) {
    return SizedBox(
      width: length,
      height: length,
      child: CustomPaint(
        painter: CornerPainter(
          color: AppTheme.primaryCyan,
          strokeWidth: width,
          isTop: isTop,
          isLeft: isLeft,
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return GestureDetector(
      onTap: () => _showVehicleSelector(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_car,
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedVehicle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _plateNumber,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleSelector() {
    final vehicles = [
      {'name': 'BMW i7', 'plate': '85 | 0 777 00'},
      {'name': 'Chevrolet Tracker', 'plate': '01 | A 555 AA'},
      {'name': 'Toyota Camry', 'plate': '70 | B 123 BC'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mashinani tanlang',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            ...vehicles.map((vehicle) => ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, color: AppTheme.textSecondary),
              ),
              title: Text(vehicle['name']!, style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(vehicle['plate']!),
              trailing: _selectedVehicle == vehicle['name'] 
                ? Icon(Icons.check_circle, color: AppTheme.primaryCyan)
                : null,
              onTap: () {
                setState(() {
                  _selectedVehicle = vehicle['name']!;
                  _plateNumber = vehicle['plate']!;
                });
                Navigator.pop(context);
              },
            )).toList(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cars');
                  },
                  icon: Icon(Icons.add),
                  label: Text('Yangi mashina qo\'shish'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryCyan,
                    side: BorderSide(color: AppTheme.primaryCyan),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('QR kod skaneri'),
        content: const Text(
          'Avtomoykalardagi QR kodni skanerlang va tashrifingizni qayd eting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tushundim',
              style: TextStyle(color: AppTheme.primaryCyan),
            ),
          ),
        ],
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isTop;
  final bool isLeft;

  CornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.isTop,
    required this.isLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
