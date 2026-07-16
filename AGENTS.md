# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## What this is

A small, self-contained static site for the **Berkeley Natural Explorers Club**, companion to the
club's **Thousand Oaks → John Hinkel Park** hike. There are **five published pages**, designed as a
linked series (a shared series-nav bar at the top of each links to the others; `home.html` is the
landing page and the first item in that nav):

- **`home.html`** — *the landing page / program overview.* "Berkeley Is Your Backyard." A warm,
  parent-facing front door to the club: the three founding goals, how it started (Spring 2023, the
  founding Thousand Oaks → John Hinkel Park hike) and what was learned, plus a **guide directory**
  (a `.guides` card grid) linking the four companion pages and explaining how to navigate the series.
  Deliberately public-facing — omits internal/forward-vision material. Same design system; adds one
  illustration slot (`home-hero.png`) and reuses the existing `explore-next-strip.png`.
- **`index.html`** — *"Your First Nature Drawing."* A parent-facing guide to leading a child's first
  nature drawing at the park waterfall and growing it into a nature journal. Content and visual style
  are adapted from *Keeping a Nature Journal* by Clare Walker Leslie.
- **`hike.html`** — *the hike guide itself:* Thousand Oaks Elementary → John Hinkel Park via the
  Indian Rock Path and San Diego Road, with history, plant ID, bouldering, and the waterfall.
- **`reading-buddy-hike.html`** — *"Take the Trail Together."* A parent-facing **pitch for the
  `hike.html` hike** (not a new trip): an invitation for Thousand Oaks 3rd/4th-grade families to lead
  their child + that child's younger reading buddy on the existing Thousand Oaks → John Hinkel Park
  hike, with the older child in the guide/mentor role. No reading activity — the buddy pairing is just
  the premise; the on-trail "extra" is an optional nature drawing at the waterfall. Same design system
  and image contract; cross-links to both other pages (hard CTA to `hike.html`). Adds one illustration
  slot (`reading-buddies-trail.png`) and reuses the existing `hero-waterfall.png`.
- **`bridge.html`** — *"Bridge to Middle School."* Another parent-facing **pitch for the `hike.html`
  hike** (not a new trip): an invitation to ease a child's 5th→6th grade transition by bringing an
  older kid — a current middle schooler / former Thousand Oaks student the child looks up to — along
  on the existing hike as a low-key trail mentor for the younger ones. The buddy/mentorship premise
  is the frame; the on-trail "extra" is again an optional nature drawing at the waterfall. Same design
  system and image contract; hard CTA to `hike.html`, cross-links `reading-buddy-hike.html` and
  `index.html`. Adds one illustration slot (`mentor-bridge-trail.png`) and reuses the existing
  `hero-waterfall.png` and `reading-buddies-trail.png`.

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

## You are reading the generated mirror (Claude sources are authoritative)

This file and the Codex agent tooling are a mirror generated from the Claude Code sources:

| Claude source (authoritative) | Codex mirror (this side) |
|-------------------------------|--------------------------|
| `CLAUDE.md` | `AGENTS.md` |
| `.claude/agents/*.md` | `.codex/agents/*.toml` |
| `.claude/commands/*.md` | `.agents/skills/source-command-*/SKILL.md` |
| `.claude/evolve-preferences.md` | *(no mirror — shared file, stays in `.claude/`)* |

**The `.claude/` files are the source of truth; edits land there first and the mirror is updated to
match** (adapting paths/formats deliberately — a blind `Claude`→`Codex` text replace corrupts real
paths, which is how this mirror was originally broken). Two rules keep it sane:
`.claude/evolve-preferences.md` is **shared** — both assistants read and write the same file, there
is no Codex copy; and mirror files reference the Codex-side paths (`.codex/agents/*.toml`,
`.agents/skills/…/SKILL.md`), not the Claude ones. None of the mirror is part of the published site.

## The image / photo workflow (no Codex tokens spent on art)

The pages reference images that may not exist yet. **CSS on the image figures renders a missing file
as its `alt`/caption text in a soft framed box, never a broken-image icon** — so the site stays
presentable at every stage and art can be filled in over time. *Do not "fix" missing images by
deleting the tags; the graceful empty state is intentional.*

