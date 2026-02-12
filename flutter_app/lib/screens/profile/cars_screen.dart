import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

const _carBrands = [
  'Chevrolet', 'Kia', 'Hyundai', 'Toyota', 'BYD', 'Daewoo',
  'Lada (VAZ)', 'Ravon', 'Nissan', 'Honda', 'Mercedes-Benz',
  'BMW', 'Audi', 'Volkswagen', 'Lexus', 'Mazda', 'Mitsubishi',
  'Geely', 'Chery', 'Haval', 'Changan', 'Jetour', 'Exeed',
  'Ford', 'Renault', 'Peugeot', 'Skoda', 'Subaru', 'Suzuki',
  'Volvo', 'Porsche', 'Land Rover', 'Isuzu', 'GAZ', 'UAZ',
];

class _UzPlateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(' ', '').toUpperCase();
    final buf = StringBuffer();
    for (int i = 0; i < raw.length && i < 9; i++) {
      final c = raw[i];
      if (i < 2) { if (RegExp(r'\d').hasMatch(c)) buf.write(c); else continue; }
      else if (i == 2) { if (RegExp(r'[A-Z]').hasMatch(c)) { buf.write(' '); buf.write(c); } else continue; }
      else if (i < 6) { if (RegExp(r'\d').hasMatch(c)) { if (i == 3) buf.write(' '); buf.write(c); } else continue; }
      else { if (RegExp(r'[A-Z]').hasMatch(c)) { if (i == 6) buf.write(' '); buf.write(c); } else continue; }
    }
    final text = buf.toString();
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

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

  InputDecoration _inputDeco(String hint, {String? error}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
      errorText: error,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryCyan, width: 2)),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
    );
  }

  Future<void> _showAddDialog() async {
    final modelCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    final colorCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    String selectedType = 'sedan';
    String? selectedBrand;
    String? plateErr, yearErr, brandErr;
    final curYear = DateTime.now().year;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
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
                  _label(context.tr('vehicle_plate')),
                  TextField(
                    controller: plateCtrl,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [_UzPlateFormatter()],
                    style: const TextStyle(fontSize: 16, fontFamily: 'Mulish', fontWeight: FontWeight.w700, letterSpacing: 1.5),
                    decoration: _inputDeco('01 A 777 AA', error: plateErr),
                    onChanged: (_) { if (plateErr != null) ss(() => plateErr = null); },
                  ),
                  const SizedBox(height: 12),
                  _label(context.tr('vehicle_brand')),
                  DropdownButtonFormField<String>(
                    value: selectedBrand,
                    isExpanded: true,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w600, color: Color(0xFF0A0C13)),
                    decoration: _inputDeco('Tanlang', error: brandErr),
                    items: _carBrands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (v) => ss(() { selectedBrand = v; brandErr = null; }),
                  ),
                  const SizedBox(height: 12),
                  _label(context.tr('vehicle_model')),
                  TextField(
                    controller: modelCtrl,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w600),
                    decoration: _inputDeco('Malibu 2'),
                  ),
                  const SizedBox(height: 12),
                  Text(context.tr('vehicle_type'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: GestureDetector(
                        onTap: () => ss(() => selectedType = 'sedan'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selectedType == 'sedan' ? AppTheme.primaryCyan : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selectedType == 'sedan' ? AppTheme.primaryCyan : Colors.grey[300]!, width: selectedType == 'sedan' ? 2 : 1),
                          ),
                          child: Column(children: [
                            Icon(Icons.directions_car, size: 28, color: selectedType == 'sedan' ? Colors.white : AppTheme.textSecondary),
                            const SizedBox(height: 4),
                            Text('Yengil', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: selectedType == 'sedan' ? Colors.white : AppTheme.textPrimary)),
                          ]),
                        ),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: GestureDetector(
                        onTap: () => ss(() => selectedType = 'crossover'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selectedType == 'crossover' ? AppTheme.primaryCyan : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selectedType == 'crossover' ? AppTheme.primaryCyan : Colors.grey[300]!, width: selectedType == 'crossover' ? 2 : 1),
                          ),
                          child: Column(children: [
                            Icon(Icons.airport_shuttle, size: 28, color: selectedType == 'crossover' ? Colors.white : AppTheme.textSecondary),
                            const SizedBox(height: 4),
                            Text('Krossover', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: selectedType == 'crossover' ? Colors.white : AppTheme.textPrimary)),
                          ]),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _label(context.tr('vehicle_color')),
                        TextField(controller: colorCtrl, style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w600), decoration: _inputDeco('')),
                      ])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _label(context.tr('vehicle_year')),
                        TextField(
                          controller: yearCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                          style: const TextStyle(fontSize: 15, fontFamily: 'Mulish', fontWeight: FontWeight.w600),
                          decoration: _inputDeco('$curYear', error: yearErr),
                          onChanged: (_) { if (yearErr != null) ss(() => yearErr = null); },
                        ),
                      ])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(context.tr('cancel'), style: const TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: ElevatedButton(
                        onPressed: () async {
                          bool hasErr = false;
                          final plate = plateCtrl.text.trim();
                          if (plate.length < 11) { ss(() => plateErr = 'Format: 01 A 777 AA'); hasErr = true; }
                          if (selectedBrand == null) { ss(() => brandErr = 'Markani tanlang'); hasErr = true; }
                          if (yearCtrl.text.isNotEmpty) {
                            final y = int.tryParse(yearCtrl.text) ?? 0;
                            if (y < 1990 || y > curYear) { ss(() => yearErr = '1990-$curYear'); hasErr = true; }
                          }
                          if (hasErr) return;
                          try {
                            await FullApiService.post('/api/mobile/vehicles', data: {
                              'license_plate': plate,
                              'brand': selectedBrand,
                              'model': modelCtrl.text.trim().isNotEmpty ? modelCtrl.text.trim() : null,
                              'color': colorCtrl.text.trim().isNotEmpty ? colorCtrl.text.trim() : null,
                              'year': yearCtrl.text.isNotEmpty ? int.tryParse(yearCtrl.text) : null,
                              'vehicle_type': selectedType,
                            });
                            Navigator.pop(ctx, true);
                          } catch (e) {
                            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Xatolik: $e'), backgroundColor: Colors.red));
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryCyan, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text(context.tr('add'), style: const TextStyle(color: Colors.white, fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true) _loadVehicles();
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
