import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../l10n/language_provider.dart';

class WashTypeSelectionScreen extends StatefulWidget {
  final String partnerName;
  final String qrToken;
  final String? vehicleId;
  final Function(String washType) onWashTypeSelected;

  const WashTypeSelectionScreen({
    Key? key,
    required this.partnerName,
    required this.qrToken,
    required this.vehicleId,
    required this.onWashTypeSelected,
  }) : super(key: key);

  @override
  State<WashTypeSelectionScreen> createState() => _WashTypeSelectionScreenState();
}

class _WashTypeSelectionScreenState extends State<WashTypeSelectionScreen> {
  String? _selectedWashType;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _washTypes = [
    {
      'id': 'express',
      'name_uz': 'Express',
      'name_ru': 'Экспресс',
      'name_en': 'Express',
      'description_uz': 'Без протирки',
      'description_ru': 'Без протирки',
      'description_en': 'Without wiping',
      'icon': Icons.flash_on,
      'color': Color(0xFFFF6B00),
    },
    {
      'id': 'sedan',
      'name_uz': 'Sedan',
      'name_ru': 'Седан',
      'name_en': 'Sedan',
      'description_uz': 'Standart yuvish',
      'description_ru': 'Стандартная мойка',
      'description_en': 'Standard wash',
      'icon': Icons.directions_car,
      'color': AppTheme.primaryCyan,
    },
    {
      'id': 'krossover',
      'name_uz': 'Krossover',
      'name_ru': 'Кроссовер',
      'name_en': 'Crossover',
      'description_uz': 'Katta avtomobillar uchun',
      'description_ru': 'Для больших авто',
      'description_en': 'For larger vehicles',
      'icon': Icons.airport_shuttle,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'minivan',
      'name_uz': 'Minivan',
      'name_ru': 'Минивэн',
      'name_en': 'Minivan',
      'description_uz': 'Minivan va katta avtolar',
      'description_ru': 'Минивэн и большие авто',
      'description_en': 'Minivan and large cars',
      'icon': Icons.rv_hookup,
      'color': Color(0xFF9C27B0),
    },
    {
      'id': 'suv',
      'name_uz': 'SUV',
      'name_ru': 'Внедорожник',
      'name_en': 'SUV',
      'description_uz': 'Katta SUV va jeeplar',
      'description_ru': 'Большие SUV и джипы',
      'description_en': 'Large SUVs and jeeps',
      'icon': Icons.local_shipping,
      'color': Color(0xFF795548),
    },
  ];

  String _getLocalizedName(Map<String, dynamic> washType) {
    final lang = context.read<LanguageProvider>().languageCode;
    return washType['name_$lang'] ?? washType['name_uz'];
  }

  String _getLocalizedDescription(Map<String, dynamic> washType) {
    final lang = context.read<LanguageProvider>().languageCode;
    return washType['description_$lang'] ?? washType['description_uz'];
  }

  void _confirmSelection() {
    if (_selectedWashType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('wash_type_select_required')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    widget.onWashTypeSelected(_selectedWashType!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C13),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    context.tr('wash_type_title'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Success checkmark
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              context.tr('wash_type_scan_success'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
              ),
            ),

            const SizedBox(height: 8),

            // Partner name
            Text(
              widget.partnerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontFamily: 'Mulish',
              ),
            ),

            const SizedBox(height: 24),

            // Instruction text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.tr('wash_type_select_instruction'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Wash type options
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _washTypes.length,
                itemBuilder: (context, index) {
                  final washType = _washTypes[index];
                  final isSelected = _selectedWashType == washType['id'];

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedWashType = washType['id']);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? washType['color'].withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? washType['color']
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: washType['color'].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              washType['icon'],
                              color: washType['color'],
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getLocalizedName(washType),
                                  style: TextStyle(
                                    color: isSelected ? washType['color'] : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getLocalizedDescription(washType),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: washType['color'],
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppTheme.primaryCyan.withOpacity(0.5),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          context.tr('wash_type_confirm'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
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
