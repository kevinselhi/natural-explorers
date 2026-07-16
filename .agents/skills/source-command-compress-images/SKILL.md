---
name: "source-command-compress-images"
description: "Compress oversized site images for fast mobile load, then publish"
---

# source-command-compress-images

Use this skill when the user asks to run the migrated source command `compress-images`.

## Command Template

The user wants to shrink images that are too heavy for mobile (e.g. after dropping in new
illustrations or photos).

Run the compression tool:

```
bin/compress-images.sh
```

It scans `assets/illustrations/` and `assets/photos/`, rewrites any image over budget
(file > 1500KB or longest edge > 1600px) in place — keeping the same filenames so the page
`<img>` references still resolve — then commits and pushes so GitHub Pages republishes.

- To preview without changing anything: `bin/compress-images.sh --dry-run`
- To target specific files: `bin/compress-images.sh assets/illustrations/home-hero.png`

After it succeeds, report the live URL: https://kevinselhi.github.io/natural-explorers/
