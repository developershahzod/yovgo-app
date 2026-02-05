import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';

class CarWashDetailScreenNew extends StatefulWidget {
  const CarWashDetailScreenNew({Key? key}) : super(key: key);

  @override
  State<CarWashDetailScreenNew> createState() => _CarWashDetailScreenNewState();
}

class _CarWashDetailScreenNewState extends State<CarWashDetailScreenNew> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                Stack(
                  children: [
                    Container(
                      height: 300,
                      color: AppTheme.lightGray,
                      child: PageView.builder(
                        itemCount: 5,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            color: AppTheme.lightGray,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Page Indicators
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? AppTheme.white
                                  : AppTheme.white.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                
                // Content
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badges
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.darkNavy,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.workspace_premium, color: AppTheme.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'PREMIUM',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time, color: AppTheme.green, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '24/7 OCHIQ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Title
                            Text(
                              'Black Star',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Description
                            Text(
                              'Black Star Car Wash bu shunchaki avtoyuvish shoxobchasi emas, bu sizning avtomobilingizga g\'amxo\'rlik qiladigan joy ...ko\'rsatish',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Info Cards
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightGray,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.access_time, size: 24),
                                        const SizedBox(height: 8),
                                        Text(
                                          '~60 min',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'YUVISH VAQTI',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightGray,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star, size: 20, color: AppTheme.yellow),
                                            const SizedBox(width: 4),
                                            Text(
                                              '5.0',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'REYTING',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Phone
                            GestureDetector(
                              onTap: () => _makePhoneCall('+998939566961'),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGray,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, color: AppTheme.primaryCyan, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '+998 93 956 6961',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'QO\'NG\'IROQ QILISH',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.primaryCyan,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Amenities
                            Text(
                              'Qulayliklari',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAmenityItem(Icons.chair, 'Kutish zali'),
                            _buildAmenityItem(Icons.gamepad, 'Ko\'ngilochar o\'yinlar'),
                            _buildAmenityItem(Icons.store, 'Do\'kon'),
                            _buildAmenityItem(Icons.local_cafe, 'Cafe'),
                            
                            const SizedBox(height: 24),
                            
                            // Services
                            Text(
                              'Qo\'shimcha servislar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAmenityItem(Icons.local_car_wash, 'Detailing'),
                            _buildAmenityItem(Icons.build, 'Ustaxona'),
                            _buildAmenityItem(Icons.oil_barrel, 'Moy almashtirish'),
                            _buildAmenityItem(Icons.air, 'Yoqilg\'i quyish shohobchasi'),
                            _buildAmenityItem(Icons.ev_station, 'Elektr zaryadlash stansiyasi'),
                            
                            const SizedBox(height: 24),
                            
                            // Location
                            Text(
                              'Manzil',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: AppTheme.lightGray,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.map,
                                  size: 48,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppTheme.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Toshkent, Mirobod tumani, Mirobod shoh ko\'chasi, 66-blek A turar joy majmuasi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Working Hours
                            Text(
                              'Ish vaqti',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildWorkingHours('Dushanba - Juma', '08:00 - 02:00'),
                            _buildWorkingHours('Shanba', '08:00 - 02:00'),
                            _buildWorkingHours('Yakshanba', '08:00 - 02:00'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.bookmark_border, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.share, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkNavy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.navigation, color: AppTheme.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Marshrut',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner, color: AppTheme.darkNavy, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'QR kodni skanerlash',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Qo\'ng\'iroq qilib bo\'lmadi')),
        );
      }
    }
  }

  Widget _buildWorkingHours(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
