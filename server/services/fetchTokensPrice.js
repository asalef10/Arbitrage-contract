const DB = require("../DB/DB");
const get_BitcoinPrice = async () => {
  try {
    const response = await fetch(
      "https://api.coindesk.com/v1/bpi/currentprice/BTC.json"
    );
    const result = await response.json();
    const priceData = result.bpi.USD;
    return priceData.rate_float;
  } catch (error) {
    console.error("Failed to retrieve Bitcoin price:", error);
    return null;
  }
};
const get_WBitcoinPrice = async () => {
  try {
    const response = await fetch(
      "https://api.coingecko.com/api/v3/simple/price?ids=wrapped-bitcoin&vs_currencies=usd"
    );
    const result = await response.json();
    const priceData = result["wrapped-bitcoin"].usd;
    return priceData;
  } catch (error) {
    console.error("Failed to retrieve Wrapped Bitcoin price:", error);
    return null;
  }
};
module.exports = { get_BitcoinPrice, get_WBitcoinPrice };
