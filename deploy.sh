#!/usr/bin/env bash
set -euo pipefail

SITE_NAME="Sienna Roofing"
LIVE_URL="https://pixlekind.github.io/sienna-roofing-site/"

echo "🏗️ Building $SITE_NAME multi-page site..."

# === SWITCH TO CLEAN GH-PAGES ===
git checkout --orphan gh-pages
git rm -rf . >/dev/null 2>&1 || true

# === ASSETS ===
mkdir -p assets/images
echo "🖼️ Fetching images..."
curl -s https://picsum.photos/1600/900?roofing -o assets/images/hero.jpg
curl -s https://picsum.photos/400/300?roof1 -o assets/images/roof1.jpg
curl -s https://picsum.photos/400/300?roof2 -o assets/images/roof2.jpg
curl -s https://picsum.photos/400/300?roof3 -o assets/images/roof3.jpg

# === SHARED NAV/FOOTER ===
NAV='<header class="nav"><div class="logo">🏠 Sienna Roofing</div><nav><a href="index.html">Home</a><a href="about.html">About</a><a href="services.html">Services</a><a href="portfolio.html">Portfolio</a><a href="contact.html">Contact</a><button id="modeToggle" class="btn small">🌙</button></nav></header>'
FOOT='<footer class="footer"><p>© 2025 Sienna Roofing — All Rights Reserved</p></footer>'

# === INDEX PAGE ===
cat > index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>$SITE_NAME | Fast. Fair. Local.</title>
  <meta name="description" content="Emergency roofing and repair services across Essex. Family-run, fully insured, trusted by locals.">
  <meta property="og:image" content="assets/images/hero.jpg">
  <link rel="icon" href="assets/images/roof1.jpg" type="image/x-icon">
  <link rel="stylesheet" href="style.css"/>
</head>
<body>
$NAV
<section class="hero" style="background-image:url('assets/images/hero.jpg')">
  <div class="overlay">
    <h1>Fast. Fair. Local.</h1>
    <p>Emergency roofing and repair services across Essex.</p>
    <a href="contact.html" class="btn">Request a Quote</a>
  </div>
</section>
$FOOT
<script src="theme.js"></script>
</body>
</html>
HTML

# === ABOUT PAGE ===
cat > about.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>About | $SITE_NAME</title><link rel="stylesheet" href="style.css"/></head>
<body>
$NAV
<section class="section">
  <h1>About $SITE_NAME</h1>
  <p>We’re a family-run roofing company built on trust, transparency, and craftsmanship. Serving Essex and beyond for over 10 years.</p>
</section>
$FOOT
<script src="theme.js"></script>
</body></html>
HTML

# === SERVICES PAGE ===
cat > services.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>Services | $SITE_NAME</title><link rel="stylesheet" href="style.css"/></head>
<body>
$NAV
<section class="section">
  <h1>Our Roofing Services</h1>
  <div class="grid">
    <div class="card"><h3>Flat Roof Installation</h3><p>High-performance flat roofs with modern materials.</p></div>
    <div class="card"><h3>Emergency Repairs</h3><p>Available 24/7 for leaks, storm damage, and emergencies.</p></div>
    <div class="card"><h3>Roof Replacements</h3><p>Comprehensive replacement using long-lasting tiles.</p></div>
    <div class="card"><h3>Chimney Work</h3><p>Repairs, re-pointing, and removals with safety guaranteed.</p></div>
  </div>
</section>
$FOOT
<script src="theme.js"></script>
</body></html>
HTML

# === PORTFOLIO PAGE ===
cat > portfolio.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>Portfolio | $SITE_NAME</title><link rel="stylesheet" href="style.css"/></head>
<body>
$NAV
<section class="section">
  <h1>Our Work</h1>
  <div class="portfolio-grid">
    <div class="portfolio-item"><img src="assets/images/roof1.jpg" alt="Roof 1"/><h4>Tile Replacement</h4></div>
    <div class="portfolio-item"><img src="assets/images/roof2.jpg" alt="Roof 2"/><h4>Flat Roof Repair</h4></div>
    <div class="portfolio-item"><img src="assets/images/roof3.jpg" alt="Roof 3"/><h4>Slate Roof Install</h4></div>
  </div>
</section>
$FOOT
<script src="theme.js"></script>
</body></html>
HTML

# === CONTACT PAGE ===
cat > contact.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>Contact | $SITE_NAME</title><link rel="stylesheet" href="style.css"/></head>
<body>
$NAV
<section class="section">
  <h1>Contact Us</h1>
  <form class="contact-form" action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
    <input type="text" name="name" placeholder="Your Name" required/>
    <input type="email" name="_replyto" placeholder="Your Email" required/>
    <textarea name="message" placeholder="Your Message" required></textarea>
    <button class="btn">Send Message</button>
  </form>
</section>
$FOOT
<script src="theme.js"></script>
</body></html>
HTML

# === THEME.JS ===
cat > theme.js <<'JS'
const btn=document.getElementById("modeToggle");
if(btn){btn.addEventListener("click",()=>{document.body.classList.toggle("light");btn.textContent=document.body.classList.contains("light")?"🌞":"🌙";});}
JS

# === STYLE.CSS ===
cat > style.css <<'CSS'
body{margin:0;font-family:sans-serif;background:#0A1A2F;color:#fff;}
body.light{background:#f5f5f5;color:#111;}
.nav{display:flex;justify-content:space-between;align-items:center;background:#132F4C;padding:1rem 2rem;}
.nav a{margin:0 1rem;text-decoration:none;color:#FFD700;font-weight:bold;}
.logo{font-size:1.4rem;font-weight:700;}
.hero{height:80vh;background-size:cover;background-position:center;display:flex;align-items:center;justify-content:center;}
.overlay{background:rgba(0,0,0,0.5);padding:2rem;text-align:center;}
.btn{background:#FFD700;color:#111;padding:.8rem 1.2rem;border:none;border-radius:4px;text-decoration:none;}
.section{padding:3rem 2rem;}
.card{background:#132F4C;padding:1rem;margin:1rem;border-radius:6px;}
body.light .card{background:#fff;}
.portfolio-grid{display:flex;gap:1rem;flex-wrap:wrap;}
.portfolio-item{flex:1 1 30%;text-align:center;}
.contact-form{display:flex;flex-direction:column;gap:1rem;max-width:400px;}
CSS

# === DEPLOY ===
git add .
git commit -m "Deploy full multi-page $SITE_NAME site" || true
git push -f origin gh-pages
git checkout main

echo "✅ Deployment complete!"
echo "🌐 Live site: $LIVE_URL"
