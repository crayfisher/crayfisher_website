# Crayfisher website

Quarto website (`theme: vapor`) served via **GitHub Pages** from the `docs/`
folder on `main`, at the custom domain in `docs/CNAME` (crayfisher.com).

## Build & deploy

```bash
quarto render        # rebuilds docs/ from index.qmd / about.qmd / styles.css
git add -A && git commit -m "..." && git push origin main
```

A `git push` is the whole deploy — GitHub Pages serves `docs/` directly (no
Docker, no build step on the server). Allow ~1–2 minutes for Pages to update.

## `docs/.nojekyll` and `docs/CNAME` (handled automatically)

Two files in `docs/` are essential and are **not** generated from `.qmd`:

* **`.nojekyll`** — without it, GitHub Pages runs the site through Jekyll, which
  breaks Quarto's `site_libs/` assets: the Bootstrap **vapor theme**
  (cards/gradients/animations) and the **bootstrap-icons** webfont (infographic
  `bi bi-*` icons render tiny).
* **`CNAME`** — binds GitHub Pages to the custom domain `crayfisher.com`. If it
  disappears, the custom domain unbinds.

Historically `quarto render` **wiped both** (it cleans `docs/`). They are now kept
in the project root and listed under `project: resources:` in `_quarto.yml`, so
**every render copies them back into `docs/` automatically** — no manual step.
If you ever restructure the project, keep that `resources:` entry, or re-add the
files to `docs/` after rendering.

## App links

The landing-page Apps Gallery links to the Shiny apps at **single-level**
subdomains — `heads.crayfisher.com` and `lst.crayfisher.com`. Do **not** use
nested `*.apps.crayfisher.com`: Cloudflare's free Universal SSL only covers the
apex + `*.crayfisher.com`, so a third-level host would fail TLS through the
Cloudflare proxy.
