---
description: Publish hike-guide photos saved via the photo studio to the live page
---

The user saved one or more photos (via `photo-studio.html`) into `assets/photos/`.

Run the publish script:

```
bin/publish-photos.sh
```

It stages any new/changed photos, commits, and pushes so GitHub Pages republishes the hike guide.
After it succeeds, report the live URL: https://kevinselhi.github.io/natural-explorers/hike.html

The photos are the user's own work — commits credit "© Kevin Selhi". Do not generate or alter
the images yourself.
