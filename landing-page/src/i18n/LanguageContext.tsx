import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { translations, Language } from './translations';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
  languages: { code: Language; name: string; nativeName: string; flag: string }[];
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const LANGUAGES = [
  { code: 'en' as Language, name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'ru' as Language, name: 'Russian', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'uz' as Language, name: 'Uzbek', nativeName: "O'zbekcha", flag: '🇺🇿' },
];

export const LanguageProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [language, setLanguageState] = useState<Language>(() => {
    const saved = localStorage.getItem('landing_language');
    return (saved as Language) || 'uz';
  });

  useEffect(() => {
    localStorage.setItem('landing_language', language);
    document.documentElement.lang = language;
  }, [language]);

  const t = (key: string): string => {
    const keys = key.split('.');
    let value: any = translations[language];

    for (const k of keys) {
      if (value && value[k]) {
        value = value[k];
      } else {
        // Fallback to English
        value = translations['en'];
        for (const fallbackKey of keys) {
          if (value && value[fallbackKey]) {
            value = value[fallbackKey];
          } else {
            return key;
          }
        }
        break;
      }
    }

    return typeof value === 'string' ? value : key;
  };

  const setLanguage = (lang: Language) => {
    if (LANGUAGES.some((l) => l.code === lang)) {
      setLanguageState(lang);
    }
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t, languages: LANGUAGES }}>
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};

export default LanguageContext;
