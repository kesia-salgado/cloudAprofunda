import express from "express";
import { transactions } from "./data";

const app = express();
const port = 3000;

app.get("/", (_req, res) => {
  res.json({ message: "Transactions API" });
});

app.get("/transactions", (_req, res) => {
  res.json({ transactions });
});

app.listen(3000, () => {
  console.log(`Server is running on port 3000`);
});

export default app;
