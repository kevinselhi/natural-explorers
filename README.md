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

## The image workflow (delegated to Gemini / ChatGPT)

The page references illustrations in `assets/illustrations/` that don't exist yet. **Until an
image is added, the page gracefully shows its alt text in a soft framed box** — never a broken
image. So the site stays presentable at every stage, and you can fill art in over time.

Image *generation* is delegated to image-capable models so **no Claude tokens are spent making
pictures**. The loop:

1. **See what's needed** — `bin/art-status.sh` lists the slots still missing art.
2. **Generate** — open `IMAGE-PROMPTS.md`, prepend the **Global Style Preamble** to a slot's
   prompt, and paste it into **Gemini** and **ChatGPT** at the listed aspect ratio. Generate
   a few candidates in each.
3. **Pick** — eyeball the candidates and choose your favorite (keep it anywhere, e.g.
   `~/Downloads/`).
4. **Publish** — promote your pick in one command:
   ```bash
   bin/add-art.sh hero-waterfall.png ~/Downloads/my-favorite.png
   ```
   It copies the file in with the correct name, commits, and pushes. GitHub Pages republishes
   automatically (~1 min). Inside Claude Code you can instead run
   `/add-art hero-waterfall.png ~/Downloads/my-favorite.png`.

Keep the palette consistent across images so the page reads as one set. The four slots the page
uses today: `hero-waterfall.png`, `first-drawing.png`, `supplies.png`, `explore-next-strip.png`.
`logo.png` and the eight `principle-*.png` vignettes have prompts ready in `IMAGE-PROMPTS.md`
and can be wired in if you want more art.

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