There are **two parallel tracks**, each with a local studio, a publish script, and a slash command:

| Track | Slots live in | Filetype | Local studio (gitignored) | Publish script | Slash command |
|-------|---------------|----------|---------------------------|----------------|---------------|
| **Illustrations** | `home.html`, `index.html`, `reading-buddy-hike.html`, `bridge.html`, `hike.html` (one nature-drawing tie-in plate) | `.png` in `assets/illustrations/` | `studio.html` | `bin/publish-art.sh` | `/publish-art`, `/add-art` |
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

**Keep image files light (mobile-first).** Source art and photos arrive at many MB; compress before
publishing. Photos ship as optimized JPEG (~0.5–0.9 MB). Illustrations stay `.png` (the filename
contract) but should be downscaled to ~1600 px on the long edge and palette-quantized to 256 colors —
e.g. Pillow `Image.quantize(256, …)` with Floyd–Steinberg dither, which holds up for the flat
watercolor style (it took the illustration set from ~27 MB to ~5 MB). System Python is externally
managed (PEP 668), so run Pillow from a throwaway venv
(`python3 -m venv /tmp/v && /tmp/v/bin/pip install pillow`) rather than installing globally; `sips` is
a no-dependency fallback for resizing. This complements the hero-dimension rule below: small files
*and* honest `og:image:width/height`. **`bin/compress-images.sh` (slash command `/compress-images`)
automates exactly this** — it's the canonical way to apply this convention; see "Local dev tools".

## Local dev tools

Beyond the two image studios (above), three general tools support the workflow. They keep Kevin
(non-coding, often reviewing on a phone) in control without hand-editing:

- **`preview.html`** — a reusable **"Preview & Pick"** page (tracked & published, so it can be opened
  on a phone). Successor to the old masthead-only picker; it works for *any* site-wide decision
  (masthead, footer, palette, buttons, layout). Edit the `ROUNDS` config block to define a decision
  and its variants; each variant renders **live in the real design tokens**, and the engine
  auto-builds a "Pick this →" link that opens a pre-filled **GitHub issue** Codex can act on (plus a
  "describe a mix/tweak" link). To preview something new, you only edit `ROUNDS` — never the engine.
  This is the **ship-a-change** interface — it feeds the self-evolution loop below.
- **`tuner.html`** — a reusable **"Tune the Evolver"** page (tracked & published). The **train-taste**
  companion to preview.html: it lists up to 15 improvement *ideas* + focus-area chips; rating them
  (👍/👎 and which areas matter) files one `tuner-feedback` issue that the `preview-tuner` distills into
  `.claude/evolve-preferences.md`. Edit its `SUGGESTIONS`/`AREAS` config to change what's rated (the
  preview-tuner rewrites these each round). **Never edits the site** — see "Taste-training layer" below.
- **`bin/compress-images.sh`** (slash command **`/compress-images`**) — finds images over budget
  (file > 1500 KB or longest edge > 1600 px) across `assets/illustrations/` + `assets/photos/`,
  rewrites them smaller **in place** (preserving filenames), then commits + pushes (like
  `publish-art.sh`). `--dry-run` to preview; pass file paths to target specific images. The Pillow
  worker is `bin/compress_images.py`; the wrapper manages a private venv at `bin/.venv-img/`
  (gitignored). This is the canonical way to apply the image-weight convention above.

## Self-evolution loop (preview.html → GitHub issue → site-evolver)

The site improves itself in a human-gated loop, with `preview.html` as the choosing interface:

