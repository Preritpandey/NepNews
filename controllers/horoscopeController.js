require("dotenv").config();
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Initialize Gemini
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);

// Helper to generate date range strings
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

// Main function to get horoscope
async function getHoroscope(req, res) {
  const sign = req.params.sign.trim();
  const period = req.params.period.trim().toLowerCase();

  const timeframe = getTimeframe(period);

  const prompt = `Write a fictional, creative, and insightful ${period.toLowerCase()} horoscope ${timeframe} for the zodiac sign ${sign}. 
Include general guidance for love, career, mood, and health. 
Make it sound natural and aligned with common astrological beliefs. Feel free to include a lucky color and number.`;

  try {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-002" });
    const result = await model.generateContent(prompt);

    const horoscopeText = await result.response.text();

    res.json({ sign, period, horoscope: horoscopeText });
  } catch (error) {
    console.error("Error generating horoscope:", error);
    res.status(500).json({ error: "Failed to generate horoscope." });
  }
}

module.exports = { getHoroscope };
