import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../l10n/language_provider.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  const SubscriptionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppTheme.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu, color: AppTheme.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      context.tr('sub_detail_congrats'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('sub_detail_benefits_intro'),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.white.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Benefits
                    _buildBenefit(
                      icon: Icons.workspace_premium,
                      title: context.tr('sub_detail_benefit1_title'),
                      description: context.tr('sub_detail_benefit1_desc'),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildBenefit(
                      icon: Icons.store,
                      title: context.tr('sub_detail_benefit2_title'),
                      description: context.tr('sub_detail_benefit2_desc'),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildBenefit(
                      icon: Icons.attach_money,
                      title: context.tr('sub_detail_benefit3_title'),
                      description: context.tr('sub_detail_benefit3_desc'),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 3D Number
                    Center(
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Color(0xFF3B82F6).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '365',
                            style: TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.white,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF3B82F6),
                                  offset: Offset(0, 8),
                                  blurRadius: 20,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkNavy,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.tr('sub_detail_back_home'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
