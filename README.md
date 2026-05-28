# Berkeley Natural Explorers Club — "Your First Nature Drawing"

A single-page, mobile-friendly web companion to the Club's **Thousand Oaks → John Hinkel Park**
hike. It guides a child's first nature drawing at the park's waterfall and shows parents how to
grow it into a nature journal, in the visual style of *Keeping a Nature Journal* by Clare Walker
Leslie.

🌿 **Live page:** _enabled via GitHub Pages — see below._

## What's here

| File | Purpose |
|------|---------|
| `index.html` | The entire site — self-contained HTML + embedded CSS. No build step, no JS, no dependencies. |
| `IMAGE-PROMPTS.md` | Ready-to-paste prompts for generating each illustration. |
| `assets/illustrations/` | Drop generated PNGs here. Filenames must match the manifest. |
| `.nojekyll` | Tells GitHub Pages to serve files verbatim (no Jekyll processing). |

## View locally

```bash
python3 -m http.server   # then visit http://localhost:8000  (recommended — resolves asset paths)
# or just:
open index.html
```

## Adding the artwork (delegated to image models)

The page references illustrations in `assets/illustrations/` that don't exist yet. **Until an
image is added, the page gracefully shows its alt text in a soft framed box** — never a broken
image. So the site stays presentable at every stage.

To add art **without spending Claude tokens on image generation**, hand the prompts to an
image-capable model (Gemini, ChatGPT/DALL·E, etc.):

1. Open `IMAGE-PROMPTS.md`.
2. For each slot, prepend the **Global Style Preamble**, paste the slot's prompt into your
   image model, and generate at the listed aspect ratio.
3. Export as **PNG** and save into `assets/illustrations/` using the **exact filename** listed.
   The page picks it up automatically — no code change needed.

Keep the palette consistent across images so the page reads as one set.

## Hosting (GitHub Pages)

This repo is structured to serve directly from its root:

```bash
# one-time, from the repo root:
gh repo create natural-explorers --public --source=. --remote=origin --push
gh api -X POST repos/:owner/natural-explorers/pages -f source[branch]=main -f source[path]=/
```

The page is then served at `https://<user>.github.io/natural-explorers/`. Every push to `main`
republishes automatically.

---

*Journaling principles adapted from* Keeping a Nature Journal *by Clare Walker Leslie.*
