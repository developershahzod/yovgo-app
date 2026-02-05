import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../config/app_theme.dart';

class HomeScreenFixed extends StatefulWidget {
  const HomeScreenFixed({Key? key}) : super(key: key);

  @override
  State<HomeScreenFixed> createState() => _HomeScreenFixedState();
}

class _HomeScreenFixedState extends State<HomeScreenFixed> {
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
              const SizedBox(height: 16),
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
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // YUVGO Logo
              Row(
                children: [
                  Text(
                    'YUV',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                      color: AppTheme.primaryCyan,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'GO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                      color: AppTheme.darkNavy,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Bookmark icon
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/saved'),
                    child: const Icon(
                      Icons.bookmark_outline,
                      size: 24,
                      color: AppTheme.textPrimary,
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
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFC3E3E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.85),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/subscriptions'),
        child: Container(
          width: double.infinity,
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
          child: Stack(
            children: [
              // Inner glow effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Column(
                  children: [
                    // Top section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Premium badge and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Premium badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      color: const Color(0xFFFFEEEA),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 90 kunlik
                            Text(
                              '90 kunlik',
                              style: TextStyle(
                                color: const Color(0xFFFFEEEA),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Mulish',
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Tugaydi
                            Text(
                              'Tugaydi: Yanvar 15',
                              style: TextStyle(
                                color: const Color(0xFFFFEEEA),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ],
                        ),
                        // Right side - Security icon
                        Container(
                          width: 28,
                          height: 28,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bottom section - Two info boxes
                    Row(
                      children: [
                        // Tejalgan pul box
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tejalgan pul',
                                      style: TextStyle(
                                        color: const Color(0xFFFFEEEA),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '120 000',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Mulish',
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          'so\'m',
                                          style: TextStyle(
                                            color: Colors.white,
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
                        // Shu oy tashriflari box
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shu oy tashriflari',
                                      style: TextStyle(
                                        color: const Color(0xFFFFEEEA),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '8/',
                                            style: TextStyle(
                                              color: const Color(0xFFFFEEEA),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                          TextSpan(
                                            text: '12',
                                            style: TextStyle(
                                              color: const Color(0xFFFFEEEA),
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
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Wash rating section
            Row(
              children: [
                // Gauge
                SizedBox(
                  width: 60,
                  height: 38,
                  child: CustomPaint(
                    painter: GaugePainter(92),
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
                          Expanded(
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
                            color: const Color(0xFF8F96A0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '3 kun davomida yog\'ingarchilik kutilmaydi. Yuvish uchun mukammal havo!',
                        style: TextStyle(
                          color: const Color(0xFF8F96A0),
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
            const SizedBox(height: 16),
            // Weather forecast days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDayForecast('11', '☀️', '+24°', '92%', true),
                _buildDayForecast('12', '☀️', '+24°', '85%', false),
                _buildDayForecast('13', '☀️', '+24°', '98%', false),
                _buildDayForecast('14', '🌧️', '+24°', '36%', false),
                _buildDayForecast('15', '☁️', '+24°', '24%', false),
                _buildDayForecast('16', '☁️', '+24°', '12%', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayForecast(String day, String emoji, String temp, String percent, bool isSelected) {
    return Container(
      width: 47,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isSelected ? Border.all(color: const Color(0xFF1D99F2), width: 1) : null,
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 8),
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            temp,
            style: TextStyle(
              color: const Color(0xFF8F96A0),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            percent,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
            ),
          ),
        ],
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
          _buildCategoryCard('Premium avto\nmoykalar', 'assets/images/af4f3f12083748892aa8cce089849a9c6258d073.png'),
          const SizedBox(width: 8),
          _buildCategoryCard('Yangi avto\nmoykalar', 'assets/images/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      width: 162,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
                height: 1.2,
              ),
            ),
          ),
          Positioned(
            right: -20,
            bottom: -15,
            child: Image.asset(
              imagePath,
              width: 109,
              height: 109,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 109,
                  height: 109,
                  color: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearestCarWashesSection() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eng yaqin avto moykalar',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
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
                'Black Star Car Wash',
                'Matbuotchilar Street 32, Tashkent',
                '500 m',
                4.6,
                '22:00 GACHA OCHIQ',
                true,
                'assets/images/194b66145883c040db1229c8b27859f09f39f78f.png',
              ),
              const SizedBox(width: 12),
              _buildCarWashCard(
                'Wash N Go Car Wash',
                'Tutzor mahallasi, 35 uy',
                '900 m',
                4.6,
                'YOPIQ 8:00 GACHA',
                false,
                'assets/images/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png',
              ),
            ],
          ),
        ),
      ],
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
    return Container(
      width: 245,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rating badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.asset(
                  imagePath,
                  width: 245,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 245,
                      height: 160,
                      color: AppTheme.lightGray,
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
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpen ? const Color(0xFF5CCC27).withOpacity(0.1) : const Color(0xFFFC3E3E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: isOpen ? const Color(0xFF5CCC27) : const Color(0xFFFC3E3E),
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
                    Icon(Icons.location_on, size: 16, color: AppTheme.primaryCyan),
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
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final int percentage;

  GaugePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 4;

    // Background arc
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Gradient arc
    final gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: const [
        Color(0xFFD22929),
        Color(0xFFFFD600),
        Color(0xFF5CCC27),
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );

    // Percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: const TextStyle(
          color: Color(0xFF0A0C13),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'Mulish',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height - 2),
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) => oldDelegate.percentage != percentage;
}
