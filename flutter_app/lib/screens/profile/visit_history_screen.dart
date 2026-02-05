import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  final List<Visit> _visits = [
    Visit(
      id: '1',
      carWashName: 'Black Star Car Wash',
      date: DateTime.now().subtract(const Duration(days: 1)),
      vehiclePlate: '01A123BC',
      status: 'completed',
    ),
    Visit(
      id: '2',
      carWashName: 'Wash House Car Wash',
      date: DateTime.now().subtract(const Duration(days: 3)),
      vehiclePlate: '01A123BC',
      status: 'completed',
    ),
    Visit(
      id: '3',
      carWashName: 'DJ Car Wash',
      date: DateTime.now().subtract(const Duration(days: 7)),
      vehiclePlate: '01B456DE',
      status: 'completed',
    ),
    Visit(
      id: '4',
      carWashName: 'Moyka 777',
      date: DateTime.now().subtract(const Duration(days: 10)),
      vehiclePlate: '01A123BC',
      status: 'completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tashriflar tarixi', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: _visits.isEmpty ? _buildEmptyState() : _buildVisitList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tashriflar yo\'q',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            'Avtomoyqaga tashrif buyuring va tarix bu yerda ko\'rinadi',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVisitList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _visits.length,
      itemBuilder: (context, index) {
        return _buildVisitCard(_visits[index]);
      },
    );
  }

  Widget _buildVisitCard(Visit visit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_car_wash,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.carWashName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      visit.vehiclePlate,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(visit.date),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Yakunlangan',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugun';
    } else if (difference.inDays == 1) {
      return 'Kecha';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} kun oldin';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }
}

class Visit {
  final String id;
  final String carWashName;
  final DateTime date;
  final String vehiclePlate;
  final String status;

  Visit({
    required this.id,
    required this.carWashName,
    required this.date,
    required this.vehiclePlate,
    required this.status,
  });
}
