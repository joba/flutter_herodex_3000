const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());

// Replace with your actual API key or use environment variable
const API_KEY = process.env.SUPERHERO_API_KEY || "YOUR_API_KEY_HERE";
const BASE_URL = "https://superheroapi.com/api";

// Search heroes endpoint
app.get("/api/search/:name", async (req, res) => {
  try {
    const response = await fetch(
      `${BASE_URL}/${API_KEY}/search/${req.params.name}`,
    );
    const data = await response.json();
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get hero by ID endpoint
app.get("/api/:id", async (req, res) => {
  try {
    const response = await fetch(`${BASE_URL}/${API_KEY}/${req.params.id}`);
    const data = await response.json();
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`CORS proxy server running on http://localhost:${PORT}`);
  console.log(`Using API key: ${API_KEY.substring(0, 10)}...`);
});
