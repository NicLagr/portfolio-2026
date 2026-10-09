#!/bin/sh
# Publish this folder to niclagr.github.io (gh-pages branch of NicLagr/NicLagr.github.io).
# Keeps the old site's games/ and projects/ so existing links still work.
set -e
SITE=$(cd "$(dirname "$0")" && pwd)
TMP=$(mktemp -d)
git clone -q --depth 1 -b gh-pages https://github.com/NicLagr/NicLagr.github.io.git "$TMP"
cd "$TMP"
find . -mindepth 1 -maxdepth 1 ! -name .git ! -name games ! -name projects -exec rm -rf {} +
rsync -a --exclude .git --exclude deploy.sh "$SITE"/ ./
touch .nojekyll
git add -A
git commit -qm "Deploy portfolio $(cd "$SITE" && git rev-parse --short HEAD)" && git push -q origin gh-pages || echo "Nothing to deploy"
rm -rf "$TMP"
