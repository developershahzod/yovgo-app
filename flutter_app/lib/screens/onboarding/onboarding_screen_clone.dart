import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class OnboardingScreenFixed extends StatefulWidget {
  const OnboardingScreenFixed({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenFixed> createState() => _OnboardingScreenFixedState();
}

class _OnboardingScreenFixedState extends State<OnboardingScreenFixed> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.workspace_premium,
      title: 'Автомойки премиум-класса',
      description: 'Высококачественные услуги автомойки и бережное отношение к вашему автомобилю.',
    ),
    OnboardingData(
      icon: Icons.location_on,
      title: 'Найдите ближайшую мойку',
      description: 'Легко находите автомойки рядом с вами на карте в реальном времени.',
    ),
    OnboardingData(
      icon: Icons.qr_code_scanner,
      title: 'Быстрая оплата по QR',
      description: 'Сканируйте QR-код и оплачивайте услуги мгновенно без очередей.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and language selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        ),
                      ),
                      Text(
                        'GO',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mulish',
                          color: AppTheme.darkNavy,
                        ),
                      ),
                    ],
                  ),
                  // Language selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                              image: NetworkImage('https://flagcdn.com/w40/ru.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Русский',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: AppTheme.textPrimary, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Page view with cards
            Expanded(
              child: Column(
                children: [
                  // Cards PageView
                  Expanded(
                    flex: 3,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: _buildOnboardingCard(_pages[index]),
                        );
                      },
                    ),
                  ),

                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 8 : 6,
                        height: index == _currentPage ? 8 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? AppTheme.textPrimary
                              : const Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Welcome text section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            'Добро пожаловать',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Mulish',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'YuvGO позволяет быстро и удобно управлять услугами автомойки.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mulish',
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/main');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Начинать',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
            ),

            // Home indicator
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: AppTheme.textPrimary,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingCard(OnboardingData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4DD0E1),
            AppTheme.primaryCyan,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          // Inner glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 48,
                    color: AppTheme.primaryCyan,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mulish',
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  data.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
