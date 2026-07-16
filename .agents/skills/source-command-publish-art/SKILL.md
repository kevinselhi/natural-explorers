---
name: "source-command-publish-art"
description: "Publish illustrations saved via the studio to the live page"
---

# source-command-publish-art

Use this skill when the user asks to run the migrated source command `publish-art`.

## Command Template

The user saved one or more illustrations (via `studio.html`) into `assets/illustrations/`.

Run the publish script:

```
bin/publish-art.sh
```

It stages any new/changed illustration PNGs, commits, and pushes so GitHub Pages republishes.
After it succeeds:

1. Report the live URL: https://kevinselhi.github.io/natural-explorers/
2. Run `bin/art-status.sh` and tell the user which on-page slots (if any) are still missing.

Do not generate or edit images yourself — image creation is delegated to Gemini/ChatGPT.
