const FRANKFURTER_URL = "https://api.frankfurter.dev/v2/currencies";

const FALLBACK_CURRENCIES = {
  USD: "United States Dollar",
  EUR: "Euro",
  GBP: "British Pound",
  ZAR: "South African Rand",
  JPY: "Japanese Yen",
  AUD: "Australian Dollar",
  CAD: "Canadian Dollar",
  CHF: "Swiss Franc",
  CNY: "Chinese Renminbi Yuan",
  INR: "Indian Rupee",
  BRL: "Brazilian Real",
  BWP: "Botswana Pula",
  AED: "United Arab Emirates Dirham",
  NZD: "New Zealand Dollar",
  SEK: "Swedish Krona",
  NOK: "Norwegian Krone",
  DKK: "Danish Krone",
  PLN: "Polish Zloty",
  CZK: "Czech Koruna",
  HUF: "Hungarian Forint",
  SGD: "Singapore Dollar",
  HKD: "Hong Kong Dollar",
  KRW: "South Korean Won",
  MXN: "Mexican Peso",
  TRY: "Turkish Lira",
  ILS: "Israeli New Shekel",
  RON: "Romanian Leu",
  THB: "Thai Baht",
  IDR: "Indonesian Rupiah",
  MYR: "Malaysian Ringgit",
  PHP: "Philippine Peso"
};

module.exports = async function handler(req, res) {
  res.setHeader("Cache-Control", "s-maxage=86400, stale-while-revalidate=604800");

  try {
    const response = await fetch(FRANKFURTER_URL, {
      signal: AbortSignal.timeout(8000)
    });

    if (!response.ok) {
      throw new Error(`Currency provider returned ${response.status}`);
    }

    const data = await response.json();
    const currencies = {};

    for (const item of data) {
      if (item && item.iso_code && item.name) {
        currencies[String(item.iso_code).toUpperCase()] = item.name;
      }
    }

    if (!Object.keys(currencies).length) {
      throw new Error("Currency provider returned an empty list");
    }

    return res.status(200).json({
      currencies,
      source: "Frankfurter"
    });
  } catch (error) {
    console.error("Currency list lookup failed:", error);
    return res.status(200).json({
      currencies: FALLBACK_CURRENCIES,
      source: "built-in fallback"
    });
  }
};
