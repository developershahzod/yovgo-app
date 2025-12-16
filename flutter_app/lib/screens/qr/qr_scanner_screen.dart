import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../services/visit_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final _qrTokenController = TextEditingController();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('QR Сканер'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 120,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Наведите камеру на QR код',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'QR код находится на автомойке',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Manual QR token input for testing
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Или введите код вручную',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _qrTokenController,
                      decoration: const InputDecoration(
                        hintText: 'Введите QR токен',
                        prefixIcon: Icon(Icons.qr_code),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isScanning ? null : _handleManualCheckIn,
                        child: _isScanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Отметиться'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Camera button (placeholder)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Функция камеры будет добавлена позже'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Открыть камеру'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleManualCheckIn() async {
    final qrToken = _qrTokenController.text.trim();
    
    if (qrToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите QR токен'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isScanning = true);

    try {
      final result = await VisitService.checkIn(qrToken);
      
      if (mounted) {
        setState(() => _isScanning = false);
        
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Успешно!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Вы успешно отметились на автомойке'),
                if (result?['partner_name'] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    result!['partner_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
                if (result?['visits_remaining'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Осталось визитов: ${result!['visits_remaining']}',
                    style: const TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/visits');
                },
                child: const Text('Посмотреть историю'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _qrTokenController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _qrTokenController.dispose();
    super.dispose();
  }
}
