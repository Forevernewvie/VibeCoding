import express from "express";
import fetch from "node-fetch";

const app = express();
const PORT = process.env.PORT || 8787;

// Put your TTB key in env var
const TTB_KEY = process.env.TTB_KEY;
if (!TTB_KEY) {
  console.warn("WARNING: TTB_KEY env var is not set. Requests will fail.");
}

// /aladin/ItemSearch.aspx?Query=...&...
app.get("/aladin/:endpoint", async (req, res) => {
  try {
    const endpoint = req.params.endpoint;
    const upstream = new URL(`http://www.aladin.co.kr/ttb/api/${endpoint}`);

    // copy query, inject ttbkey
    for (const [k, v] of Object.entries(req.query)) {
      upstream.searchParams.set(k, String(v));
    }
    upstream.searchParams.set("ttbkey", TTB_KEY);

    const r = await fetch(upstream.toString());
    const text = await r.text();
    res.status(r.status);
    res.setHeader("content-type", r.headers.get("content-type") || "application/json; charset=utf-8");
    res.setHeader("cache-control", "public, max-age=60");
    res.send(text);
  } catch (e) {
    res.status(500).send(String(e));
  }
});

app.listen(PORT, () => {
  console.log(`Aladin proxy listening on http://localhost:${PORT}`);
});
