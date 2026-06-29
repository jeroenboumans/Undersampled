---
name: lighthouse
description: Run a Google Lighthouse audit against the Undersampled site and summarize the Performance, Accessibility, Best-Practices and SEO scores. Use when the user asks to "run lighthouse", audit performance/SEO, or check page-quality scores. Accepts an optional URL (defaults to the live site https://undersampled.com); pass "local" to audit a locally served build.
---

# Lighthouse audit

Runs Lighthouse headlessly via `npx` and reports the four category scores plus the most impactful failing audits.

## Prerequisites (verify, don't assume)

- `node` / `npx` must be available (`node -v`). The Lighthouse CLI is fetched on demand with `npx --yes lighthouse`, so no global install is needed.
- A Chromium-based browser is required. Probe in this order and use the first that exists:
  - `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`
  - `/Applications/Chromium.app/Contents/MacOS/Chromium`
  - `/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge`
  Export it as `CHROME_PATH` for the run. If none exist, tell the user Lighthouse can't run without Chrome and stop.

## Target URL

- Default: `https://undersampled.com` (the live Netlify deploy).
- If the user passes a URL argument, use it.
- If the user passes `local`: build and serve first, then audit `http://localhost:4000`:
  ```
  docker run --rm -e JEKYLL_ENV=production -p 4000:4000 -v "$PWD":/site -w /site \
    ruby:3.4.8 bash -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
  ```
  Run that in the background, wait until the port answers, audit, then stop the container.
  Prefer auditing the live URL unless the user explicitly wants local.

## Run

Write reports to `tmp/lighthouse/` (gitignored scratch space — create it if missing; do not commit reports).

```
CHROME_PATH="<resolved chrome path>" npx --yes lighthouse "<url>" \
  --quiet \
  --chrome-flags="--headless --no-sandbox" \
  --output=json --output=html \
  --output-path="tmp/lighthouse/report" \
  --only-categories=performance,accessibility,best-practices,seo
```

This produces `tmp/lighthouse/report.report.json` and `report.report.html`.

## Report back

1. Parse the JSON and print the four category scores as percentages:
   ```
   node -e "const r=require('./tmp/lighthouse/report.report.json');for(const[k,c]of Object.entries(r.categories))console.log((c.score*100).toFixed(0).padStart(3),k,'-',c.title)"
   ```
2. Surface the top failing/opportunity audits per category (audits with `score` < 1 that have a meaningful weight or savings), so the user knows what to fix — not just the numbers.
3. Mention the path to the HTML report so the user can open it for the full breakdown.
4. Keep mobile-vs-desktop in mind: Lighthouse defaults to a throttled mobile profile. Note this; if the user wants desktop, add `--preset=desktop`.