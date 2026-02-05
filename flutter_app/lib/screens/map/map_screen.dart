import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'Все';
  final List<Map<String, dynamic>> _carWashes = [
    {
      'name': 'Premium Car Wash',
      'rating': 4.9,
      'distance': '2.9 км',
      'location': 'Ташкент, Узбекистан',
      'status': 'Открыто',
      'services': ['Мойка', 'Детейлинг', 'Полировка'],
    },
    {
      'name': 'Quick Clean Mobile',
      'rating': 4.5,
      'distance': '3.8 км',
      'location': 'Ташкент, Узбекистан',
      'status': 'Открыто',
      'services': ['Мойка', 'Детейлинг', 'Полировка'],
    },
    {
      'name': 'Standard Auto Wash',
      'rating': 4.8,
      'distance': '4.8 км',
      'location': 'Ташкент, Узбекистан',
      'status': 'Открыто',
      'services': ['Мойка', 'Детейлинг', 'Полировка'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderGray),
                          boxShadow: [AppTheme.cardShadow],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Avto moykalari qidirish',
                              style: TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderGray),
                    ),
                    child: Icon(Icons.tune, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('24/7', '24/7'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Hozir ochiq', 'Ochiq'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Eng yaqin', 'Yaqin'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Reytingi', 'Reyting'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _carWashes.length,
                itemBuilder: (context, index) {
                  return _buildCarWashCard(_carWashes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryCyan : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryCyan : AppTheme.borderGray,
          ),
          boxShadow: isSelected ? [AppTheme.cardShadow] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCarWashCard(Map<String, dynamic> wash) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/car-wash-detail');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    wash['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              wash['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppTheme.primaryCyan),
                const SizedBox(width: 4),
                Text(
                  wash['distance'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.star, color: AppTheme.yellow, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${wash['rating']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
