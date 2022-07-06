const express = require("express");
const app = express();
const cors = require("cors");

const corsOptions = {
  origin: true,
  methods: ['GET', 'PUT', 'POST'],
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

app.use(cors(corsOptions));
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/health", (req, res) => {
  res.send("Am ok!");
});

app.get("/authenticated", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify({ auth: "Ok" }));
});

app.get("/data", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify({ custom: "Am in the backend" }, null, 3));
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
