const express = require("express");
const router = express.Router();
const tokensPrices = require("../services/fetchTokensPrice");
const fetchTokensData = require("../services/fetchTokensData")
const predictToken = require("../predictionModel/prediction");
router.get("/", async (req, res) => {
  let bitcoinPrice = await tokensPrices.get_BitcoinPrice();
  let WBitcoinPrice = await tokensPrices.get_WBitcoinPrice();
  res.json({ bitcoin_Price: bitcoinPrice, WBitcoin_Price: WBitcoinPrice });
});

router.get("/tokens", async (req, res) => {
  try {
    let data = await fetchTokensData();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

router.get("/predictToken", async (req, res) => {
  try {
    let predict = await predictToken();
    res.json({ predict_WBTC: predict });
  } catch (err) {
    res.status(500).json({ error: "Failed to predict price" });
  }
});

module.exports = router;
