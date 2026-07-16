# Reading-Buddy Hike Page — Status & Build Brief

*Prepared for Kevin Selhi · Berkeley Natural Explorers Club · drop this in the repo folder and point Claude Code at it.*

---

## 0. How to use this file (the 3-minute version)

```bash
git clone https://github.com/kevinselhi/natural-explorers.git
cd natural-explorers
# save this file in the repo root as reading-buddy-hike-brief.md
claude
```

Then give Claude Code this opening prompt:

> Read `reading-buddy-hike-brief.md`, then read `CLAUDE.md`, `index.html`, `hike.html`, `IMAGE-PROMPTS.md`, and `README.md` to learn the existing conventions.
>
> **First task — before building anything: update `CLAUDE.md`** (see "CLAUDE.md update" in the brief). The current `CLAUDE.md` is stale and will mislead you and every future session. Fix it on launch.
>
> **Then** build the new reading-buddy hike page (`reading-buddy-hike.html`) described in the brief as a standalone page that matches the existing design system, journal motifs, image contract, and accessibility patterns. Don't reinvent the styling — reuse it. Show me the plan before writing the page.
>
> **Last:** add the finished page to `CLAUDE.md`'s architecture section so the docs reflect reality.

That's it. The rest of this document is the substance Claude Code (and you) need.

### CLAUDE.md update (do this on launch, then again after the build)

**On launch — reconcile the stale parts** so the working context is accurate before any code is written:
- The current `CLAUDE.md` says "the working directory is **not** a git repo" and tells you to consult `naturejournal.bundle`. **That's wrong now.** The cloned repo *is* a real git repo with `index.html`, `hike.html`, `IMAGE-PROMPTS.md`, `assets/`, and `bin/` all present (README confirms). Replace that section with: this is a live git repo served via GitHub Pages from root; treat the working tree + `README.md` as the source of truth.
- The "What this is" line describes the site as "a single, self-contained static webpage." It's now a **multi-page site**. Update it to reflect that there are several parent-facing pages (see next bullet).

**After the build — document the new page** so the next session is oriented:
- Add `reading-buddy-hike.html` to the architecture/what-this-is section: a parent-facing invitation for Thousand Oaks 3rd/4th-grade families to take their child + that child's younger reading buddy on the John Hinkel Park hike; same design system and image contract as `index.html`; cross-linked to "Your First Nature Drawing."
- Note any new illustration slots added to `IMAGE-PROMPTS.md`.

Keep the existing conventions documentation (design tokens, fonts, image contract, accessibility/print, journal motifs) intact — only correct what's inaccurate and append the new page. Commit the `CLAUDE.md` fix as its own commit before the page work, so the history is clean.

---

## 1. Where things stand (current status)

**The project.** The Berkeley Natural Explorers Club is a BUSD-focused effort to get a diverse group of 3rd–5th graders out into Berkeley's parks and trails — building belonging, social-emotional well-being, and leadership, and softening the hills/flats cultural divide. (Full mission in §6.)

**The repo.** `github.com/kevinselhi/natural-explorers` — public, 8 commits, ~90% HTML / 10% shell. It is a **single-page-per-topic static site**: no build step, no JS, no dependencies. Served straight from root via **GitHub Pages** (`.nojekyll` present), so every push to `main` republishes in ~1 minute at `https://kevinselhi.github.io/natural-explorers/`.

**What already exists in it:**

| File | What it is |
|---|---|
| `index.html` | The flagship page — **"Your First Nature Drawing,"** a parent-facing companion to the **Thousand Oaks → John Hinkel Park** hike. Walks a parent through guiding a child's first nature drawing at the park waterfall, in the visual style of *Keeping a Nature Journal* by Clare Walker Leslie. |
| `hike.html` | A second page (the hike itself). Read it for the established logistics/voice. |
| `IMAGE-PROMPTS.md` | Ready-to-paste image prompts + a Global Style Preamble; the manifest of illustration filenames. |
| `assets/illustrations/` | Where generated PNGs go. Filenames must match the manifest. |
| `bin/` + `.claude/commands/` | The art workflow: `art-status.sh`, `add-art.sh`, `publish-art.sh`, and slash commands `/add-art`, `/publish-art`. |

**The established design system (do not reinvent — reuse):**

- **Color = CSS custom properties** in `:root` at the top of the `<style>` block. Two groups: paper/ink neutrals, and an "East Bay oak-woodland" accent palette — `--sage`, `--forest`, `--ochre`, `--clay`, `--creek`. Use the variables; never hardcode hex.
- **Fonts** via Google Fonts with full system fallback stacks baked into `--display` (Caveat, handwritten) and `--serif` (Lora, body). Preserve the fallbacks.
- **Image contract (important).** Pages reference `assets/illustrations/*.png` that mostly don't exist yet. CSS on `figure.plate img` renders a *missing* image as its **alt text in a soft framed box** — never a broken-image icon. So the page looks finished at every stage and art gets filled in later. Every `<img>` must have meaningful `alt`, and filenames must match the manifest. **Do not "fix" missing images by deleting the tags** — the empty state is intentional.
- **Journal motifs are the brand:** a dated entry header, "plate" figures taped in and rotated a fraction of a degree, hand-drawn SVG dividers/emblem. Match these instead of introducing generic web-UI patterns.
- **Accessibility & print are first-class:** `aria-labelledby` on sections, `aria-hidden` on decorative elements, plus `@media print` and `prefers-reduced-motion` blocks. Keep these patterns.
- **Image generation is deliberately delegated** to Gemini/ChatGPT (via `studio.html` and the `bin/` scripts) so no Claude tokens are spent making pictures. New image slots get a prompt added to `IMAGE-PROMPTS.md`; the page ships with graceful empty states until art is dropped in.

