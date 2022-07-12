const express = require("express");
const app = express();
const cors = require("cors");

require("dotenv").config({ path: "../env-global" });

const corsOptions = {
  origin: true,
  methods: ["GET", "PUT", "POST"],
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

app.use(cors(corsOptions));
const port = process.env.NODE_APP_PORT;

app.get("/", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.send(JSON.stringify({ message: "Hi, this is the express backend!" }));
});

app.get("/health", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.send(JSON.stringify({ message: "Am healthy!" }));
});

app.get("/authenticated", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify({ message: "You are authenticated" }));
});
app.get("/not-authenticated", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.sendStatus(
    401,
    "application/json",
    JSON.stringify({ message: "You are not authenticated" })
  );
});

app.get("/data", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify({ message: "Data endpoint in the backend" }, null, 3));
});

app.listen(port, () => {
  console.log(`Node Express app listening on port ${port}`);
});
