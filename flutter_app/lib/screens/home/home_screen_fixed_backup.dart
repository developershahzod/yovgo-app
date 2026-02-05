import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/yuvgo_logo_image.dart';

class HomeScreenPixelPerfect extends StatefulWidget {
  const HomeScreenPixelPerfect({Key? key}) : super(key: key);

  @override
  State<HomeScreenPixelPerfect> createState() => _HomeScreenPixelPerfectState();
}

class _HomeScreenPixelPerfectState extends State<HomeScreenPixelPerfect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildPremiumCard(),
              const SizedBox(height: 16),
              _buildWeatherWidget(),
              const SizedBox(height: 16),
              _buildCategoriesSection(),
              const SizedBox(height: 24),
              _buildNearestCarWashesSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.85),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SizedBox(
            width: 111,
            height: 24,
            child: const YuvGoLogoImage(height: 24),
          ),
          Row(
            children: [
              // Bookmark icon
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/saved'),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.bookmark_outline,
                    size: 24,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Notification icon with badge
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/notifications'),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: AppTheme.textPrimary,
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.white.withOpacity(0.85),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '10',
                              style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/subscriptions'),
        child: Container(
          width: 343,
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryCyan,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryCyan.withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: const Color(0xFF007AFF).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Column(
            children: [
              // Top section with premium badge and security icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Premium badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: 14,
                                color: AppTheme.white,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'PREMIUM',
                                style: TextStyle(
                                  color: AppTheme.premiumCardBg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Mulish',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 90 kunlik text
                        const Text(
                          '90 kunlik',
                          style: TextStyle(
                            color: AppTheme.premiumCardBg,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Expiry date
                        const Text(
                          'Tugaydi: Yanvar 15',
                          style: TextStyle(
                            color: AppTheme.premiumCardBg,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                    // Security icon
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        Icons.security,
                        size: 28,
                        color: AppTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Bottom stats row
              Row(
                children: [
                  // Saved money card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            size: 24,
                            color: AppTheme.white,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tejalgan pul',
                                style: TextStyle(
                                  color: AppTheme.premiumCardBg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: const [
                                  Text(
                                    '120 000',
                                    style: TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'so\'m',
                                    style: TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Visits card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.history,
                            size: 24,
                            color: AppTheme.white,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Shu oy tashriflari',
                                style: TextStyle(
                                  color: AppTheme.premiumCardBg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '8/',
                                      style: TextStyle(
                                        color: AppTheme.premiumCardBg,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '12',
                                      style: TextStyle(
                                        color: AppTheme.premiumCardBg,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 343,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Wash rating row
            Row(
              children: [
                // Chart/gauge
                SizedBox(
                  width: 60,
                  height: 38,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Semi-circle gauge
                      CustomPaint(
                        size: const Size(60, 33),
                        painter: GaugePainter(percentage: 0.92),
                      ),
                      const Positioned(
                        bottom: 0,
                        child: Text(
                          '92%',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Yuvish reytingi',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: AppTheme.textTertiary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '3 kun davomida yog\'ingarchilik kutilmaydi. Yuvish uchun mukammal havo!',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Container(
              height: 1,
              color: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(height: 12),
            // Weather days
            Row(
              children: [
                _buildWeatherDay('11', Icons.wb_sunny, '+24°', '92%', true),
                const SizedBox(width: 6),
                _buildWeatherDay('12', Icons.wb_sunny, '+24°', '85%', false),
                const SizedBox(width: 6),
                _buildWeatherDay('13', Icons.wb_sunny, '+24°', '98%', false),
                const SizedBox(width: 6),
                _buildWeatherDay('14', Icons.water_drop, '+24°', '36%', false),
                const SizedBox(width: 6),
                _buildWeatherDay('15', Icons.cloud, '+24°', '24%', false),
                const SizedBox(width: 6),
                _buildWeatherDay('16', Icons.cloud, '+24°', '12%', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDay(String day, IconData icon, String temp, String percentage, bool isSelected) {
    Color iconColor;
    if (icon == Icons.wb_sunny) {
      iconColor = AppTheme.yellow;
    } else if (icon == Icons.water_drop) {
      iconColor = AppTheme.blue;
    } else {
      iconColor = const Color(0xFFC1D1E8);
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.blue : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(height: 8),
            Text(
              temp,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              percentage,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryCard('Premium avto moykalar'),
          const SizedBox(width: 8),
          _buildCategoryCard('Yangi avto\nmoykalar'),
          const SizedBox(width: 8),
          _buildCategoryCard('Premium avto moykalar'),
          const SizedBox(width: 8),
          _buildCategoryCard('Premium avto moykalar'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Container(
      width: 162,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 12,
            child: SizedBox(
              width: 138,
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: -5,
            child: Container(
              width: 109,
              height: 109,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearestCarWashesSection() {
    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eng yaqin avto moykalar',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/map'),
                child: const Text(
                  'Hammasi',
                  style: TextStyle(
                    color: AppTheme.primaryCyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Car wash cards
        SizedBox(
          height: 280,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCarWashCard(
                name: 'Black Star Car Wash',
                address: 'Matbuotchilar Street 32, Tashkent',
                distance: '500 m',
                rating: 4.6,
                status: '22:00 gacha ochiq',
                statusColor: AppTheme.primaryCyan,
                statusBgColor: AppTheme.lightCyan,
              ),
              const SizedBox(width: 12),
              _buildCarWashCard(
                name: 'Wash N Go Car Wash',
                address: 'Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent',
                distance: '900 m',
                rating: 4.6,
                status: 'Yopiq 8:00 gacha',
                statusColor: AppTheme.red,
                statusBgColor: AppTheme.lightRed,
              ),
              const SizedBox(width: 12),
              _buildCarWashCard(
                name: 'DJ Car Wash',
                address: 'Chimrobod ko\'chasi 28, Тоshkent, Toshkent',
                distance: '1.2 km',
                rating: 4.6,
                status: '24/7 ochiq',
                statusColor: AppTheme.green,
                statusBgColor: AppTheme.lightGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarWashCard({
    required String name,
    required String address,
    required String distance,
    required double rating,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/car-wash-detail'),
      child: SizedBox(
        width: 245,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Rating badge
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.yellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Gallery dots
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 4,
                              height: 4,
                              margin: EdgeInsets.only(left: index > 0 ? 4 : 0),
                              decoration: BoxDecoration(
                                color: index == 0 
                                    ? AppTheme.white 
                                    : AppTheme.white.withOpacity(0.35),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Status badge
            Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
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
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Address
            Text(
              address,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Mulish',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Distance
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: AppTheme.primaryCyan,
                ),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: const TextStyle(
                    color: AppTheme.primaryCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
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

class GaugePainter extends CustomPainter {
  final double percentage;

  GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    
    // Background arc
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFD22929),
          Color(0xFFFFD600),
          Color(0xFF5CCC27),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      3.14159, // Start from left (180 degrees)
      3.14159, // Sweep 180 degrees
      false,
      bgPaint,
    );

    // Indicator dot
    final angle = 3.14159 + (3.14159 * percentage);
    final dotX = size.width / 2 + (size.width / 2 - 3) * -1 * (1 - percentage * 2).abs().clamp(0, 1);
    final dotY = size.height - (size.height * (1 - (percentage - 0.5).abs() * 2));
    
    final dotPaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * percentage, 3),
      4,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WeatherDay {
  final String day;
  final String weekday;
  final IconData icon;
  final String temp;
  final int quality;

  WeatherDay({
    required this.day,
    required this.weekday,
    required this.icon,
    required this.temp,
    required this.quality,
  });
}
