#!/bin/bash
set -euo pipefail

# === CONFIG ===
SITE_NAME="Sienna Roofing"
GIT_URL="https://github.com/pixlekind/sienna-roofing-site.git"
LIVE_URL="https://pixlekind.github.io/sienna-roofing-site/"

echo "🏗️ Building and deploying $SITE_NAME..."

# === CLEANUP ===
rm -rf index.html about.html services.html portfolio.html contact.html style.css assets
mkdir -p assets/images

# === PLACEHOLDER ASSETS ===
curl -s https://picsum.photos/1600/900?roofing -o assets/images/hero.jpg
curl -s https://picsum.photos/400/300?roof1 -o assets/images/roof1.jpg
curl -s https://picsum.photos/400/300?roof2 -o assets/images/roof2.jpg
curl -s https://picsum.photos/400/300?roof3 -o assets/images/roof3.jpg

# === TEMPLATE FUNCTION ===
make_page() {
  local FILE=$1
  local TITLE=$2
  local BODY=$3
  cat > "$FILE" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$TITLE - Sienna Roofing</title>
  <meta name="description" content="Professional roofing and repair services across Essex." />
  <link rel="icon" href="assets/images/roof1.jpg" type="image/jpeg" />
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <header class="nav">
    <div class="logo">🏠 Sienna Roofing</div>
    <nav>
      <a href="index.html">Home</a>
      <a href="about.html">About</a>
      <a href="services.html">Services</a>
      <a href="portfolio.html">Portfolio</a>
      <a href="contact.html">Contact</a>
      <button id="modeToggle" class="btn small">🌙</button>
    </nav>
  </header>
  $BODY
  <footer class="footer">
    <p>© 2025 Sienna Roofing — All Rights Reserved</p>
  </footer>
  <script>
    const btn = document.getElementById('modeToggle');
    if (btn) btn.addEventListener('click', () => {
      document.body.classList.toggle('light');
      btn.textContent = document.body.classList.contains('light') ? '🌞' : '🌙';
    });
  </script>
</body>
</html>
HTML
}

# === PAGE CONTENT ===
make_page index.html "Home" "<section class='hero' style='background-image:url(assets/images/hero.jpg)'><div class='overlay'><h1>Fast. Fair. Local.</h1><p>24/7 Emergency Roofing & Repairs across Essex.</p><a href='contact.html' class='btn'>Request a Quote</a></div></section>"
make_page about.html "About Us" "<section class='section'><h1>About Sienna Roofing</h1><p>We’re a family-run team with decades of experience providing reliable roofing and maintenance services across Essex.</p></section>"
make_page services.html "Services" "<section class='section'><h1>Our Services</h1><ul><li>Emergency roof repairs</li><li>Re-roofing & replacements</li><li>Flat roofs & lead work</li><li>Gutter cleaning & maintenance</li></ul></section>"
make_page portfolio.html "Portfolio" "<section class='section portfolio-grid'><h1>Our Work</h1><div class='portfolio-grid'><img src='assets/images/roof1.jpg' alt='Roof 1'><img src='assets/images/roof2.jpg' alt='Roof 2'><img src='assets/images/roof3.jpg' alt='Roof 3'></div></section>"
make_page contact.html "Contact" "<section class='section'><h1>Contact Us</h1><form class='contact-form' action='https://formspree.io/f/YOUR_FORM_ID' method='POST'><label>Name</label><input type='text' name='name' required><label>Email</label><input type='email' name='email' required><label>Message</label><textarea name='message' required></textarea><button class='btn'>Send</button></form></section>"

# === STYLE ===
cat > style.css <<'CSS'
/* Global variables and light/dark support */
:root {
  --bg-dark: #0A1A2F;
  --bg-light: #f5f5f5;
  --text-dark: #fff;
  --text-light: #111;
  --accent: #FFD700;
  --card-bg-dark: #132F4C;
  --card-bg-light: #fff;
}
body { margin:0; font-family: "Inter", system-ui, sans-serif; background:var(--bg-dark); color:var(--text-dark); transition:0.4s; }
body.light { background:var(--bg-light); color:var(--text-light); }
.nav { display:flex; justify-content:space-between; align-items:center; padding:1rem 2rem; background:var(--card-bg-dark); }
.nav a { margin:0 0.8rem; color:var(--accent); text-decoration:none; font-weight:bold; }
.hero { height:80vh; background-size:cover; display:flex; align-items:center; justify-content:center; text-align:center; }
.overlay { background:rgba(0,0,0,0.5); padding:3rem; border-radius:12px; }
.section { padding:3rem 1rem; text-align:center; }
.btn { background:var(--accent); color:#0A1A2F; border:none; padding:0.8rem 1.5rem; border-radius:8px; cursor:pointer; font-weight:bold; transition:0.3s; }
.btn:hover { background:#FFC300; }
.contact-form { display:flex; flex-direction:column; gap:0.5rem; max-width:400px; margin:auto; }
.contact-form input, .contact-form textarea { padding:0.7rem; border:none; border-radius:6px; }
.footer { background:var(--card-bg-dark); color:var(--accent); padding:1rem; text-align:center; }
.portfolio-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); gap:1rem; }
.portfolio-grid img { width:100%; border-radius:8px; transition:transform 0.3s; }
.portfolio-grid img:hover { transform:scale(1.05); }
CSS

# === DEPLOY ===
echo "🚀 Deploying..."
git pull origin main || true
git add .
git commit -m "Auto-deploy full multi-page site" || true
git push origin main
git branch -D gh-pages || true
git checkout --orphan gh-pages
git add .
git commit -m "Deploy to GitHub Pages"
git push -f origin gh-pages
git checkout main
echo "✅ Deployment complete!"
echo "🌐 Live site: $LIVE_URL"
