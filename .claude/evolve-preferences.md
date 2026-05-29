# Evolve preferences — the learned taste profile

This file is the **taste profile** that steers the site's autonomous evolution. Two agents use it:

- **`preview-tuner`** *writes* it — distilling Kevin's feedback (submitted via `tuner.html` as
  `tuner-feedback` issues) into the sections below, and biasing its next batch of suggestions toward
  what's liked.
- **`site-evolver`** *reads* it — before implementing a pick and (especially) before surfacing the next
  preview.html round, so its evolutions match Kevin's taste.

Keep it **concise and current** — a working profile, not a log. Prune stale notes. When updating from new
feedback, merge into the existing points rather than appending duplicates. Date material changes.

---

## Focus areas Kevin wants prioritized
_(ranked-ish; highest interest first)_

- _none captured yet — seeded 2026-05-29; will fill in from the first `tuner-feedback`._

## Kinds of suggestions Kevin likes
_(patterns that earned 👍 — e.g. "tightening copy", "warmer CTAs", "more whitespace")_

- _none yet._

## Kinds of suggestions to avoid
_(patterns that earned 👎 — don't propose these again)_

- _none yet._

## Open notes
- This profile is empty until the first round of tuner feedback. Until then, the `site-evolver`
  should use balanced judgment across all areas.
