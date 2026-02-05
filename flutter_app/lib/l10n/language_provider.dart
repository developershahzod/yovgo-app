import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  Locale _locale = const Locale('uz'); // Default to Uzbek
  
  Locale get locale => _locale;
  
  String get languageCode => _locale.languageCode;
  
  String get languageName {
    switch (_locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'uz':
        return "O'zbekcha";
      default:
        return 'English';
    }
  }
  
  String get languageFlag {
    switch (_locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'ru':
        return '🇷🇺';
      case 'uz':
        return '🇺🇿';
      default:
        return '🇺🇸';
    }
  }

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'uz';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (!['en', 'ru', 'uz'].contains(languageCode)) return;
    
    _locale = Locale(languageCode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    notifyListeners();
  }

  void setEnglish() => setLanguage('en');
  void setRussian() => setLanguage('ru');
  void setUzbek() => setLanguage('uz');
}

// Extension for easy translation access
extension LocalizationExtension on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
  
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}

// Language option model
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

const List<LanguageOption> supportedLanguages = [
  LanguageOption(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flag: '🇺🇸',
  ),
  LanguageOption(
    code: 'ru',
    name: 'Russian',
    nativeName: 'Русский',
    flag: '🇷🇺',
  ),
  LanguageOption(
    code: 'uz',
    name: 'Uzbek',
    nativeName: "O'zbekcha",
    flag: '🇺🇿',
  ),
];
