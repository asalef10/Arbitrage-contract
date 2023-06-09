const DB = require("../DB/DB");

const fetchTokensData = async () => {
  try {
    const query = `SELECT * FROM BitPriceDB.BitPrice;`;
    let data = await DB.QueryDB(query);
    return data;
  } catch (err) {
    console.log(err);
    reject(err);
  }
};

module.exports = fetchTokensData;
