#!/usr/bin/env python3
"""Compress site images that are too heavy for easy mobile load — in place.

Worker for bin/compress-images.sh (which provides a Pillow venv). You normally
run the .sh wrapper, not this directly.

What it does:
  • Scans assets/illustrations/*.png and assets/photos/*.{jpg,jpeg,png}
    (or an explicit list of files passed as arguments).
  • Flags any image that is "too big": file > --max-kb OR longest edge > --max-dim.
  • Rewrites each flagged image IN PLACE, smaller:
      - PNG : downscale to --max-dim, 256-colour adaptive palette + dithering.
      - JPEG: downscale to --max-dim, re-encode at --quality, progressive.
    Filenames/extensions are preserved (the page <img> contract depends on them).
  • Never upscales, and never writes a result that came out larger than the
    original — so re-running is safe and idempotent-ish.

Flags:
  --max-dim N    longest edge in px after compression (default 1600)
  --max-kb  N    size threshold to consider an image "too big" (default 1500;
                 set above the already-palette-quantized illustration set so
                 we don't needlessly re-quantize good images)
  --quality N    JPEG quality (default 82)
  --dry-run      report what would change; write nothing.
"""
import argparse, glob, os, sys
from PIL import Image

DEFAULT_GLOBS = [
    "assets/illustrations/*.png",
    "assets/photos/*.jpg", "assets/photos/*.jpeg", "assets/photos/*.png",
]


def gather(paths):
    if paths:
        files = [p for p in paths if os.path.isfile(p)]
        missing = [p for p in paths if not os.path.isfile(p)]
        for m in missing:
            print(f"  ! not found, skipping: {m}", file=sys.stderr)
        return sorted(files)
    out = []
    for g in DEFAULT_GLOBS:
        out += glob.glob(g)
    return sorted(set(out))


def too_big(path, max_kb, max_dim):
    kb = os.path.getsize(path) / 1024
    try:
        with Image.open(path) as im:
            w, h = im.size
    except Exception:
        return False, 0, (0, 0)
    return (kb > max_kb or max(w, h) > max_dim), kb, (w, h)


def compress(path, max_dim, quality):
    """Return new size in bytes, or None if no improvement (original kept)."""
    ext = os.path.splitext(path)[1].lower()
    im = Image.open(path)
    im = im.convert("RGB")  # drop alpha; these assets are opaque on cream paper
    w, h = im.size
    scale = min(1.0, max_dim / max(w, h))
    if scale < 1.0:
        im = im.resize((round(w * scale), round(h * scale)), Image.LANCZOS)

    tmp = path + ".tmp"
    if ext == ".png":
        q = im.quantize(colors=256, method=Image.Quantize.MEDIANCUT,
                        dither=Image.Dither.FLOYDSTEINBERG)
        q.save(tmp, format="PNG", optimize=True)
    else:  # .jpg / .jpeg
        im.save(tmp, format="JPEG", quality=quality, optimize=True, progressive=True)

    new = os.path.getsize(tmp)
    if new < os.path.getsize(path):
        os.replace(tmp, path)
        return new
    os.remove(tmp)  # compression didn't help — leave the original untouched
    return None


def main():
    ap = argparse.ArgumentParser(description="Compress oversized site images in place.")
    ap.add_argument("paths", nargs="*", help="specific image files (default: all site assets)")
    ap.add_argument("--max-dim", type=int, default=1600)
    ap.add_argument("--max-kb", type=int, default=1500)
    ap.add_argument("--quality", type=int, default=82)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    files = gather(args.paths)
    if not files:
        print("No images found to check.")
        return 0

    flagged = []
    for p in files:
        big, kb, (w, h) = too_big(p, args.max_kb, args.max_dim)
        if big:
            flagged.append((p, kb, (w, h)))

    if not flagged:
        print(f"All {len(files)} images are already within budget "
              f"(≤{args.max_kb} KB and ≤{args.max_dim}px). Nothing to do.")
        return 0

    print(f"{'DRY RUN — ' if args.dry_run else ''}"
          f"{len(flagged)} of {len(files)} images over budget "
          f"(>{args.max_kb} KB or >{args.max_dim}px):\n")
    saved = before_tot = after_tot = 0
    for p, kb, (w, h) in flagged:
        before = os.path.getsize(p)
        before_tot += before
        if args.dry_run:
            print(f"  would compress  {kb:8.0f} KB  {w}x{h}  {p}")
            after_tot += before
            continue
        new = compress(p, args.max_dim, args.quality)
        if new is None:
            after_tot += before
            print(f"  kept (no gain)  {kb:8.0f} KB  {w}x{h}  {p}")
        else:
            after_tot += new
            saved += before - new
            with Image.open(p) as im2:
                nw, nh = im2.size
            print(f"  {before/1024:8.0f} KB -> {new/1024:7.0f} KB  "
                  f"({100*new/before:3.0f}%)  {w}x{h}->{nw}x{nh}  {p}")

    print(f"\n  total {before_tot/1024/1024:.1f} MB -> {after_tot/1024/1024:.1f} MB"
          + ("" if args.dry_run else f"  (saved {saved/1024/1024:.1f} MB)"))
    if not args.dry_run:
        print("\n  Review the pages, then publish: bin/publish-art.sh / bin/publish-photos.sh"
              "\n  (or just tell Claude \"publish art\" / \"publish photos\").")
    return 0


if __name__ == "__main__":
    sys.exit(main())
