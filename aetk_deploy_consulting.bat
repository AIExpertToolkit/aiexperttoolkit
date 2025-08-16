@echo off
setlocal enabledelayedexpansion

REM === SETTINGS =================================================
set "ROOT=C:\AIExpertToolkit\aiexperttoolkit"
set "BR=feat-consulting-sprint"
REM ===============================================================

echo.
echo === Build-With-You Service: one-click deploy ===
cd /d "%ROOT%" || (echo Repo not found at %ROOT% && pause && exit /b 1)

where git >NUL 2>&1 || (echo Git not found on PATH && pause && exit /b 1)
git rev-parse --is-inside-work-tree >NUL 2>&1 || (echo Not a git repo && pause && exit /b 1)

REM --- sync main locally
git fetch --all --prune
git checkout main && git pull

REM --- new/refresh branch from main
git checkout -B %BR% origin/main 2>NUL || git checkout -B %BR%

REM ---------- 1) Ensure header has "Consulting" nav link ----------
powershell -NoProfile -Command ^
  "$p='_includes/header.html'; if(!(Test-Path $p)){exit 0};" ^
  "$s = Get-Content -Raw $p;" ^
  "if($s -notmatch '/consulting\.html'){ " ^
  "  $injected = '      <a href=""{{ site.baseurl }}/consulting.html"" {% if page.url contains ''/consulting'' %}aria-current=""page""{% endif %} class=""nav-accent"">Consulting</a>' + [Environment]::NewLine + '    </nav>'; " ^
  "  $s = [regex]::Replace($s,'</nav>',$injected,1); " ^
  "  Set-Content -Encoding utf8 $p $s " ^
  "}"

REM ---------- 2) Append pricing/CRO CSS once ----------
powershell -NoProfile -Command ^
  "$p='assets/css/base.css'; if(!(Test-Path $p)){exit 0};" ^
  "$s=Get-Content -Raw $p;" ^
  "if($s -notmatch '\/\* \u2500\u2500 Pricing / plans / badges'){ " ^
  "  $add = @'
/* ── Pricing / plans / badges ───────────────────────────────── */
.pricing{display:grid; gap:16px; margin:12px 0}
@media(min-width:900px){ .pricing{ grid-template-columns: 1fr 1fr 1fr } }
.plan{border:1px solid rgba(255,255,255,.08); background:rgba(255,255,255,.02); border-radius:14px; padding:18px}
.plan h3{margin-top:0}
.price{font-size:1.6rem; font-weight:800}
.kpis{display:grid; grid-template-columns:repeat(3,1fr); gap:8px; margin:16px 0}
.kpi{border:1px solid rgba(255,255,255,.08); border-radius:.6rem; padding:.5rem; text-align:center}
.badge{display:inline-block; font-size:.8rem; padding:.2rem .5rem; border:1px solid rgba(255,255,255,.25); border-radius:.5rem; margin-left:.4rem}
.checks{list-style:none; padding:0; margin:0}
.checks li{padding-left:26px; position:relative; margin:.4rem 0}
.checks li::before{content:"✓"; position:absolute; left:0; top:0; color:#22d3ee; font-weight:800}
.notice{border:1px dashed rgba(255,255,255,.25); border-radius:.6rem; padding:.8rem; background:rgba(255,255,255,.03)}
'@; " ^
  "  Add-Content -Encoding utf8 $p ([Environment]::NewLine + $add) " ^
  "}"

REM ---------- 3) Write consulting page (full content) ----------
powershell -NoProfile -Command ^
  "$p='consulting.html';" ^
  "$content = @'
---
layout: default
title: Build-With-You Website Sprint (10 Business Days)
description: A high-touch, proof-of-build service. We design, build, and ship your production Jekyll site on GitHub Pages—while documenting every step so your team can repeat it.
permalink: /consulting.html
breadcrumbs:
  - { name: "Consulting", url: "/consulting.html" }
