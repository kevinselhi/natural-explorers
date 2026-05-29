---
description: Act on preview.html feedback — implement picked changes and surface the next round
---

Drive the site's self-evolution loop. Feedback arrives as GitHub issues filed from `preview.html`,
each carrying the `evolve` label. For each one, ship the chosen change and surface the next round of
options. Decisions are pre-approved by Kevin (he picked them in preview.html), so changes **push
straight to the live site**.

Run from the repo root (`/Users/kevinselhi/natural-explorers`). The repo is `kevinselhi/natural-explorers`.

## Steps

1. **Sync:** `git pull --ff-only` (another session may have pushed).

2. **Find work:** list open issues that opted into the loop and aren't done yet:
   ```
   gh issue list --repo kevinselhi/natural-explorers --state open --label evolve --json number,title,labels
   ```
   Skip any that already carry the `site-evolved` label. If none remain, report "Nothing to evolve —
   no open `evolve` issues" and stop.

3. **Process exactly ONE issue per run** — the **oldest** open `evolve` issue (one change per evolution;
   any others wait for the next run). For that single issue:
   a. Read it fully, including comments: `gh issue view <N> --repo kevinselhi/natural-explorers --comments`.
   b. **Dispatch the `site-evolver` subagent** (via the Agent tool) with the issue number, title, body,
      and comments as context. It implements the change across the pages, verifies, pushes, and appends
      the next round of options to `preview.html`. It returns a summary.
   c. **If the subagent implemented the change:**
      - Post its summary as a comment:
        `gh issue comment <N> --repo kevinselhi/natural-explorers --body "<summary>"`
      - Mark done and close:
        `gh issue edit <N> --repo kevinselhi/natural-explorers --remove-label evolve --add-label site-evolved`
        `gh issue close <N> --repo kevinselhi/natural-explorers --reason completed`
   d. **If the subagent asked for clarification** (did not implement): post its question as a comment and
      **leave the issue open** (do not relabel/close), so Kevin can respond. Move on.

4. **Report** back: the one issue shipped (with the live URL
   `https://kevinselhi.github.io/natural-explorers/`), the single new option round now waiting in
   `preview.html`, and how many `evolve` issues remain for future runs.

## Notes
- Only issues labeled `evolve` are ever acted on — this is the explicit opt-in (preview.html picks add it
  automatically). Never act on unlabeled issues.
- If anything is ambiguous or risky, prefer leaving a clarifying comment over guessing.
