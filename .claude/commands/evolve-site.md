---
description: Act on preview.html feedback — implement picked changes and surface the next round
---

Drive the site's self-evolution loop. Feedback arrives as GitHub issues filed from `preview.html`,
each carrying the `evolve` label. For each one, ship the chosen change and surface the next round of
options. Decisions are pre-approved by Kevin (he picked them in preview.html).

Run from the **repo root** (`git rev-parse --show-toplevel` — never hardcode a path). The repo is
`kevinselhi/natural-explorers`.

## Mode — local (`gh`) vs cowork (MCP)
Detect the environment with `command -v gh`:
- **`gh` present ⇒ direct mode** (local): GitHub ops via the `gh` CLI; changes **push straight to live
  `main`**; process the **single oldest** issue per run.
- **`gh` absent ⇒ PR mode** (cowork / Claude Code on the web): `gh` does not exist — use the **GitHub
  MCP tools** instead; ship each change as its **own draft PR** (`Closes #N`); **drain all** open
  `evolve` issues in one run. `gh` ⇄ MCP equivalents:

  | gh (direct mode) | MCP tool (PR mode) |
  |---|---|
  | `gh issue list --label evolve --state open` | `mcp__github__list_issues` (owner `kevinselhi`, repo `natural-explorers`, state `open`, labels `["evolve"]`) |
  | `gh issue view <N> --comments` | `mcp__github__issue_read` (`get`, then `get_comments`) |
  | `gh issue comment <N>` | `mcp__github__add_issue_comment` |
  | `gh issue edit --remove-label evolve` | `mcp__github__issue_write` (method `update`, labels list without `evolve`) |
  | open a PR | `mcp__github__create_pull_request` (`draft: true`, `base: main`, `head: evolve/issue-<N>`) |

## Steps

1. **Sync:** direct mode → `git pull --ff-only`. PR mode → `git fetch origin main` (the site-evolver
   cuts each PR branch from the latest `origin/main`).

2. **Find work:** list open issues carrying the `evolve` label (gh or `mcp__github__list_issues`),
   **oldest → newest**. Skip any already carrying `site-evolved`. If none remain, report "Nothing to
   evolve — no open `evolve` issues" and stop. (Only the `evolve` label opts an issue in — unlabeled
   issues are never touched.)

3. **Process the issues:** direct mode handles **only the oldest** (one change per evolution; others
   wait). PR mode **iterates all** of them, oldest first. For each issue N:
   a. Read it fully, including comments (`gh issue view <N> --comments` or `mcp__github__issue_read`).
   b. **Dispatch the `site-evolver` subagent** (via the Agent tool) with the issue number, title, body,
      comments, and the **mode**. It implements the one change and verifies. In direct mode it pushes to
      `main` and appends the next `preview.html` round; in PR mode it ships on branch `evolve/issue-<N>`
      and returns that branch name. It returns a summary.
   c. **If the subagent implemented the change:**
      - *Direct mode:* post the summary (`gh issue comment <N> …`); relabel and close
        (`gh issue edit <N> --remove-label evolve --add-label site-evolved`; `gh issue close <N> --reason completed`).
      - *PR mode:* open the draft PR for its branch — `mcp__github__create_pull_request`
        (`draft: true`, `base: main`, `head: evolve/issue-<N>`, body = the subagent summary + `Closes #N`).
        Comment the PR URL on the issue (`mcp__github__add_issue_comment`), then **remove the `evolve`
        label** (`mcp__github__issue_write`, method `update`) so re-runs skip it. **Do not close the
        issue** — merging the PR closes it via `Closes #N`.
   d. **If the subagent asked for clarification** (did not implement): post its question as a comment,
      **leave the issue open with its `evolve` label intact**, and move on.

4. **Surface the next round** (one consolidated edit, so parallel PRs never collide on `ROUNDS`):
   - *Direct mode:* the site-evolver already appended one new `preview.html` round in its run — nothing
     to do here.
   - *PR mode:* after all issues are turned into PRs, dispatch the `site-evolver` once more (or edit
     directly) on a branch `evolve/preview-refresh` cut from `origin/main`: in `preview.html`, remove any
     now-settled round and **append exactly ONE** fresh next-decision round (existing `ROUNDS` schema,
     guided by `.claude/evolve-preferences.md`). Push the branch and open one draft PR for it. Skip if
     there's no worthwhile next decision.

5. **Report** back: the issue(s) shipped and the live URL `https://kevinselhi.github.io/natural-explorers/`;
   in PR mode, the list of draft PRs (issue number + branch) plus the preview-refresh PR; the single new
   option round now waiting in `preview.html`.

## Notes
- Only issues labeled `evolve` are ever acted on — this is the explicit opt-in (preview.html picks add it
  automatically). Never act on unlabeled issues.
- If anything is ambiguous or risky, prefer leaving a clarifying comment over guessing.
- PR mode never touches live `main` directly — merging each draft PR is what ships the change.
