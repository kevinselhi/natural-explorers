# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single, self-contained static webpage: **"Your First Nature Drawing"**, a parent-facing
companion to the Berkeley Natural Explorers Club's Thousand Oaks → John Hinkel Park hike. It
walks a parent through guiding a child's first nature drawing at the park waterfall and growing
it into a nature journal. Content and visual style are adapted from *Keeping a Nature Journal*
by Clare Walker Leslie.

## Working with it

There is **no build step, no JS, and no dependencies**. `index.html` is the entire site —
HTML plus embedded `<style>`.

```bash
open index.html              # quick look
python3 -m http.server       # recommended — serves so relative asset paths resolve; visit :8000
```

The working directory is **not a git repo**. The full project history (this page plus its
companion docs) is preserved in `naturejournal.bundle`, a git bundle snapshot of branch
`claude/nature-journal-webpage-plan-*` from the larger `treehousedads/kevin` collaborative repo.
Inspect it with:

```bash
git clone naturejournal.bundle /tmp/nj && (cd /tmp/nj && git checkout <branch-from-bundle>)
```

The bundle additionally contains `IMAGE-PROMPTS.md`, `README.md`, and `assets/illustrations/`
that are **not present in this working tree** — consult it before recreating any of those.

## Architecture & conventions

- **Design system is CSS custom properties** in `:root` (top of the `<style>` block). Two
  groups: paper/ink neutrals and an "East Bay oak-woodland" accent palette (`--sage`,
  `--forest`, `--ochre`, `--clay`, `--creek`). Use these variables rather than hardcoding
  colors so the journal aesthetic stays consistent.
- **Fonts** are Google Fonts (Caveat for display/handwritten, Lora for serif body) loaded via
  `<link>`, each with a full system-font fallback stack in `--display` / `--serif` so the page
  degrades if the network blocks Google Fonts. Preserve the fallbacks when touching fonts.
- **Image contract (important):** the page references `assets/illustrations/*.png` that do not
  exist yet. CSS on `figure.plate img` (a striped background + `min-height`) makes a missing
  image render as its **alt text in a soft framed box**, never a broken-image icon. So: every
  `<img>` must carry meaningful `alt` text, and filenames must exactly match the manifest in the
  bundle's `IMAGE-PROMPTS.md` / `assets/illustrations/README.md`. Don't "fix" the missing images
  by removing the tags — the graceful empty state is intentional.
- **Accessibility & print are first-class:** sections use `aria-labelledby`, decorative
  dividers are `aria-hidden`, and there are `@media print` and `prefers-reduced-motion` blocks.
  Keep these patterns when adding sections.
- Content tone is warm and parent-facing; the recurring journal motifs (dated entry header,
  taped-in "plate" figures rotated a fraction of a degree, hand-drawn SVG divider/emblem) are
  the brand — match them rather than introducing generic web-UI patterns.
