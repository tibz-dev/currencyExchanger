const FRANKFURTER_BASE = "https://api.frankfurter.dev";
const FALLBACK_BASE = "https://open.er-api.com/v6/latest";

function validCurrency(value) {
  return typeof value === "string" && /^[A-Za-z]{3}$/.test(value);
}

async function fetchFrankfurter(from, to) {
  const response = await fetch(
    `${FRANKFURTER_BASE}/v2/rate/${from.toLowerCase()}/${to.toLowerCase()}`,
    { signal: AbortSignal.timeout(8000) }
  );

  if (!response.ok) {
    throw new Error(`Frankfurter returned ${response.status}`);
  }

  const data = await response.json();

  if (!Number.isFinite(Number(data.rate))) {
    throw new Error("Frankfurter returned an invalid rate");
  }

  return {
    rate: Number(data.rate),
    date: data.date || null,
    provider: "Frankfurter"
  };
}

async function fetchFallback(from, to) {
  const response = await fetch(
    `${FALLBACK_BASE}/${encodeURIComponent(from)}`,
    { signal: AbortSignal.timeout(8000) }
  );

  if (!response.ok) {
    throw new Error(`Fallback provider returned ${response.status}`);
  }

  const data = await response.json();
  const rate = data.rates && Number(data.rates[to]);

  if (data.result !== "success" || !Number.isFinite(rate)) {
    throw new Error("Fallback provider returned an invalid rate");
  }

  return {
    rate,
    date: data.time_last_update_utc || null,
    provider: "ExchangeRate-API"
  };
}

module.exports = async function handler(req, res) {
  res.setHeader("Cache-Control", "s-maxage=900, stale-while-revalidate=3600");

  const from = String(req.query.from || "").toUpperCase();
  const to = String(req.query.to || "").toUpperCase();
  const amount = Number(req.query.amount ?? 1);

  if (!validCurrency(from) || !validCurrency(to)) {
    return res.status(400).json({ error: "Use valid 3-letter currency codes." });
  }

  if (!Number.isFinite(amount) || amount < 0) {
    return res.status(400).json({ error: "Amount must be a valid positive number." });
  }

  if (from === to) {
    return res.status(200).json({
      from,
      to,
      amount,
      rate: 1,
      converted: amount,
      date: null,
      provider: "Identity rate"
    });
  }

  try {
    let quote;

    try {
      quote = await fetchFrankfurter(from, to);
    } catch (primaryError) {
      quote = await fetchFallback(from, to);
    }

    return res.status(200).json({
      from,
      to,
      amount,
      rate: quote.rate,
      converted: amount * quote.rate,
      date: quote.date,
      provider: quote.provider
    });
  } catch (error) {
    console.error("Rate lookup failed:", error);
    return res.status(502).json({
      error: "Exchange-rate providers are temporarily unavailable."
    });
  }
};
