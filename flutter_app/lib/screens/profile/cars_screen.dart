import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  String? selectedCarId;

  final List<Map<String, String>> cars = [
    {'id': '1', 'name': 'BMW i7', 'plate': '85  O 777 OO'},
    {'id': '2', 'name': 'Tracker 2 redline', 'plate': '85  O 555 OO'},
    {'id': '3', 'name': 'Malibu 2', 'plate': '01  O 333 OO'},
  ];

  @override
  void initState() {
    super.initState();
    selectedCarId = cars.first['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mening mashinalarim',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          final isSelected = selectedCarId == car['id'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCarId = car['id'];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: AppTheme.primaryCyan, width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryCyan.withOpacity(0.1)
                            : AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: isSelected
                            ? AppTheme.primaryCyan
                            : AppTheme.textSecondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            car['plate']!,
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
            ),
          );
        },
      ),
    );
  }
}
