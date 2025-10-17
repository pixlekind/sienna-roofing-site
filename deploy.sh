#!/bin/bash
set -e

git checkout main
git add .
git commit -m "update site" || echo "No changes to commit"
git push origin main

git branch -D gh-pages 2>/dev/null || true
git checkout --orphan gh-pages
git rm -rf . >/dev/null 2>&1 || true
git checkout main -- index.html style.css
git add index.html style.css
git commit -m "deploy clean site"
git push origin gh-pages -f
git checkout main

echo "🌐 Live site: https://pixlekind.github.io/sienna-roofing-site/"
