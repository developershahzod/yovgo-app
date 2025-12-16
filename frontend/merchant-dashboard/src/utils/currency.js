// Currency formatting utility for UZS (Uzbekistan Sum)

/**
 * Format number as UZS currency
 * @param {number} amount - Amount to format
 * @param {boolean} showDecimals - Whether to show decimal places
 * @returns {string} Formatted currency string
 */
export const formatUZS = (amount, showDecimals = false) => {
  if (!amount && amount !== 0) return '0 UZS';
  
  const num = Number(amount);
  
  if (showDecimals) {
    return new Intl.NumberFormat('uz-UZ', {
      style: 'decimal',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(num) + ' UZS';
  }
  
  return new Intl.NumberFormat('uz-UZ', {
    style: 'decimal',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(num) + ' UZS';
};

/**
 * Format number with thousand separators
 * @param {number} amount - Amount to format
 * @returns {string} Formatted number
 */
export const formatNumber = (amount) => {
  if (!amount && amount !== 0) return '0';
  
  return new Intl.NumberFormat('uz-UZ').format(Number(amount));
};

/**
 * Convert USD to UZS (approximate rate)
 * @param {number} usd - Amount in USD
 * @returns {number} Amount in UZS
 */
export const usdToUZS = (usd) => {
  const rate = 12500; // Approximate exchange rate
  return usd * rate;
};

/**
 * Parse UZS string to number
 * @param {string} uzsString - UZS formatted string
 * @returns {number} Parsed number
 */
export const parseUZS = (uzsString) => {
  if (!uzsString) return 0;
  
  return Number(uzsString.replace(/[^\d]/g, ''));
};

export default {
  formatUZS,
  formatNumber,
  usdToUZS,
  parseUZS
};
