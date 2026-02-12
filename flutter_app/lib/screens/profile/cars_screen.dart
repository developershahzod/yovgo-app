import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  String? selectedCarId;
  List<Map<String, dynamic>> cars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPrimary = prefs.getString('primary_vehicle_id');
      final resp = await FullApiService.get('/api/mobile/vehicles/my');
      if (resp.statusCode == 200 && resp.data != null) {
        final list = (resp.data['vehicles'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        setState(() {
          cars = list;
          if (savedPrimary != null && list.any((c) => c['id'] == savedPrimary)) {
            selectedCarId = savedPrimary;
          } else if (cars.isNotEmpty) {
            selectedCarId = cars.first['id'];
          }
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _setPrimaryCar(String carId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primary_vehicle_id', carId);
    setState(() => selectedCarId = carId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('vehicle_selected')), backgroundColor: const Color(0xFF00BFFE), duration: const Duration(seconds: 2)),
      );
    }
  }

  Future<void> _showAddDialog() async {
    final brandCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    final colorCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    String selectedType = 'sedan';

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('vehicle_add'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                  const SizedBox(height: 20),
                  _buildInput(context.tr('vehicle_plate'), plateCtrl, '01 A 777 AA'),
                  const SizedBox(height: 12),
                  _buildInput(context.tr('vehicle_brand'), brandCtrl, 'Chevrolet'),
                  const SizedBox(height: 12),
                  _buildInput(context.tr('vehicle_model'), modelCtrl, 'Malibu 2'),
                  const SizedBox(height: 12),
                  // Vehicle type selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('vehicle_type'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setDialogState(() => selectedType = 'sedan'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: selectedType == 'sedan' ? AppTheme.primaryCyan : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedType == 'sedan' ? AppTheme.primaryCyan : Colors.grey[300]!,
                                    width: selectedType == 'sedan' ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.directions_car, size: 28, color: selectedType == 'sedan' ? Colors.white : AppTheme.textSecondary),
                                    const SizedBox(height: 4),
                                    Text('Yengil', style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Mulish',
                                      color: selectedType == 'sedan' ? Colors.white : AppTheme.textPrimary,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setDialogState(() => selectedType = 'crossover'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: selectedType == 'crossover' ? AppTheme.primaryCyan : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedType == 'crossover' ? AppTheme.primaryCyan : Colors.grey[300]!,
                                    width: selectedType == 'crossover' ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.airport_shuttle, size: 28, color: selectedType == 'crossover' ? Colors.white : AppTheme.textSecondary),
                                    const SizedBox(height: 4),
                                    Text('Krossover', style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Mulish',
                                      color: selectedType == 'crossover' ? Colors.white : AppTheme.textPrimary,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInput(context.tr('vehicle_color'), colorCtrl, '')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInput(context.tr('vehicle_year'), yearCtrl, '2024', isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(context.tr('cancel'), style: const TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (plateCtrl.text.trim().isEmpty || brandCtrl.text.trim().isEmpty) return;
                            try {
                              await FullApiService.post('/api/mobile/vehicles', data: {
                                'license_plate': plateCtrl.text.trim(),
                                'brand': brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                                'model': modelCtrl.text.trim().isNotEmpty ? modelCtrl.text.trim() : null,
                                'color': colorCtrl.text.trim().isNotEmpty ? colorCtrl.text.trim() : null,
                                'year': yearCtrl.text.trim().isNotEmpty ? int.tryParse(yearCtrl.text.trim()) : null,
                                'vehicle_type': selectedType,
                              });
                              Navigator.pop(ctx, true);
                            } catch (e) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text('Xatolik: $e'), backgroundColor: Colors.red),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(context.tr('add'), style: const TextStyle(color: Colors.white, fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      _loadVehicles();
    }
  }

  Widget _buildInput(String label, TextEditingController ctrl, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryCyan, width: 2)),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteVehicle(Map<String, dynamic> car) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('O\'chirish', style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
        content: Text('"${car['name'] ?? car['license_plate']}" ni o\'chirmoqchimisiz?', style: const TextStyle(fontFamily: 'Mulish')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Yo\'q')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ha, o\'chirish', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await FullApiService.delete('/api/mobile/vehicles/${car['id']}');
        _loadVehicles();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xatolik: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
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
          context.tr('vehicle_title'),
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppTheme.primaryCyan),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : cars.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(context.tr('vehicle_empty'), style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(context.tr('vehicle_add'), style: const TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                final isSelected = selectedCarId == car['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _setPrimaryCar(car['id']),
                    onLongPress: () => _deleteVehicle(car),
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
                                  car['name'] ?? car['brand'] ?? context.tr('vehicle_title'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      car['license_plate'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (car['vehicle_type'] == 'crossover') ? Colors.orange.withOpacity(0.1) : AppTheme.primaryCyan.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        (car['vehicle_type'] == 'crossover') ? 'Krossover' : 'Yengil',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: (car['vehicle_type'] == 'crossover') ? Colors.orange : AppTheme.primaryCyan,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (car['color'] != null || car['year'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      [if (car['color'] != null) car['color'], if (car['year'] != null) '${car['year']}'].join(' · '),
                                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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
