# Crayfisher website

Quarto website (`theme: vapor`) built to `docs/` and served as a **static Caddy
site on the Contabo host** at crayfisher.com, behind the Cloudflare proxy.

> **Migrated off GitHub Pages, 2026-09-02** (roadmap Phase 1 Step 1). Same
> artefact — a committed `docs/` build — just a different server. The site is
> fully portable because `_quarto.yml` sets no `site-url` and every internal
> link is relative, so no re-render was needed for the move.

## Build & deploy

```bash
./deploy.sh "commit message"     # render -> commit -> push -> git pull on the server
```

That is the whole deploy. There is **no Quarto on the server** and no build step
there: `deploy.sh` renders locally, pushes, and `git pull`s the checkout that
Caddy serves directly as its site root. No container, no restart.

    Server checkout : ~/apps/crayfisher_website     (host `cont`)
    Caddy site root : ~/apps/crayfisher_website/docs

This is the same pattern as the MF-AI landing page (`root *` pointed straight at
a live checkout — see `MF_AI/DEPLOYMENT.md`). Caddy config:

```
# /etc/caddy/Caddyfile
crayfisher.com {
  root * /home/pawel/apps/crayfisher_website/docs
  file_server
}

www.crayfisher.com {
  redir https://crayfisher.com{uri} permanent   # preserves the old Pages behaviour
}
```

If updated content doesn't appear, purge the Cloudflare cache — the edge caches
static assets that Pages used to serve.

## `docs/.nojekyll` and `docs/CNAME` (handled automatically)

Two files in `docs/` are essential and are **not** generated from `.qmd`:

* **`.nojekyll`** — without it, GitHub Pages ran the site through Jekyll, which
  breaks Quarto's `site_libs/` assets: the Bootstrap **vapor theme**
  (cards/gradients/animations) and the **bootstrap-icons** webfont (infographic
  `bi bi-*` icons render tiny). Harmless under Caddy, and kept for the same
  rollback reason as `CNAME` below.
* **`CNAME`** — **now inert.** It bound *GitHub Pages* to the custom domain;
  Caddy ignores it entirely (it just gets served as a stray text file at
  `/CNAME`). It is deliberately kept for now so that reverting to Pages remains
  a pure DNS rollback. Remove it — and its `resources:` entry in `_quarto.yml`
  — once the Contabo deployment has been stable for a while.

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
