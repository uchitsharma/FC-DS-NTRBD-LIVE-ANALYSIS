# FC->DS NTRBD — Website Dashboard (Streamlit)

Inventory-loss-saved + utilization + supply-cost-efficiency dashboard for the 65-day window
(06 Jul 2026 → 08 Sep 2026) across 5 sending FCs (2=Kochi, 10=Bangalore, 12=Kolkata, 4=Gurgaon, 2→Mumbai).

- **Purple NTRBD theme** (matches your reference deck)
- **Cached data** → instant render, works offline, no Metabase needed (default)
- **Live pull** → best-effort refresh from Metabase BigQuery (db 89), read-only SELECT
- 5 tabs: Daily Trend, 15-Day Blocks & Monthly, By FC, By Destination, Product Economics

## Run locally (2 min)

```bash
pip install -r requirements.txt
streamlit run app.py
```
Open `http://localhost:8501`.

## Live refresh (optional)

Sidebar → **Live from Metabase** → enter Session Token →
**Pull Live Data**. Read-only; if Metabase is unreachable from your network you get a graceful message
and the cached grid still renders.

## Deploy (share with team)

**Option A — Streamlit Community Cloud (free, easiest):**
1. Push this folder to GitHub (remove `data/` cache if you want, else keep for instant first render).
2. Go to `share.streamlit.io` → deploy → pick repo → deploy.
3. Build command: `pip install -r requirements.txt`. Done — public URL, auto HTTPS.

**Option B — Vercel / Railway / Hugging Face Spaces** (any Python host). Entry: `streamlit run app.py`.

**Option C — send the folder to someone:** they run `streamlit run app.py` locally.

## Data snapshot

`data/` holds the cached aggregates:
- `periodwise.json` — 15-day blocks + monthly (po, inward, breach, value, cost, sell, margin, inv_saved, eff)
- `inv_data2.json` — daily (65 days) + per-destination breakdown
- `scope.json` — PO scope, 67 dest DS
- `whdaily.json` — warehouse in/out flows
- `our_price_map.json`, `product_cost.json` — product sell/cost maps

Refresh snapshot anytime: run the master query (see `master.sql`) and update the JSONs.

## Notes / caveats
- Inventory-saved = on-time (non-breach) inward value with per-line ADD/SAVE rule (first-inbound-date vs PO day).
- Breach/caveat numbers match the Excel deliverable (571/570 breach POs, ~₹1.95 Cr value at risk).
- `master.sql` is the exact read-only SELECT; never create/alter database objects.