faq:
  - q: "What do I actually get?"
    a: "A production Jekyll site shipped on GitHub Pages, repo access, CWV/SEO/AX hardening, GA4/GSC set up, affiliate instrumentation, SOPs, commit history, and all Loom recordings."
  - q: "Why ''proof-of-build''?"
    a: "We record every decision and deliver replicable SOPs + scripts (.bat) so you can rebuild or extend the site without us."
  - q: "How fast is the sprint?"
    a: "10 business days from kickoff to launch, assuming timely feedback. We timebox and ship in daily increments."
  - q: "Do you offer a guarantee?"
    a: "Yes. If we don’t launch in the sprint window, we keep working free until it’s live and refund $500."
---

<div class="wrap">
  {% include breadcrumbs.html %}

  <header class="section" style="padding-top:8px">
    <p class="eyebrow">Productized Service</p>
    <h1>Build-With-You Website Sprint</h1>
    <p class="muted">We don’t just hand you a site. We prove how it’s built—step-by-step—so you can operate it confidently.</p>

    <div class="kpis">
      <div class="kpi"><strong>10 days</strong><br>to launch</div>
      <div class="kpi"><strong>✅ Proof-of-build</strong><br>SOPs + recordings</div>
      <div class="kpi"><strong>Jekyll + GitHub</strong><br>no heavy stacks</div>
    </div>

    <p>
      <a class="btn" data-service="consult" data-plan="sprint" href="{{ site.baseurl }}/contact.html?topic=consult">Book a consult →</a>
      <span class="badge">Limited availability</span>
    </p>
    <p class="notice">Prefer to talk first? The consult is free. We’ll review your goals, pick pages to ship first, and outline your ROI path.</p>
  </header>

  <section class="section" aria-labelledby="what-you-get">
    <h2 id="what-you-get">What you get (deliverables)</h2>
    <ul class="checks">
      <li>Production Jekyll site on GitHub Pages (custom domain, DNS, CNAME).</li>
      <li>SEO/CWV/Accessibility pass to WCAG 2.1 AA targets.</li>
      <li>Affiliate-ready UX: sticky CTA, deep links, GA4 <code>click_affiliate</code> events.</li>
      <li>Content system: comparison/review/pricing templates, breadcrumbs, ToC, FAQPage schema.</li>
      <li>Measurement: GA4, GSC verified, sitemap/robots, Rich Results checks.</li>
      <li>Proof-of-build: Loom walkthroughs, daily commits, and written SOPs you can reuse.</li>
      <li>One-click Windows <code>.bat</code> scripts for commit/push and validation.</li>
    </ul>
  </section>

  <section class="section" aria-labelledby="how-it-works">
    <h2 id="how-it-works">How it works (10-day cadence)</h2>
    <ol>
      <li><strong>Day 1:</strong> Kickoff, repo audit, DNS/Pages, baseline Lighthouse/AX.</li>
      <li><strong>Days 2–3:</strong> Layout/header/CWV hardening, GA4/GSC, robots/sitemap.</li>
      <li><strong>Days 4–6:</strong> Bottom-funnel pages (review, vs, pricing) + CRO CTAs.</li>
      <li><strong>Days 7–8:</strong> E-E-A-T surfaces (About, Methodology, Editorial Policy), internal linking.</li>
      <li><strong>Day 9:</strong> Validation runbook, Rich Results, URL Inspection, fixes.</li>
      <li><strong>Day 10:</strong> Handover: SOPs, recordings, roadmap, Q&A.</li>
    </ol>
  </section>

  <section class="section" aria-labelledby="pricing">
    <h2 id="pricing">Pricing & guarantee</h2>
    <div class="pricing">
      <article class="plan">
        <h3>Build-With-You Sprint</h3>
        <p class="price">$4,800 <span class="muted">/ one-time</span></p>
        <ul class="checks">
          <li>Everything listed above</li>
          <li>2 recorded working sessions (90 min each)</li>
          <li>30-day post-launch support (async)</li>
        </ul>
        <p><a class="btn" data-service="consult" data-plan="sprint" href="{{ site.baseurl }}/contact.html?topic=consult">Book a consult →</a></p>
      </article>

      <article class="plan">
        <h3>Build-For-You (+DWY)</h3>
        <p class="price">$7,900 <span class="muted">/ one-time</span></p>
        <ul class="checks">
          <li>Includes Sprint</li>
          <li>We draft & publish 12 money pages</li>
          <li>2 A/B CTA tests + CRO checklist</li>
        </ul>
        <p><a class="btn" data-service="consult" data-plan="done-for-you" href="{{ site.baseurl }}/contact.html?topic=consult">Book a consult →</a></p>
      </article>

      <article class="plan">
        <h3>Advisory Retainer</h3>
        <p class="price">$1,200 <span class="muted">/ mo</span></p>
        <ul class="checks">
          <li>2 calls/mo + async reviews</li>
          <li>Keyword & content calendar</li>
          <li>Quarterly CRO/SEO tune-up</li>
        </ul>
        <p><a class="btn" data-service="consult" data-plan="retainer" href="{{ site.baseurl }}/contact.html?topic=consult">Book a consult →</a></p>
      </article>
    </div>

    <p class="notice"><strong>Guarantee:</strong> If we don’t launch within 10 business days of kickoff, we continue free until live + $500 refund.</p>
  </section>

  <section class="section" aria-labelledby="proof">
    <h2 id="proof">Proof-of-build (how we “prove it”)</h2>
    <ul class="checks">
      <li>Daily commit logs with descriptive messages.</li>
      <li>Loom recordings of key steps (repo setup, CWV fixes, schema, GA4 events).</li>
      <li>Written SOPs: deploy, commit, validate, add a new comparison/review.</li>
      <li>One-page architecture map (layouts, includes, data files).</li>
    </ul>
  </section>

  <section class="section" aria-labelledby="fit">
    <h2 id="fit">Is this for you?</h2>
    <div class="grid-3">
      <div>
        <h3>Great fit</h3>
        <ul>
          <li>Operators who want ownership (no CMS bloat).</li>
          <li>Teams who value speed + clarity + proof.</li>
          <li>Sites that monetize via affiliates/services.</li>
        </ul>
      </div>
      <div>
        <h3>Not a fit</h3>
        <ul>
          <li>Heavy custom app/backend needs.</li>
          <li>Large content migrations in week one.</li>
        </ul>
      </div>
      <div>
        <h3>Requirements</h3>
        <ul>
          <li>Single decision-maker for fast approvals.</li>
          <li>Access to domain DNS + GitHub repo.</li>
        </ul>
      </div>
    </div>
  </section>
