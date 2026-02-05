import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class QrScannerWithCarsScreen extends StatefulWidget {
  const QrScannerWithCarsScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerWithCarsScreen> createState() => _QrScannerWithCarsScreenState();
}

class _QrScannerWithCarsScreenState extends State<QrScannerWithCarsScreen> {
  String? selectedCar;

  final List<Map<String, String>> cars = [
    {'name': 'BMW i7', 'number': '01 A 777 AA'},
    {'name': 'Tracker 2 Colibri', 'number': '01 777 AAA'},
    {'name': 'Malibu 2', 'number': '01 A 777 AA'},
    {'name': 'Tracker 2 Activan', 'number': '01 777 AAA'},
    {'name': 'Malibu 2', 'number': '01 A 777 AA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: AppTheme.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.flash_off, color: AppTheme.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // QR Scanner Area
            Expanded(
              flex: 3,
              child: Center(
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
                        top: -2,
                        left: -2,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.primaryCyan, width: 6),
                              left: BorderSide(color: AppTheme.primaryCyan, width: 6),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.primaryCyan, width: 6),
                              right: BorderSide(color: AppTheme.primaryCyan, width: 6),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        left: -2,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.primaryCyan, width: 6),
                              left: BorderSide(color: AppTheme.primaryCyan, width: 6),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.primaryCyan, width: 6),
                              right: BorderSide(color: AppTheme.primaryCyan, width: 6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Avtomobilingizni tanlang',
                    style: TextStyle(
                      color: AppTheme.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Car Selection List
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.borderGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          final isSelected = selectedCar == car['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCar = car['name'];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryCyan.withOpacity(0.08)
                                    : AppTheme.lightGray,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: AppTheme.primaryCyan, width: 2)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.directions_car,
                                      color: AppTheme.primaryCyan,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car['name']!,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          car['number']!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppTheme.primaryCyan,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: selectedCar != null
                              ? () {
                                  // Handle scan
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkNavy,
                            disabledBackgroundColor: AppTheme.borderGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Skanerlash',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
