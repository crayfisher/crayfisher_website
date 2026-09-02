#!/usr/bin/env bash
# Deploy the Crayfisher website to the Contabo host (Caddy static site).
#
# The site is a Quarto build committed as docs/. Nothing is built on the server
# (no quarto there) — this renders locally, pushes, and git-pulls the checkout
# that Caddy serves as its site root. Mirrors the mf-ai-try landing-page
# pattern in MF_AI/DEPLOYMENT.md: Caddy `root *` points straight at a checkout.
#
#   Server checkout : ~/apps/crayfisher_website   (on host `cont`)
#   Caddy site root : ~/apps/crayfisher_website/docs
#
# Usage:  ./deploy.sh ["commit message"]
set -euo pipefail

HOST="cont"
CHECKOUT="~/apps/crayfisher_website"
MSG="${1:-Update site}"

cd "$(dirname "$0")"

echo "==> quarto render"
quarto render

if [ -n "$(git status --porcelain)" ]; then
  echo "==> commit + push"
  git add -A
  git commit -m "${MSG}"
  git push origin main
else
  echo "==> nothing to commit (render produced no change)"
  git push origin main
fi

echo "==> git pull on ${HOST}"
ssh "${HOST}" "git -C ${CHECKOUT} pull --ff-only"

echo "==> verify"
code=$(curl -s -o /dev/null -w "%{http_code}" https://crayfisher.com/)
echo "   https://crayfisher.com/ -> ${code}"
[ "${code}" = "200" ] || echo "   WARNING: expected 200. If content looks stale, purge the Cloudflare cache."

echo "Done. (Static files, no restart needed — Caddy serves the checkout directly.)"
