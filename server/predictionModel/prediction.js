const { get_BitcoinPrice } = require("../services/fetchTokensPrice");
const MLR = require("ml-regression").MultivariateLinearRegression;

const times = [];
const prices = [];
let bitcoinPrice;
const fetchData = async () => {
  try {
    const response = await fetch("http://localhost:7000/tokens");
    const data = await response.json();

    data.forEach((item) => {
      const timestamp = new Date(item.timestamp).getTime();
      bitcoinPrice = item.bitcoinPrice;

      const wBitcoinPrice = item.wbitcoinPrice;

      times.push([timestamp, bitcoinPrice]);
      prices.push([wBitcoinPrice]);
    });
  } catch (error) {
    console.error("Error fetching data:", error);
  }
};

const getTimestampIn7Hours = () => {
  const currentTimestamp = Date.now();
  const sevenHoursFromNow = currentTimestamp + 7 * 60 * 60 * 1000;

  return sevenHoursFromNow;
};

const predictToken = async () => {
  await fetchData();

  const timestampIn7Hours = getTimestampIn7Hours();
  const bitcoinPrice = await get_BitcoinPrice();
  const regression = new MLR(times, prices);
  const nextTime = [timestampIn7Hours, bitcoinPrice];
  const nextPrice = regression.predict(nextTime);

  console.log(`Predicted Price for wbitcoin :`, nextPrice);
  return nextPrice;
};

module.exports = predictToken;
