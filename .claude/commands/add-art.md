---
description: Promote a chosen illustration onto the live page and publish it
argument-hint: <target-filename.png> <path-to-chosen-image>
---

The user picked an illustration to add to the Berkeley Natural Explorers Club page.

Run the project's promotion script with their arguments:

```
bin/add-art.sh $ARGUMENTS
```

That script copies the chosen image into `assets/illustrations/`, commits, and pushes so
GitHub Pages republishes automatically. After it succeeds:

1. Report the live URL: https://kevinselhi.github.io/natural-explorers/
2. Run `bin/art-status.sh` and tell the user which illustration slots are still missing.

Do not generate or edit the image yourself — image creation is delegated to Gemini/ChatGPT.
Your only job is to promote the file the user chose and confirm it published.
