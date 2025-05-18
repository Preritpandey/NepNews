require("dotenv").config();
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);

// In-memory cache
const cache = new Map();

// Zodiac signs (lowercase for easy validation)
const zodiacSigns = [
  "aries",
  "taurus",
  "gemini",
  "cancer",
  "leo",
  "virgo",
  "libra",
  "scorpio",
  "sagittarius",
  "capricorn",
  "aquarius",
  "pisces",
];

// Allowed periods
const periods = ["daily", "weekly", "monthly"];

// Helper to generate timeframe string
function getTimeframe(period) {
  const now = new Date();

  if (period === "daily") {
    return `for today (${now.toLocaleDateString("en-US", {
      month: "long",
      day: "numeric",
      year: "numeric",
    })})`;
  }

  if (period === "weekly") {
    const start = new Date(now);
    start.setDate(now.getDate() - now.getDay()); // Sunday
    const end = new Date(start);
    end.setDate(start.getDate() + 6); // Saturday

    const options = { month: "long", day: "numeric" };

    return `for the week of ${start.toLocaleDateString(
      "en-US",
      options
    )} to ${end.toLocaleDateString("en-US", { ...options, year: "numeric" })}`;
  }

  if (period === "monthly") {
    return `for the month of ${now.toLocaleDateString("en-US", {
      month: "long",
      year: "numeric",
    })}`;
  }

  return "";
}

// Main function to get horoscope — on-demand generate + cache
async function getHoroscope(req, res) {
  const sign = req.params.sign.trim().toLowerCase();
  const period = req.params.period.trim().toLowerCase();

  // Validate inputs
  if (!zodiacSigns.includes(sign)) {
    return res.status(400).json({ error: "Invalid zodiac sign." });
  }
  if (!periods.includes(period)) {
    return res.status(400).json({ error: "Invalid period. Use daily, weekly or monthly." });
  }

  const cacheKey = `${sign}_${period}`;

  // Return from cache if exists
  if (cache.has(cacheKey)) {
    console.log(`Cache hit for ${cacheKey}`);
    return res.json({ sign, period, horoscope: cache.get(cacheKey) });
  }

  // Generate on-demand if not cached
  const timeframe = getTimeframe(period);
  const prompt = `Give a ${period} horoscope ${timeframe} for the zodiac sign ${sign}, covering love, career, mood, and health. Include a lucky color and number.`;

  try {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-002" });
    const stream = await model.generateContentStream(prompt);
    let text = "";
    for await (const chunk of stream.stream) {
      text += chunk.text();
    }

    // Cache the generated horoscope
    cache.set(cacheKey, text);
    console.log(`Cached on-demand ${cacheKey}`);

    return res.json({ sign, period, horoscope: text });
  } catch (error) {
    console.error(`Failed to generate horoscope for ${cacheKey}:`, error);
    return res.status(500).json({ error: "Failed to generate horoscope." });
  }
}

module.exports = { getHoroscope };
