const express = require("express");
const app = express();
require("dotenv").config();
const cron = require("node-cron");
const insertTokensPrice = require("./services/storeTokensDB");
const controller = require("./controller/controller");

const isWindows = () => {
  if (os.platform() === "win32") {
    return true;
  } else {
    return false;
  }
};

app.use("/", controller);
cron.schedule("*/2 * * * *", () => {
  if (isWindows()) {
    console.log("Running on localhost");
  } else {
    insertTokensPrice();
  }
});
app.listen(7000, (err) => {
  if (err) {
    console.log(err);
  } else {
    console.log("RUN ON PORT 7000");
  }
});
