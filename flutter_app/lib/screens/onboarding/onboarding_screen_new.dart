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
  String _selectedLanguage = 'ru';
  bool _showLanguageDropdown = false;

  // Russian content
  final List<OnboardingData> _pagesRu = [
    OnboardingData(
      icon: Icons.workspace_premium,
      title: 'Автомойки премиум-класса',
      description: 'Высококачественные услуги автомойки и бережное отношение к вашему автомобилю.',
    ),
    OnboardingData(
      icon: Icons.qr_code_scanner,
      title: 'Tez va oson boshqaruv',
      description: 'QR-kodni skaner qilib, avtomobil yuvish jarayonini tez va oson boshqaring',
    ),
    OnboardingData(
      icon: Icons.attach_money,
      title: 'Biz bilan pulingizni tejang',
      description: 'Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang',
    ),
  ];

  // Uzbek content
  final List<OnboardingData> _pagesUz = [
    OnboardingData(
      icon: Icons.workspace_premium,
      title: 'Premium avtomoykalar',
      description: 'Yuqori sifatli avtomobil yuvish xizmatlari va avtomobilingizga ehtiyotkor munosabat',
    ),
    OnboardingData(
      icon: Icons.qr_code_scanner,
      title: 'Tez va oson boshqaruv',
      description: 'QR-kodni skaner qilib, avtomobil yuvish jarayonini tez va oson boshqaring',
    ),
    OnboardingData(
      icon: Icons.attach_money,
      title: 'Biz bilan pulingizni tejang',
      description: 'Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang',
    ),
  ];

  List<OnboardingData> get _pages => _selectedLanguage == 'ru' ? _pagesRu : _pagesUz;
  
  String get _welcomeTitle => _selectedLanguage == 'ru' ? 'Добро пожаловать' : 'Xush kelibsiz';
  String get _welcomeDescription => _selectedLanguage == 'ru' 
      ? 'YuvGO позволяет быстро и удобно управлять услугами автомойки.'
      : 'YuvGO avtomobil yuvish xizmatlarini tez va qulay tarzda boshqarish imkonini beradi.';
  String get _buttonText => _selectedLanguage == 'ru' ? 'Начинать' : 'Boshlash';
  String get _languageText => _selectedLanguage == 'ru' ? 'Русский' : 'O\'zbekcha';

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
        child: Stack(
          children: [
            Column(
              children: [
                // Top bar with logo and language selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // YUVGO Logo from image
                      Image.asset(
                        'assets/images/Light BG Default.png',
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      // Language selector
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showLanguageDropdown = !_showLanguageDropdown;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[300],
                                ),
                                child: _selectedLanguage == 'ru'
                                    ? _buildRussianFlag()
                                    : _buildUzbekFlag(),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _languageText,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _showLanguageDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: AppTheme.textPrimary,
                                size: 20,
                              ),
                            ],
                          ),
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
                                _welcomeTitle,
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
                                _welcomeDescription,
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
                        _buttonText,
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

            // Language dropdown overlay
            if (_showLanguageDropdown)
              Positioned(
                top: 60,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption('ru', 'Русский', _buildRussianFlag()),
                        Divider(height: 1, color: Colors.grey[200]),
                        _buildLanguageOption('uz', 'O\'zbekcha', _buildUzbekFlag()),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name, Widget flag) {
    final isSelected = _selectedLanguage == code;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
          _showLanguageDropdown = false;
          _pageController.jumpToPage(0);
          _currentPage = 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 24, height: 16, child: flag),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: AppTheme.primaryCyan, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRussianFlag() {
    return Column(
      children: [
        Expanded(child: Container(color: Colors.white)),
        Expanded(child: Container(color: const Color(0xFF0039A6))),
        Expanded(child: Container(color: const Color(0xFFD52B1E))),
      ],
    );
  }

  Widget _buildUzbekFlag() {
    return Column(
      children: [
        Expanded(child: Container(color: const Color(0xFF1EB53A))),
        Expanded(child: Container(color: Colors.white)),
        Expanded(child: Container(color: const Color(0xFFCE1126))),
      ],
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
