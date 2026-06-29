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

## ⚠️ Keep `docs/.nojekyll`

`docs/.nojekyll` **must** exist. Without it, GitHub Pages runs the site through
Jekyll, which breaks Quarto's `site_libs/` assets — the Bootstrap **vapor theme**
(cards/gradients/animations disappear) and the **bootstrap-icons** webfont
(infographic `bi bi-*` icons render tiny). `quarto render` does **not** create
this file, so after rendering confirm it's still there:

```bash
ls docs/.nojekyll || touch docs/.nojekyll
```

The robust alternative is `quarto publish gh-pages`, which manages `.nojekyll`
automatically — but that publishes to a `gh-pages` branch, so only switch to it
if you also change the Pages source branch in the repo settings.

## App links

The landing-page Apps Gallery links to the Shiny apps at **single-level**
subdomains — `heads.crayfisher.com` and `lst.crayfisher.com`. Do **not** use
nested `*.apps.crayfisher.com`: Cloudflare's free Universal SSL only covers the
apex + `*.crayfisher.com`, so a third-level host would fail TLS through the
Cloudflare proxy.
