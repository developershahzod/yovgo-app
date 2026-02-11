import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  List<dynamic> _visits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final visits = await FullApiService.getVisitHistory(limit: 50);
      if (mounted) setState(() { _visits = visits; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tashriflar tarixi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visits.isEmpty
              ? _buildEmptyState()
              : _buildVisitList(),
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
              color: AppTheme.primaryCyan.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history, size: 64, color: AppTheme.primaryCyan),
          ),
          const SizedBox(height: 24),
          const Text('Tashriflar yo\'q', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Avtomoyqaga tashrif buyuring va\ntarix bu yerda ko\'rinadi',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Mulish'),
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
      itemBuilder: (context, index) => _buildVisitCard(_visits[index]),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> visit) {
    final carWashName = (visit['partner_name'] ?? visit['car_wash_name'] ?? 'Avtomoyqa').toString();
    final plate = (visit['vehicle_plate'] ?? visit['license_plate'] ?? '').toString();
    final status = (visit['status'] ?? 'completed').toString();
    DateTime? date;
    try { date = DateTime.parse(visit['created_at'] ?? visit['date'] ?? ''); } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: AppTheme.primaryCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.local_car_wash, color: AppTheme.primaryCyan, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(carWashName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: AppTheme.textPrimary)),
                if (plate.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.directions_car, size: 14, color: AppTheme.textTertiary),
                    const SizedBox(width: 4),
                    Text(plate, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
                  ]),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (date != null)
                Text(_formatDate(date), style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'Mulish')),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'completed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status == 'completed' ? 'Yakunlangan' : 'Jarayonda',
                  style: TextStyle(color: status == 'completed' ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Bugun';
    if (diff.inDays == 1) return 'Kecha';
    if (diff.inDays < 7) return '${diff.inDays} kun oldin';
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
