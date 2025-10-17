#!/bin/bash
set -euo pipefail

SITE_NAME="Sienna Roofing"
LIVE_URL="https://pixlekind.github.io/sienna-roofing-site/"
ASSET_DIR="assets/images"

echo "🏗️ Building and deploying $SITE_NAME..."
rm -rf index.html style.css assets
mkdir -p "$ASSET_DIR"

echo "🖼️ Adding logo + hero images..."
cp Copilot_20251015_161208.png "$ASSET_DIR/logo.png" 2>/dev/null || curl -s https://picsum.photos/200/200 -o "$ASSET_DIR/logo.png"
curl -s https://picsum.photos/1600/900?roofing -o "$ASSET_DIR/hero.jpg"

cat > index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <link rel="icon" href="assets/images/logo.png">
  <link rel="stylesheet" href="style.css">
  <title>Sienna Roofing</title>
</head>
<body>
<header>
  <nav class="navbar">
    <img src="assets/images/logo.png" class="logo" alt="Sienna Roofing logo">
    <ul>
      <li><a href="#" class="active">Home</a></li>
      <li><a href="#">About</a></li>
      <li><a href="#">Services</a></li>
      <li><a href="#">Portfolio</a></li>
      <li><a href="#">Contact</a></li>
    </ul>
  </nav>
</header>

<section class="hero" style="background-image:url('assets/images/hero.jpg');">
  <div class="overlay">
    <h1>Fast. Fair. Local.</h1>
    <p>Emergency roofing and repair services across Essex.</p>
    <a href="#" class="btn">Request a Quote</a>
  </div>
</section>

<footer>
  <p>&copy; $(date +%Y) Sienna Roofing. All rights reserved.</p>
</footer>
</body>
</html>
HTML

cat > style.css <<CSS
body {
  font-family: 'Inter', sans-serif;
  margin: 0;
  background: #0A1A2F;
  color: #fff;
}
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: #132F4C;
}
.navbar ul { display: flex; gap: 1rem; list-style: none; }
.navbar a { color: #FFD700; text-decoration: none; font-weight: 600; }
.navbar a.active { text-decoration: underline; }
.logo { height: 48px; }
.hero {
  background-size: cover;
  background-position: center;
  text-align: center;
  padding: 6rem 1rem;
}
.overlay {
  background: rgba(0,0,0,0.55);
  display: inline-block;
  padding: 2rem;
  border-radius: 12px;
}
.btn {
  background: #FFD700;
  color: #0A1A2F;
  border: none;
  padding: 0.8rem 1.6rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
}
.btn:hover { background: #FFC300; }
footer {
  text-align: center;
  padding: 1rem;
  background: #132F4C;
  color: #FFD700;
  margin-top: 2rem;
}
CSS

echo "🚀 Deploying..."
git pull origin main || true
git add .
git commit -m "Deploy modern homepage" || true
git push origin main
git branch -D gh-pages 2>/dev/null || true
git checkout --orphan gh-pages
git add .
git commit -m "Deploy to GitHub Pages"
git push -f origin gh-pages
git checkout main

echo "✅ Deployment complete!"
echo "🌐 Live site: $LIVE_URL"