</div>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"Service",
  "name":"Build-With-You Website Sprint",
  "description":"A high-touch, proof-of-build service to design, build, and ship a production Jekyll site while documenting every step.",
  "areaServed":"Global",
  "provider":{"@type":"Organization","name":"{{ site.title | default: 'AI Expert Toolkit' }}"},
  "offers":[
    {"@type":"Offer","priceCurrency":"USD","price":"4800","name":"Build-With-You Sprint"},
    {"@type":"Offer","priceCurrency":"USD","price":"7900","name":"Build-For-You (+DWY)"},
    {"@type":"Offer","priceCurrency":"USD","price":"1200","priceSpecification":{"@type":"UnitPriceSpecification","unitText":"month","price":"1200"},"name":"Advisory Retainer"}
  ]
}
</script>

<script>
(function(){
  document.addEventListener('click', function(e){
    var el = e.target.closest('[data-service]');
    if(!el) return;
    try{
      if(window.gtag){
        gtag('event','click_consult',{
          event_category:'engagement',
          event_label: el.getAttribute('data-plan') || 'unknown',
          location: window.location.pathname
        });
      }
    }catch(err){}
  }, {capture:true});
})();
</script>
'@;" ^
  "Set-Content -Encoding utf8 $p $content"

REM ---------- 4) Commit & push ----------
git add -A
git diff --cached --quiet || git commit -m "feat(service): add Build-With-You Website Sprint page; nav link; pricing CSS; GA4 event"
git push -u origin %BR%

echo.
echo Done. Open PR:
echo https://github.com/AIExpertToolkit/aiexperttoolkit/pull/new/%BR%
pause
endlocal