1. **Surface** — `preview.html` shows option "rounds"; each variant's "Pick this" opens a pre-filled
   GitHub issue **auto-labeled `evolve`** (that label is the only trigger — unlabeled issues are never
   touched, so anything you're handling yourself is safe).
2. **Pick** — Kevin taps a variant (and/or adds tweaks in the issue). His pick *is* the approval.
3. **Evolve** — `/evolve-site` (run manually, or by a **daily scheduled routine**) takes the **single
   oldest** open `evolve` issue (**one change per evolution** — any others wait for the next run) and
   dispatches the **`site-evolver` subagent** (`.codex/agents/site-evolver.toml`). The subagent
   implements that change across the five pages per these conventions, compresses images if needed,
   verifies, **pushes to live**, then **appends exactly one new round** to `preview.html` (removing the
   resolved one — preview.html holds a single round at a time). The command then comments the summary on
   the issue, relabels it `evolve → site-evolved`, and closes it.
4. **Repeat** — the new rounds wait in `preview.html` for the next pick.

Components: `.agents/skills/source-command-evolve-site/SKILL.md` (orchestrator), `.codex/agents/site-evolver.toml`
(worker), labels `evolve` / `site-evolved`, and the daily routine. Guardrail: if a request is
ambiguous or risky, the subagent leaves a clarifying comment and keeps the issue open instead of
guessing. To drive it by hand: run `/evolve-site` (or say "evolve the site").

### Taste-training layer (tuner.html → preview-tuner → evolve-preferences.md)
A second loop *trains the evolver's judgment* rather than shipping edits. `tuner.html` shows up to **15
improvement ideas** (and focus-area chips); Kevin rates **which areas matter** and **which ideas are good**
(👍/👎) — he never picks edits here. "Submit feedback" files **one `tuner-feedback` issue**. The
**`preview-tuner` subagent** (`.codex/agents/preview-tuner.toml`, command `/tune-preview`) reads that issue
and distills it into **`.claude/evolve-preferences.md`** — the taste profile — then refills `tuner.html`
with a smarter batch. The **`site-evolver` reads `.claude/evolve-preferences.md`** before proposing real
changes, so the `preview.html`/`evolve-site` loop improves over time. The preview-tuner **never edits the
site** — only `tuner.html` + the preferences file. (So: `tuner.html` trains taste; `preview.html` ships
changes.)

## Architecture & conventions (shared across all five pages)

- **Design system is CSS custom properties** in `:root` (top of each `<style>` block), and all five
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
- **Page hero & social share card (required on every page).** *This is a hard rule — every page,
  including every new one, must satisfy it.* Each page has exactly **one distinct hero**: the first
  `figure.plate.plate--wide` in its `<main>`, a **landscape 16:9** image (≥1200×630; the illustrated
  heroes are 1600×900 / 1672×941). That same hero **doubles as the page's social share card** — the
  rich preview shown when the link is pasted into iMessage, Slack, WhatsApp, or social. So each page's
  `<head>` carries an **Open Graph + Twitter Card block** (`og:type/site_name/title/description/url/
  image` + `og:image:width/height/alt`, `twitter:card=summary_large_image` + title/description/image)
  whose `og:image`/`twitter:image` point at that page's hero via the **absolute** Pages URL
  (`https://kevinselhi.github.io/natural-explorers/…` — relative paths don't work for share scrapers),
  with page-specific `og:title`, `og:description`, and `og:url`. Every page also links the shared
  `assets/favicon.svg` (the hills, sun & oak crest emblem, matching the masthead). Rules of thumb:
    - **One hero per page, not shared.** A new page gets its **own new** hero slot — don't reuse
      another page's hero as the card. Add the new hero's filename + prompt to `IMAGE-PROMPTS.md`
      (16:9), matching the existing `*-hero` / `*-trail` naming.
    - **Keep `og:image:width/height` honest** — set them to the real pixel dimensions so previews
      render immediately.
    - The block travels for free when you clone an existing page (below) — just **update every
      per-page value**: title, description, `og:url`, the hero filename in both image tags, and the
      width/height/alt. (Exception: `hike.html` is the photo page; its hero/card is a Kevin Selhi
      photo. Its current hero is portrait — a landscape hike share image is a nice future upgrade.)
- **When adding a new page to the series:** reuse the existing tokens, fonts-with-fallbacks, image
  contract, accessibility/print blocks, and series nav — don't reinvent the styling; add it to the
  series-nav bar on the other pages; **and give it its own distinct 16:9 hero plus the Open Graph /
  Twitter share block and favicon link described above** (new hero slot + prompt in `IMAGE-PROMPTS.md`,
  absolute `og:image`, page-specific `og:title`/`og:description`/`og:url`). Cloning the closest
  existing page carries the share block along — then update its per-page values.
