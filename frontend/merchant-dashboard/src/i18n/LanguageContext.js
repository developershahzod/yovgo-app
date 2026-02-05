import React, { createContext, useContext, useState, useEffect } from 'react';
import { translations } from './translations';

const LanguageContext = createContext();

export const LANGUAGES = {
  en: { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  ru: { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺' },
  uz: { code: 'uz', name: 'Uzbek', nativeName: "O'zbekcha", flag: '🇺🇿' },
};

export const LanguageProvider = ({ children }) => {
  const [language, setLanguage] = useState(() => {
    const saved = localStorage.getItem('merchant_language');
    return saved || 'uz'; // Default to Uzbek
  });

  useEffect(() => {
    localStorage.setItem('merchant_language', language);
    document.documentElement.lang = language;
  }, [language]);

  const t = (key) => {
    const keys = key.split('.');
    let value = translations[language];
    
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

  const changeLanguage = (lang) => {
    if (LANGUAGES[lang]) {
      setLanguage(lang);
    }
  };

  const getCurrentLanguage = () => LANGUAGES[language];

  return (
    <LanguageContext.Provider value={{ 
      language, 
      setLanguage: changeLanguage, 
      t, 
      languages: LANGUAGES,
      currentLanguage: getCurrentLanguage()
    }}>
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
