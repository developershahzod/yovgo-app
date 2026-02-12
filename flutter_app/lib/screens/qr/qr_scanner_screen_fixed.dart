import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class QrScannerScreenFixed extends StatefulWidget {
  const QrScannerScreenFixed({Key? key}) : super(key: key);

  @override
  State<QrScannerScreenFixed> createState() => _QrScannerScreenFixedState();
}

class _QrScannerScreenFixedState extends State<QrScannerScreenFixed> {
  String _selectedVehicle = '';
  String _plateNumber = '';
  String? _selectedVehicleId;
  List<Map<String, dynamic>> _vehicles = [];
  bool _isScanning = false;
  bool _isLoggedIn = false;
  bool _hasSubscription = false;
  bool _isLoading = true;
  bool _scannedOnce = false;
  String? _lastScannedToken;
  DateTime? _lastScanTime;
  bool _scannerPaused = false;
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _loadUserState();
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _loadUserState() async {
    try {
      final loggedIn = await FullApiService.isLoggedIn();
      if (!loggedIn) {
        if (mounted) setState(() { _isLoggedIn = false; _isLoading = false; });
        return;
      }
      if (mounted) setState(() => _isLoggedIn = true);

      // Check subscription
      try {
        final res = await FullApiService.getSubscriptionStatus();
        final sub = res['subscription'] as Map<String, dynamic>?;
        if (mounted && sub != null && sub['status'] == 'active') {
          setState(() => _hasSubscription = true);
        }
      } catch (_) {}

      // Load vehicles only if logged in — prefer primary car from SharedPreferences
      try {
        final vehicles = await FullApiService.getVehicles();
        if (mounted && vehicles.isNotEmpty) {
          final list = vehicles.cast<Map<String, dynamic>>();
          // Try to load primary vehicle from SharedPreferences
          String? primaryId;
          try {
            final prefs = await SharedPreferences.getInstance();
            primaryId = prefs.getString('primary_vehicle_id');
          } catch (_) {}
          // Find primary or fallback to first
          Map<String, dynamic> selected = list.first;
          if (primaryId != null) {
            final found = list.where((v) => v['id']?.toString() == primaryId);
            if (found.isNotEmpty) selected = found.first;
          }
          setState(() {
            _vehicles = list;
            _selectedVehicle = '${selected['brand'] ?? ''} ${selected['model'] ?? ''}'.trim();
            _plateNumber = selected['plate_number'] ?? '';
            _selectedVehicleId = selected['id']?.toString();
          });
        }
      } catch (_) {}
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleQrScanned(String qrToken) async {
    if (_isScanning || _scannedOnce || _scannerPaused) return;
    // Prevent same QR within 30 seconds
    if (_lastScannedToken == qrToken && _lastScanTime != null &&
        DateTime.now().difference(_lastScanTime!).inSeconds < 30) {
      return;
    }
    _scannedOnce = true;
    _lastScannedToken = qrToken;
    _lastScanTime = DateTime.now();
    _scannerController?.stop();

    // Not logged in → go to registration
    if (!_isLoggedIn) {
      _showAuthRequiredDialog();
      return;
    }

    // No subscription → go to subscriptions
    if (!_hasSubscription) {
      _showSubscriptionRequiredDialog();
      return;
    }

    setState(() => _isScanning = true);

    try {
      final result = await FullApiService.processQrScan(
        qrToken: qrToken,
        vehicleId: _selectedVehicleId,
      );

      if (mounted) {
        setState(() => _isScanning = false);
        _showCheckinSuccessDialog(
          result['partner_name'] ?? context.tr('qr_car_wash'),
          result['remaining_visits']?.toString() ?? '',
          visitId: result['visit_id']?.toString(),
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString();
        if (msg.contains('No active subscription') || msg.contains('subscription')) {
          _showSubscriptionRequiredDialog();
        } else if (msg.contains('Visit limit reached')) {
          msg = context.tr('qr_visit_limit');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        } else if (msg.contains('401') || msg.contains('Unauthorized')) {
          _showAuthRequiredDialog();
        } else {
          msg = context.tr('qr_error_retry');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        }
        // Reset scanner state on error so user can retry
        setState(() {
          _isScanning = false;
          _scannedOnce = false;
        });
        _scannerController?.start();
      }
    }
  }

  void _showAuthRequiredDialog() {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_add_alt_1, size: 36, color: AppTheme.primaryCyan),
              ),
              const SizedBox(height: 20),
              Text(context.tr('qr_register_title'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
              const SizedBox(height: 10),
              Text(
                context.tr('qr_register_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(parentContext).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(context.tr('qr_login_btn'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(parentContext).pushNamed('/register');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryCyan,
                    side: const BorderSide(color: AppTheme.primaryCyan),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(context.tr('qr_register_btn'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.tr('qr_later'), style: const TextStyle(color: AppTheme.textSecondary, fontFamily: 'Mulish')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubscriptionRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, size: 36, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(context.tr('qr_sub_required'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
              const SizedBox(height: 10),
              Text(
                context.tr('qr_sub_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/subscriptions');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(context.tr('qr_view_plans'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.tr('qr_later'), style: const TextStyle(color: AppTheme.textSecondary, fontFamily: 'Mulish')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckinSuccessDialog(String partnerName, String remaining, {String? visitId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _WashTimerScreen(
          partnerName: partnerName,
          remaining: remaining,
          visitId: visitId,
        ),
      ),
    ).then((_) {
      // Reset scanner when user comes back from timer screen
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scannerPaused = true;
          _scannedOnce = false;
        });
        _loadUserState(); // Refresh subscription counters
        // Delay before allowing scanner to resume (prevent immediate re-scan)
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _scannerPaused = false);
            _scannerController?.start();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real camera preview
          if (!_scannerPaused)
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (_scannedOnce || _isScanning || _scannerPaused) return;
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _handleQrScanned(barcodes.first.rawValue!);
                }
              },
            ),
          // Dark overlay
          Container(color: Colors.black.withOpacity(0.4)),

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
                Text(
                  context.tr('qr_scan_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  context.tr('qr_change_car'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),

                const Spacer(),

                // Vehicle selector - only show if logged in with subscription
                if (_isLoggedIn && _hasSubscription)
                  _buildVehicleSelector()
                else if (!_isLoggedIn)
                  _buildLoginPrompt()
                else if (!_hasSubscription)
                  _buildSubscribePrompt(),

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

  Widget _buildLoginPrompt() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/login'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.primaryCyan,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('qr_login_btn'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
                  const SizedBox(height: 2),
                  Text(context.tr('qr_login_prompt_desc'), style: const TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Mulish')),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribePrompt() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/subscriptions'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.workspace_premium, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('qr_sub_buy'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
                  const SizedBox(height: 2),
                  Text(context.tr('qr_sub_desc'), style: const TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Mulish')),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
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
                    context.tr('qr_select_car'),
                    style: const TextStyle(
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
            if (_vehicles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  context.tr('qr_no_cars'),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
            ..._vehicles.map((vehicle) {
              final name = '${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}'.trim();
              final plate = vehicle['plate_number'] ?? '';
              final id = vehicle['id']?.toString();
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.directions_car, color: AppTheme.textSecondary),
                ),
                title: Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(plate),
                trailing: _selectedVehicleId == id
                  ? Icon(Icons.check_circle, color: AppTheme.primaryCyan)
                  : null,
                onTap: () {
                  setState(() {
                    _selectedVehicle = name;
                    _plateNumber = plate;
                    _selectedVehicleId = id;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
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
                  label: Text(context.tr('qr_add_car')),
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
        title: Text(context.tr('qr_info_title')),
        content: Text(
          context.tr('qr_info_desc'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr('qr_understood'),
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

// ─── Wash Timer Screen ───
class _WashTimerScreen extends StatefulWidget {
  final String partnerName;
  final String remaining;
  final String? visitId;

  const _WashTimerScreen({required this.partnerName, required this.remaining, this.visitId});

  @override
  State<_WashTimerScreen> createState() => _WashTimerScreenState();
}

class _WashTimerScreenState extends State<_WashTimerScreen> {
  late final Stopwatch _stopwatch;
  late final Stream<int> _ticker;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _ticker = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _completeVisit() async {
    if (widget.visitId == null) return;
    try {
      await FullApiService.post('/api/mobile/visits/${widget.visitId}/complete', data: {});
    } catch (_) {}
    setState(() => _completed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C13),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(context.tr('qr_wash_process'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Spacer(),

            // Partner name
            Text(widget.partnerName, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'Mulish')),
            const SizedBox(height: 24),

            // Timer circle
            Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _completed ? Colors.green : AppTheme.primaryCyan, width: 4),
              ),
              child: Center(
                child: _completed
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 56),
                          const SizedBox(height: 8),
                          Text(context.tr('qr_wash_done'), style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                        ],
                      )
                    : StreamBuilder<int>(
                        stream: _ticker,
                        builder: (context, snapshot) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_car_wash, color: AppTheme.primaryCyan, size: 36),
                              const SizedBox(height: 8),
                              Text(_fmt(_stopwatch.elapsed), style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700, fontFamily: 'Mulish', letterSpacing: 2)),
                              const SizedBox(height: 4),
                              Text(context.tr('qr_wash_in_progress'), style: const TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Mulish')),
                            ],
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Remaining visits
            if (widget.remaining.isNotEmpty && widget.remaining != 'unlimited')
              Text('${context.tr('qr_remaining_visits')}: ${widget.remaining}', style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'))
            else if (widget.remaining == 'unlimited')
              Text(context.tr('qr_unlimited_visits'), style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish')),

            const Spacer(),

            // Complete button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _completed
                      ? () => Navigator.of(context).popUntil((r) => r.isFirst)
                      : () async {
                          await _completeVisit();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _completed ? Colors.green : AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _completed ? context.tr('qr_go_home') : context.tr('qr_finish_wash'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
