import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/qr_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? selectedCar;
  bool _isScanning = false;
  final TextEditingController _qrTokenController = TextEditingController();
  
  final List<Map<String, String>> cars = [
    {'name': 'BMW i7', 'plate': '85 O 777 OO'},
    {'name': 'Tracker 2 Colibri', 'plate': '01 777 AAA'},
    {'name': 'Malibu 2', 'plate': '01 A 777 AA'},
  ];

  @override
  void initState() {
    super.initState();
    selectedCar = cars.first['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkNavy,
      body: Stack(
        children: [
          // QR Scanner Area
          Column(
            children: [
              // Top Bar
              SafeArea(
                child: Padding(
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
                        child: Icon(
                          Icons.info_outline,
                          color: AppTheme.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // QR Frame
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryCyan,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Corner decorations
                      Positioned(
                        top: -3,
                        left: -3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.primaryCyan, width: 8),
                              left: BorderSide(color: AppTheme.primaryCyan, width: 8),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -3,
                        right: -3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.primaryCyan, width: 8),
                              right: BorderSide(color: AppTheme.primaryCyan, width: 8),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        left: -3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.primaryCyan, width: 8),
                              left: BorderSide(color: AppTheme.primaryCyan, width: 8),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.primaryCyan, width: 8),
                              right: BorderSide(color: AppTheme.primaryCyan, width: 8),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      // QR Code placeholder
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          color: AppTheme.white,
                          child: Center(
                            child: Text(
                              'QR',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkNavy,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Title
              Text(
                'Scan For Our',
                style: TextStyle(
                  color: AppTheme.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Car Washing Area',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mashinani almashtirish',
                style: TextStyle(
                  color: AppTheme.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              
              const Spacer(),
            ],
          ),
          
          // Bottom Car Selection
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Avtomobilni tanlang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...cars.map((car) => _buildCarOption(car)).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleManualCheckIn() async {
    final qrToken = _qrTokenController.text.trim();
    
    if (qrToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR tokeni kiriting'),
          backgroundColor: AppTheme.red,
        ),
      );
      return;
    }

    setState(() => _isScanning = true);

    try {
      final result = await QRService.checkIn(qrToken);
      
      if (mounted) {
        setState(() => _isScanning = false);
        
        if (result != null && result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Tashrif muvaffaqiyatli ro\'yxatdan o\'tkazildi!',
              ),
              backgroundColor: AppTheme.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          
          _qrTokenController.clear();
          
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR kod noto\'g\'ri yoki muddati o\'tgan'),
              backgroundColor: AppTheme.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xatolik yuz berdi: ${e.toString()}'),
            backgroundColor: AppTheme.red,
          ),
        );
      }
    }
  }

  Widget _buildCarOption(Map<String, String> car) {
    final isSelected = selectedCar == car['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCar = car['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryCyan.withOpacity(0.1) : AppTheme.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryCyan : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.directions_car,
              color: isSelected ? AppTheme.primaryCyan : AppTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    car['plate'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryCyan),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _qrTokenController.dispose();
    super.dispose();
  }
}
