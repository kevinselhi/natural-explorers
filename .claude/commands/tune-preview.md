---
description: Learn from tuner.html ratings (or refresh the suggestions) to train the site-evolver's taste
---

Drive the taste-training loop that sits above `/evolve-site`. Kevin rates ideas in `tuner.html`; this
turns those ratings into a learned profile (`.claude/evolve-preferences.md`) that the `site-evolver`
reads before proposing real changes. **Nothing here edits the actual site** — it only trains judgment.

Run from the repo root (`/Users/kevinselhi/natural-explorers`). Repo: `kevinselhi/natural-explorers`.

## Steps

1. **Sync:** `git pull --ff-only`.

2. **Check for ratings:**
   ```
   gh issue list --repo kevinselhi/natural-explorers --state open --label tuner-feedback --json number,title
   ```

3. **Dispatch the `preview-tuner` subagent** (via the Agent tool):
   - **If there are open `tuner-feedback` issues** → run it in **LEARN** mode: read each issue, update
     `.claude/evolve-preferences.md` with the distilled taste, push, comment + close the issues, then
     refresh `tuner.html` with a smarter batch (≤15 ideas).
   - **If there are none** → run it in **GENERATE** mode: refill `tuner.html` with up to 15 fresh,
     grounded suggestions weighted toward the liked focus areas.

4. **Report:** what was learned (key preference shifts) and/or how many new ideas are now in `tuner.html`,
   plus a reminder that Kevin rates them at
   `https://kevinselhi.github.io/natural-explorers/tuner.html`.

## Notes
- The preview-tuner **never** implements site changes or touches the pages — only `tuner.html` and
  `.claude/evolve-preferences.md`. Real edits still flow through `preview.html` → `/evolve-site`.
- Keep it to **15 suggestions max**.
