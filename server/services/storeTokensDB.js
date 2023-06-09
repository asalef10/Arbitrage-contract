const DB = require("../DB/DB");
const tokensPrices = require("./fetchTokensPrice");

const insertTokensPrice = async () => {
  const bitcoin_Price = await tokensPrices.get_BitcoinPrice();
  const WBitcoin_Price = await tokensPrices.get_WBitcoinPrice();
  const timestamp = new Date().toISOString().slice(0, 19).replace("T", " ");

  const query = `INSERT INTO BitPrice (bitcoinPrice, wbitcoinPrice, timestamp) VALUES ('${bitcoin_Price}', '${WBitcoin_Price}', '${timestamp}')`;

  DB.QueryDB(query, (error, results) => {
    if (error) {
      console.error("Failed to insert price data:", error);
    } else {
      console.log("Price data inserted successfully.");
    }
  });
};
module.exports = insertTokensPrice;