**What's new (this brief).** A *third* page: a **reading-buddy hike** invitation aimed at parents of 3rd & 4th graders at Thousand Oaks Elementary, designed to be forwarded by teachers to every parent. Suggested filename: **`reading-buddy-hike.html`**.

---

## 2. The job to be done

Make a busy Thousand Oaks parent read this page and think: *"Oh — we could actually do that this Saturday."*

The page has to do **two jobs at once**:
1. **Inspire** — make a reading-buddy hike feel meaningful and special, not like one more obligation.
2. **De-friction** — remove every practical reason it wouldn't happen (where, how long, how hard, what to bring, how to pair up, what to actually do there).

**Audience:** parents of 3rd & 4th graders at Thousand Oaks Elementary (and, by extension, the families of those kids' younger reading buddies).
**Distribution path:** Kevin → 3rd/4th-grade teachers → forwarded to all parents. The page itself is **parent-facing**; the teacher ask is handled separately (a ready-to-send note to teachers is in Appendix A).
**Primary CTA:** *This week, text your buddy's parent and pick a Saturday morning at John Hinkel Park.*

---

## 3. Confirmed decisions (locked — build to these)

1. **Reading-buddy structure — CONFIRMED.** Thousand Oaks runs the classic "big buddy / little buddy" model: the 3rd/4th grader is paired with a *younger* student. The hike brings **both kids + both families** together, with the **older child in the guide/mentor role**. Write the page around the older child leading — it's the heart of the pitch and maps to the club's leadership mission.
2. **Destination — CONFIRMED: John Hinkel Park.** Same destination as the existing pages. Reuse the waterfall imagery, share the logistics, and cross-link to "Your First Nature Drawing." You may mention Indian Rock / Great Stoneface in one sentence as an even-closer alternative, but John Hinkel is the page's hike.
3. **Timing — CONFIRMED: evergreen.** "Pick a weekend this spring/early summer" — no fixed date, so teachers can resend the page anytime. (If an organized group hike gets scheduled later, the headline can be swapped then.)
4. **Logistics come from the repo, not invention.** John Hinkel Park specifics (directions, parking, trail length, waterfall/amphitheater) must be lifted from the existing `index.html` / `hike.html` so the pages don't contradict each other. Read those first; flag gaps for Kevin rather than guessing distances or times.

---

## 4. Page content spec

Working titles (pick one, journal-handwritten in `--display`):
- **"Take the Trail Together"** *(subtitle: A reading-buddy hike for Thousand Oaks families)*
- "Big Buddies on the Trail"
- "Read Buddies, Trail Buddies"

Sections, in order. Keep each tight; warmth over word count.

1. **Dated entry header + hero.** Match the journal entry-header motif. Hero plate = the existing waterfall illustration *or* a new "two kids on a trail, big one pointing the way" plate (see §5). One-line promise underneath: your child already has a reading buddy — picture that friendship out on a trail.

2. **The invitation.** Short and evocative. The reading-buddy bond is one of the sweetest things at Thousand Oaks; this takes it out of the classroom and into the hills. The older child gets to *lead* — find the trail, watch out for the little one, point things out. The younger child gets a real adventure with their big buddy.

3. **Why it's worth a Saturday** (the case to parents — concrete, not preachy; 3–4 beats that map to the club's mission):
   - Time in nature → calmer, happier, more regulated kids.
   - **Leadership for the older child** — they're the guide, not the follower.
   - Connection across two families; a low-stakes way for parents to meet.
   - Belonging — kids start to feel the parks and hills are *theirs*.

4. **The hike: John Hinkel Park.** Framed as easy and doable. Where it is / how to get there / roughly how long & how gentle (pull from existing pages — §3.4), and the payoff: the creek, the little waterfall, the historic stone amphitheater, the redwoods. Explicit "perfect for little legs" reassurance.

5. **A reading-buddy twist: read on the trail.** Bring one picture book or a couple of chapters. Find a flat rock or the amphitheater steps. The big buddy reads to the little buddy, or they trade pages, with the creek as the soundtrack. Optional bridge to the nature-journal page: draw what you saw afterward — **cross-link to "Your First Nature Drawing" (`index.html`).**

6. **Make it easy** (a real checklist, journal-styled): water, a snack, a layer (the hills run cool), sturdy shoes, one book, optionally a small notebook + pencil. Two lines of plain safety basics. Suggested window: a weekend morning.

