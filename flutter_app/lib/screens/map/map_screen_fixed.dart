import 'package:flutter/material.dart';
import 'dart:ui';
import '../../config/app_theme.dart';

class MapScreenFixed extends StatefulWidget {
  const MapScreenFixed({Key? key}) : super(key: key);

  @override
  State<MapScreenFixed> createState() => _MapScreenFixedState();
}

class _MapScreenFixedState extends State<MapScreenFixed> {
  String _selectedFilter = '24/7';
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _expandSheet() {
    _sheetController.animateTo(
      0.95,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Stack(
        children: [
          // Map placeholder
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4E8),
            ),
            child: Image.network(
              'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/69.2401,41.2995,13,0/400x800?access_token=pk.placeholder',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8F4E8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('Map', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Map markers
          Positioned(
            top: 120,
            left: 150,
            child: _buildMapMarker('Black Star', 5.0, true),
          ),
          Positioned(
            top: 240,
            left: 50,
            child: _buildMapMarker('777 car wash', 5.0, false),
          ),

          // Current location dot
          Positioned(
            top: 220,
            right: 100,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet with snap points
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            snap: true,
            snapSizes: const [0.2, 0.5, 0.95],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Handle - draggable area
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 12, bottom: 16),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Search bar - tap to expand sheet
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: _expandSheet,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(Icons.search, color: Colors.grey[400], size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Avto moykalarni qidirish',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 15,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ),
                                Icon(Icons.close, color: Colors.grey[400], size: 24),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Filter chips
                      SizedBox(
                        height: 36,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildPremiumChip(),
                            const SizedBox(width: 8),
                            _buildFilterChip('24/7', Icons.access_time, const Color(0xFF5CCC27)),
                            const SizedBox(width: 8),
                            _buildFilterChip('Hozir ochiq', Icons.schedule, AppTheme.primaryCyan),
                            const SizedBox(width: 8),
                            _buildFilterChip('Eng yaqin', Icons.near_me, AppTheme.primaryCyan),
                            const SizedBox(width: 8),
                            _buildFilterChip('Reyting', Icons.star, Colors.amber),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Car wash list
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildCarWashCard(
                              'Black Star Car Wash',
                              'Matbuotchilar Street 32, Tashkent',
                              '500 m',
                              4.6,
                              '22:00 GACHA OCHIQ',
                              true,
                              'assets/images/194b66145883c040db1229c8b27859f09f39f78f.png',
                            ),
                            const SizedBox(height: 16),
                            _buildCarWashCard(
                              'Wash N Go Car Wash',
                              'Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent',
                              '900 m',
                              4.6,
                              'YOPIQ 8:00 GACHA',
                              false,
                              'assets/images/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png',
                            ),
                            const SizedBox(height: 16),
                            _buildCarWashCard(
                              'DJ Car Wash',
                              'Chimrobod ko\'chasi 28, Tashkent, Tashkent',
                              '1.2 km',
                              4.6,
                              '24/7 OCHIQ',
                              true,
                              'assets/images/c5a726432db7596ee5d4f6a73b2e16ddb181dc11.png',
                            ),
                            const SizedBox(height: 16),
                            _buildCarWashCard(
                              'Car wash 777',
                              'Qumariq ko\'chasi 59 Tashkent',
                              '1.5 km',
                              4.6,
                              '2 SOATDA YOPILADI',
                              true,
                              'assets/images/f1b5f4ba675e1a1231397f69c960d551e8586a15.png',
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Current location button
          Positioned(
            right: 16,
            bottom: 200,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.my_location, color: AppTheme.textPrimary, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(String name, double rating, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.primaryCyan : AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.star, color: Colors.amber, size: 14),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            'Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarWashCard(
    String name,
    String address,
    String distance,
    double rating,
    String status,
    bool isOpen,
    String imagePath,
  ) {
    final statusColor = isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with rating
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
            ),
            // Rating badge
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 14, color: statusColor),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Name
        Text(
          name,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
          ),
        ),
        const SizedBox(height: 4),
        
        // Address
        Text(
          address,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontFamily: 'Mulish',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        
        // Distance
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryCyan),
            const SizedBox(width: 4),
            Text(
              distance,
              style: TextStyle(
                color: AppTheme.primaryCyan,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
