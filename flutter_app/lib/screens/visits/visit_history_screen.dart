import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/visit_service.dart';
import '../../models/visit.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({Key? key}) : super(key: key);

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  List<Visit> _visits = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final visits = await VisitService.getVisitHistory();
      
      setState(() {
        _visits = visits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки истории';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('История визитов'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVisits,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadVisits,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : _visits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 80,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'История визитов пуста',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Отсканируйте QR код на автомойке',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadVisits,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _visits.length,
                        itemBuilder: (context, index) {
                          return _buildVisitCard(_visits[index], index == 0);
                        },
                      ),
                    ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Widget _buildVisitCard(Visit visit, bool isRecent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isRecent ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_car_wash_rounded,
              color: isRecent ? AppColors.text : AppColors.iconGray,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.partnerName ?? 'Автомойка',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                if (visit.partnerAddress != null)
                  Text(
                    visit.partnerAddress!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  visit.formattedCheckInTime,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.iconGray,
          ),
        ],
      ),
    );
  }
}
