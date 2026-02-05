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

  // Content for both languages
  List<Map<String, dynamic>> get _pages {
    if (_selectedLanguage == 'ru') {
      return [
        {
          'icon': Icons.workspace_premium,
          'title': 'Автомойки премиум-класса',
          'description': 'Высококачественные услуги автомойки и бережное отношение к вашему автомобилю.',
        },
        {
          'icon': Icons.qr_code_scanner,
          'title': 'Tez va oson boshqaruv',
          'description': 'QR-kodni skaner qilib, avtomobil yuvish jarayonini tez va oson boshqaring',
        },
        {
          'icon': Icons.attach_money,
          'title': 'Biz bilan pulingizni tejang',
          'description': 'Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang',
        },
      ];
    } else {
      return [
        {
          'icon': Icons.workspace_premium,
          'title': 'Premium avtomoykalar',
          'description': 'Yuqori sifatli avtomobil yuvish xizmatlari va avtomobilingizga ehtiyotkor munosabat',
        },
        {
          'icon': Icons.qr_code_scanner,
          'title': 'Tez va oson boshqaruv',
          'description': 'QR-kodni skaner qilib, avtomobil yuvish jarayonini tez va oson boshqaring',
        },
        {
          'icon': Icons.attach_money,
          'title': 'Biz bilan pulingizni tejang',
          'description': 'Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang',
        },
      ];
    }
  }

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
        child: GestureDetector(
          onTap: () {
            if (_showLanguageDropdown) {
              setState(() {
                _showLanguageDropdown = false;
              });
            }
          },
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
                          errorBuilder: (context, error, stackTrace) {
                            return Row(
                              children: [
                                Text('YUV', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryCyan)),
                                Text('GO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.darkNavy)),
                              ],
                            );
                          },
                        ),
                        // Language selector
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showLanguageDropdown = !_showLanguageDropdown;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 16,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
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
                      ],
                    ),
                  ),

                  // Page view with cards
                  Expanded(
                    flex: 5,
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildOnboardingCard(_pages[index]),
                        );
                      },
                    ),
                  ),

                  // Page indicator dots
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
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
                  ),

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
                  top: 56,
                  right: 16,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    shadowColor: Colors.black.withOpacity(0.1),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: flag,
              ),
            ),
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
        Expanded(flex: 2, child: Container(color: const Color(0xFF1EB53A))),
        Expanded(flex: 1, child: Container(color: Colors.white)),
        Expanded(flex: 2, child: Container(color: const Color(0xFFCE1126))),
      ],
    );
  }

  Widget _buildOnboardingCard(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5DD3F3),
            AppTheme.primaryCyan,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          // Inner glow effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    Colors.white.withOpacity(0.2),
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
                // Icon circle with glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    data['icon'] as IconData,
                    size: 48,
                    color: AppTheme.primaryCyan,
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  data['title'] as String,
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
                  data['description'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Mulish',
                    height: 1.5,
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
