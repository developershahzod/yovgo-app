import translations from '../locales/ru.json';

// Simple i18n utility
export const t = (key) => {
  const keys = key.split('.');
  let value = translations;
  
  for (const k of keys) {
    if (value && typeof value === 'object') {
      value = value[k];
    } else {
      return key; // Return key if translation not found
    }
  }
  
  return value || key;
};

// Get nested translation
export const translate = t;

export default { t, translate };
