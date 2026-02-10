import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';

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
      final resp = await FullApiService.get('/api/mobile/vehicles/my');
      if (resp.statusCode == 200 && resp.data != null) {
        final list = (resp.data['vehicles'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        setState(() {
          cars = list;
          if (cars.isNotEmpty) selectedCarId = cars.first['id'];
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _showAddDialog() async {
    final brandCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    final colorCtrl = TextEditingController();
    final yearCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mashina qo\'shish', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                const SizedBox(height: 20),
                _buildInput('Davlat raqami *', plateCtrl, 'Masalan: 01 A 777 AA'),
                const SizedBox(height: 12),
                _buildInput('Marka', brandCtrl, 'Masalan: Chevrolet'),
                const SizedBox(height: 12),
                _buildInput('Model', modelCtrl, 'Masalan: Malibu 2'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInput('Rang', colorCtrl, 'Oq')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInput('Yil', yearCtrl, '2024', isNumber: true)),
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
                        child: const Text('Bekor qilish', style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (plateCtrl.text.trim().isEmpty) return;
                          try {
                            await FullApiService.post('/api/mobile/vehicles', data: {
                              'license_plate': plateCtrl.text.trim(),
                              'brand': brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
                              'model': modelCtrl.text.trim().isNotEmpty ? modelCtrl.text.trim() : null,
                              'color': colorCtrl.text.trim().isNotEmpty ? colorCtrl.text.trim() : null,
                              'year': yearCtrl.text.trim().isNotEmpty ? int.tryParse(yearCtrl.text.trim()) : null,
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
                        child: const Text('Qo\'shish', style: TextStyle(color: Colors.white, fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
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
                  Text('Hali mashina qo\'shilmagan', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Mashina qo\'shish', style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
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
                    onTap: () {
                      setState(() {
                        selectedCarId = car['id'];
                      });
                    },
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
                                  car['name'] ?? car['brand'] ?? 'Mashina',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  car['license_plate'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
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
