import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({Key? key}) : super(key: key);

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  int _selectedIndex = 0;
  
  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'BMW i7', 'plate': '85 | 0 777 00', 'isSelected': true},
    {'name': 'Tracker 2 redline', 'plate': '85 | 0 555 00', 'isSelected': false},
    {'name': 'Malibu 2', 'plate': '01 | 0 333 00', 'isSelected': false},
  ];

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
            onPressed: () {
              _showAddVehicleDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          return _buildVehicleItem(index);
        },
      ),
    );
  }

  Widget _buildVehicleItem(int index) {
    final vehicle = _vehicles[index];
    final isSelected = index == _selectedIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryCyan : AppTheme.borderGray,
            width: isSelected ? 2 : 1,
          ),
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
                color: isSelected ? AppTheme.primaryCyan : AppTheme.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vehicle['plate'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppTheme.primaryCyan,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mashina qo\'shish'),
        content: Text('Mashina qo\'shish funksiyasi tez orada qo\'shiladi.'),
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