7. **How to set it up** (the friction-killer — give them the literal next action): text your buddy's parent, pick a Saturday, meet at the park entrance. Include a **copy-ready one-liner** a parent can paste into a text, e.g. *"Hi! [Kid] and [buddy] are reading buddies — want to bring them on a short, easy hike at John Hinkel Park some Saturday morning? The kids would love it and it's gorgeous."*

8. **About the club + close.** One or two lines on the Berkeley Natural Explorers Club and its mission, an invitation to make it the first of many, and a warm hand-drawn-divider sign-off in the established voice.

**Tone:** warm, specific, parent-to-parent. Not salesy, not earnest-to-the-point-of-eye-roll. The journal voice already in `index.html` is the target — match it.

---

## 5. Build conventions for Claude Code (checklist)

- [ ] New standalone file at repo root: **`reading-buddy-hike.html`**. Self-contained HTML + embedded `<style>`. **No JS, no build, no dependencies.**
- [ ] Reuse the `:root` design tokens (paper/ink neutrals + `--sage` `--forest` `--ochre` `--clay` `--creek`). No hardcoded colors.
- [ ] Reuse `--display` (Caveat) and `--serif` (Lora) **with their existing fallback stacks**.
- [ ] Reuse the journal motifs: dated entry header, taped/rotated `figure.plate` images, hand-drawn SVG dividers/emblem.
- [ ] **Honor the image contract:** every `<img>` references `assets/illustrations/*.png`, carries meaningful `alt`, and degrades to the soft framed alt-text box. Don't remove tags for missing art.
- [ ] For any **new** illustration the page needs, add a slot + prompt to `IMAGE-PROMPTS.md` following the existing pattern (prepend the Global Style Preamble; keep the palette consistent with existing plates) so the Gemini/ChatGPT → `studio.html` → `/add-art` workflow still works. **Do not generate images in Claude Code.** Likely new slots: `reading-buddies-trail.png`, maybe `read-on-a-rock.png`. Reuse `hero-waterfall.png` where possible.
- [ ] Keep accessibility/print first-class: `aria-labelledby` per `<section>`, `aria-hidden` on decorative SVG, `@media print` + `prefers-reduced-motion` blocks.
- [ ] Cross-link the pages: add a link from this page to `index.html` ("Your First Nature Drawing") and, if `index.html`/`hike.html` have a nav, add this page to it so the site reads as one set.
- [ ] Pull John Hinkel Park logistics from `index.html`/`hike.html` rather than inventing; flag any gaps for Kevin instead of guessing distances/times.
- [ ] **`CLAUDE.md`:** on launch, fix the stale "not a git repo / use the bundle" + "single webpage" lines (its own commit, before the page work); after the build, append the new page to the architecture section. Full instructions in §0 → "CLAUDE.md update."
- [ ] Verify locally before pushing: `python3 -m http.server` → open `http://localhost:8000/reading-buddy-hike.html`.
- [ ] Confirm GitHub Pages is enabled; the page will live at `https://kevinselhi.github.io/natural-explorers/reading-buddy-hike.html`.

---

## 6. Reference: the club's mission (for voice/substance, not for pasting verbatim)

- **Belonging & a better city:** help BUSD kids feel at home in every part of Berkeley and invested in it.
- **Skills to explore safely:** give families the confidence to get out and enjoy the city's natural beauty.
- **Leadership + equity:** develop leadership across a diverse group of kids — and the reading-buddy hike is a near-perfect vehicle, since the older child *leads* the younger one.
- Open questions the club is exploring that this page quietly advances: does nature time boost social-emotional well-being; can shared hikes erode the hills/flats divide; can outdoor exploration grow leadership and pull whole families in.

Local anchors the club already uses: Indian Rock Park, John Hinkel Park, Great Stoneface Park, Shorebird Park, Adventure Playground; wider East Bay: Tilden, Lake Anza, Roberts Park, Albany Bulb; UC-Berkeley's Blake Garden, Botanical Garden, Lawrence Hall of Science.

---

## Appendix A — Ready-to-send note to the 3rd/4th-grade teachers

*(This is the distribution step — your message to teachers, not part of the page. Edit the bracketed bits and the link once Pages is live. I can turn this into a polished email on request.)*

> **Subject: A reading-buddy hike families can do this spring**
>
> Hi [teacher names],
>
> I put together a short page for the Berkeley Natural Explorers Club inviting families to take their child and their reading buddy on an easy hike at John Hinkel Park — the kids read together on a rock by the creek, and the older buddy gets to be the guide. It's built to be low-effort for parents: where to go, what to bring, and a one-line text they can send their buddy's family.
>
> Would you be willing to forward it to your 3rd/4th-grade parents? Here it is: [https://kevinselhi.github.io/natural-explorers/reading-buddy-hike.html]
>
> Thank you — happy to tweak anything that would make it easier to share.
>
> Kevin

---

## Appendix B — If you'd rather not clone (alternative)

If you don't want to manage a local clone, you can do the whole thing through Claude Code's GitHub integration or by editing in the GitHub web UI, but the clone-and-`claude` path above is the cleanest and lets you preview locally with `python3 -m http.server` before anything goes live.
