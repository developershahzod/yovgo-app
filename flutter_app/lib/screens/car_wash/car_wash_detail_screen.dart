import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class CarWashDetailScreen extends StatefulWidget {
  const CarWashDetailScreen({Key? key}) : super(key: key);

  @override
  State<CarWashDetailScreen> createState() => _CarWashDetailScreenState();
}

class _CarWashDetailScreenState extends State<CarWashDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          Image.asset(
                            'assets/images/194b66145883c040db1229c8b27859f09f39f78f.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.lightGray,
                                child: Icon(Icons.image, size: 60, color: Colors.grey),
                              );
                            },
                          ),
                          Image.asset(
                            'assets/images/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: AppTheme.lightGray);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Back button
                    Positioned(
                      top: 50,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
                        ),
                      ),
                    ),
                    
                    // Bookmark and share buttons
                    Positioned(
                      top: 50,
                      right: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(Icons.bookmark_outline, color: AppTheme.textPrimary, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(Icons.ios_share, color: AppTheme.textPrimary, size: 20),
                          ),
                        ],
                      ),
                    ),
                    
                    // Page indicators
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: index == _currentPage ? 8 : 6,
                            height: index == _currentPage ? 8 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentPage
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges row
                      Row(
                        children: [
                          // Premium badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.textPrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'PREMIUM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 24/7 OCHIQ badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5CCC27).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time, color: const Color(0xFF5CCC27), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '24/7 OCHIQ',
                                  style: TextStyle(
                                    color: const Color(0xFF5CCC27),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Mulish',
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
                          color: AppTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'Black Star Car Wash bu shunchaki avtoyuvish shoxobchasi emas, bu sizning avtomobili ',
                            ),
                            TextSpan(
                              text: '...ko\'rsatish',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info cards row
                      Row(
                        children: [
                          // Wash time card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.directions_car, color: AppTheme.textPrimary, size: 24),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '~60 min',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Mulish',
                                        ),
                                      ),
                                      Text(
                                        'YUVISH VAQTI',
                                        style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Mulish',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Rating card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 24),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '5.0',
                                            style: TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.info_outline, color: AppTheme.textSecondary, size: 14),
                                        ],
                                      ),
                                      Text(
                                        'REYTING',
                                        style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Mulish',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Phone number
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5CCC27).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.phone, color: const Color(0xFF5CCC27), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '+998 93 956 6961',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                                Text(
                                  'QO\'NG\'IROQ QILISH',
                                  style: TextStyle(
                                    color: const Color(0xFF5CCC27),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Qulayliklari section
                      Text(
                        'Qulayliklari',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amenities list
                      _buildAmenityItem(Icons.weekend, 'Kutish zali'),
                      _buildAmenityItem(Icons.sports_esports, 'Ko\'ngilochar o\'yinlar'),
                      _buildAmenityItem(Icons.store, 'Do\'kon'),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Marshrut button
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.darkNavy,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.navigation, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Marshrut',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // QR kodni skanerlash button
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEB3B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner, color: AppTheme.textPrimary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'QR kodni skanerlash',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.textPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }
}
