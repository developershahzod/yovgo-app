import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  final bool compact;

  const LanguageSelector({
    Key? key,
    this.showLabel = true,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        if (compact) {
          return _buildCompactSelector(context, languageProvider);
        }
        return _buildFullSelector(context, languageProvider);
      },
    );
  }

  Widget _buildCompactSelector(BuildContext context, LanguageProvider provider) {
    return PopupMenuButton<String>(
      onSelected: (code) => provider.setLanguage(code),
      itemBuilder: (context) => supportedLanguages.map((lang) {
        return PopupMenuItem<String>(
          value: lang.code,
          child: Row(
            children: [
              Text(lang.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(lang.nativeName),
              if (provider.languageCode == lang.code) ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.blue, size: 18),
              ],
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.languageFlag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFullSelector(BuildContext context, LanguageProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            context.tr('settings_language'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...supportedLanguages.map((lang) => _buildLanguageOption(
          context,
          provider,
          lang,
        )),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider provider,
    LanguageOption lang,
  ) {
    final isSelected = provider.languageCode == lang.code;
    
    return GestureDetector(
      onTap: () => provider.setLanguage(lang.code),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.nativeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.blue.shade700 : Colors.black87,
                    ),
                  ),
                  Text(
                    lang.name,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue.shade600, size: 24),
          ],
        ),
      ),
    );
  }
}

// Bottom sheet language selector
class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageSelectorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.tr('settings_language'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...supportedLanguages.map((lang) => _buildOption(
                context,
                provider,
                lang,
              )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context,
    LanguageProvider provider,
    LanguageOption lang,
  ) {
    final isSelected = provider.languageCode == lang.code;
    
    return ListTile(
      onTap: () {
        provider.setLanguage(lang.code);
        Navigator.pop(context);
      },
      leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        lang.nativeName,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(lang.name),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: isSelected ? Colors.blue.shade50 : null,
    );
  }
}
