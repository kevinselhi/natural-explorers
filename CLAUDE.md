# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A small, self-contained static site for the **Berkeley Natural Explorers Club**, companion to the
club's **Thousand Oaks → John Hinkel Park** hike. There are **two published pages**, designed as a
linked series (a shared series-nav bar at the top of each links to the other):

- **`index.html`** — *"Your First Nature Drawing."* A parent-facing guide to leading a child's first
  nature drawing at the park waterfall and growing it into a nature journal. Content and visual style
  are adapted from *Keeping a Nature Journal* by Clare Walker Leslie.
- **`hike.html`** — *the hike guide itself:* Thousand Oaks Elementary → John Hinkel Park via the
  Indian Rock Path and San Diego Road, with history, plant ID, bouldering, and the waterfall.

There is **no build step, no JS framework, and no dependencies.** Each page is one HTML file with an
embedded `<style>` block. The site is deployed via **GitHub Pages** from the repo root on every push
to `main`: <https://kevinselhi.github.io/natural-explorers/>.

## Working with it

```bash
python3 -m http.server       # recommended — serves so relative asset paths (and the studios) resolve; visit :8000
open index.html              # quick look at a single page; relative assets work here too for simple cases
```

`.nojekyll` tells Pages to serve files verbatim (no Jekyll processing) — keep it.

This **is** a git repo with an `origin` remote; pushing to `main` republishes the live site.
`naturejournal.bundle` is a **gitignored local archive** (a snapshot of the page's earlier history
from the larger `treehousedads/kevin` repo) — it's no longer the source of truth and is not published.

## The image / photo workflow (no Claude tokens spent on art)

Both pages reference images that may not exist yet. **CSS on the image figures renders a missing file
as its `alt`/caption text in a soft framed box, never a broken-image icon** — so the site stays
presentable at every stage and art can be filled in over time. *Do not "fix" missing images by
deleting the tags; the graceful empty state is intentional.*

There are **two parallel tracks**, each with a local studio, a publish script, and a slash command:

| Track | Slots live in | Filetype | Local studio (gitignored) | Publish script | Slash command |
|-------|---------------|----------|---------------------------|----------------|---------------|
| **Illustrations** | `index.html` | `.png` in `assets/illustrations/` | `studio.html` | `bin/publish-art.sh` | `/publish-art`, `/add-art` |
| **Photos** (© Kevin Selhi) | `hike.html` | `.jpg` in `assets/photos/` | `photo-studio.html` | `bin/publish-photos.sh` | `/publish-photos` |

- **Studios** (`studio.html`, `photo-studio.html`) are **local workflow tools, gitignored, not part of
  the published site.** They must be opened over a local server (File System Access API). In Chrome/Edge
  they write the chosen image straight into the assets folder with the correct filename; Safari/Firefox
  fall back to a download you move in yourself. Illustration generation is delegated to image-capable
  models (Gemini/ChatGPT) using the prompts in `IMAGE-PROMPTS.md`.
- **Publish scripts** stage new/changed assets of their type, commit with a standard message, and push.
  After saving art/photos in a studio, the user typically just says *"publish art"* / *"publish photos"*.
- **`bin/art-status.sh`** lists which `index.html` illustration slots are present vs. still missing.
- **`bin/add-art.sh <target.png> <source>`** promotes one chosen illustration to a known slot, then
  commits and pushes. It validates the target name against slots wired into `index.html` and the
  `IMAGE-PROMPTS.md` manifest, so filenames stay in sync with the page.

**Filenames are a contract.** The expected names are listed in `IMAGE-PROMPTS.md` /
`assets/illustrations/README.md` (illustrations) and `assets/photos/README.md` (photos). The page
references exact filenames — match them precisely, and give every `<img>` meaningful `alt` text.

## Architecture & conventions (shared by both pages)

- **Design system is CSS custom properties** in `:root` (top of each `<style>` block), and the two
  pages **share the same token set** — keep them identical so the series reads as one. Two groups:
  paper/ink neutrals and an "East Bay oak-woodland" accent palette (`--sage`, `--forest`, `--ochre`,
  `--clay`, `--creek`). Use these variables rather than hardcoding colors. (The studios deliberately
  reuse the same tokens so the tools feel on-brand.)
- **Fonts** are Google Fonts (Caveat for display/handwritten, Lora for serif body) loaded via `<link>`,
  each with a full system-font fallback stack in `--display` / `--serif` so the page degrades if the
  network blocks Google Fonts. Preserve the fallbacks when touching fonts.
- **Accessibility & print are first-class:** sections use `aria-labelledby`, decorative dividers are
  `aria-hidden`, and there are `@media print` and `prefers-reduced-motion` blocks. Keep these patterns
  when adding sections.
- **Brand motifs are the design language:** dated journal-entry headers, taped-in "plate" figures
  rotated a fraction of a degree, hand-drawn SVG dividers/emblems, the shared series-nav bar. Match
  these rather than introducing generic web-UI patterns. Content tone is warm and parent-facing.
- **When adding a new page to the series:** reuse the existing tokens, fonts-with-fallbacks, image
  contract, accessibility/print blocks, and series nav — don't reinvent the styling — and add it to
  the series-nav bar on the other pages.
