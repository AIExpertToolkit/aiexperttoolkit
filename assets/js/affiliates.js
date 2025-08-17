(function () {
  // Ends-with allowlist (subdomains allowed). Extend silently if needed.
  var ALLOW = [
    "writesonic.com","jasper.ai","copy.ai","grammarly.com","quillbot.com",
    "semrush.com","ahrefs.com","surferseo.com",
    "namecheap.com","porkbun.com","cloudflare.com",
    "cloudways.com","digitalocean.com","vultr.com","linode.com","vercel.com","netlify.com","bunny.net",
    "imgix.com","shortpixel.com",
    "mailchimp.com","convertkit.com","brevo.com","beehiiv.com",
    "tally.so","typeform.com","cal.com","calendly.com",
    "hotjar.com","microsoft.com" // includes /clarity
  ];

  function isHttpLink(a) {
    return a && a.tagName === 'A' && a.href && /^https?:/i.test(a.href);
  }

  function sameOrigin(u) {
    try {
      var url = new URL(u, location.href);
      return url.origin === location.origin;
    } catch (e) { return true; }
  }

  function hostMatches(host, rule) {
    return host === rule || host.endsWith("." + rule);
  }

  function isAffiliate(url) {
    try {
      var u = new URL(url, location.href);
      if (u.protocol !== 'http:' && u.protocol !== 'https:') return false;
      if (sameOrigin(u.href)) return false;
      var host = u.hostname.toLowerCase();
      for (var i = 0; i < ALLOW.length; i++) {
        if (hostMatches(host, ALLOW[i])) return true;
      }
      // special-case Microsoft Clarity path
      if (host.endsWith("microsoft.com") && u.pathname.indexOf("/clarity") !== -1) return true;
      return false;
    } catch (e) { return false; }
  }

  function ensureRel(a) {
    var rel = (a.getAttribute('rel') || '').toLowerCase().split(/\s+/).filter(Boolean);
    ['sponsored','nofollow','noopener'].forEach(function(x){
      if (rel.indexOf(x) === -1) rel.push(x);
    });
    a.setAttribute('rel', rel.join(' '));
  }

  function decorateUTM(a) {
    try {
      var u = new URL(a.href);
      // Only add if absent; do not overwrite existing params.
      if (!u.searchParams.has('utm_source')) {
        u.searchParams.set('utm_source', 'aetk');
        u.searchParams.set('utm_medium', 'affiliate');
        u.searchParams.set('utm_campaign', 'sitewide');
        a.href = u.toString();
      }
    } catch (e) {}
  }

  function mark(a) { a.setAttribute('data-aff', 'true'); }

  function instrument() {
    var links = document.querySelectorAll('a[href]');
    for (var i = 0; i < links.length; i++) {
      var a = links[i];
      if (!isHttpLink(a)) continue;
      // Allow opt-out with data-aff="false"
      if (a.getAttribute('data-aff') === 'false') continue;
      if (!isAffiliate(a.href)) continue;

      ensureRel(a);
      decorateUTM(a);
      mark(a);
    }
  }

  function onClick(ev) {
    var a = ev.target && ev.target.closest ? ev.target.closest('a[href]') : null;
    if (!a) return;

    // Affiliate click → GA4 event
    if (a.getAttribute('data-aff') === 'true' && typeof window.gtag === 'function') {
      try {
        var d = new URL(a.href).hostname.replace(/^www\./,'');
        window.gtag('event', 'click_affiliate', { affiliate_domain: d, link_url: a.href });
      } catch (e) {}
    }

    // Consult click (CTA or /book.html link) → GA4 event
    var href = a.getAttribute('href') || '';
    if ((a.hasAttribute('data-consult') || /\/book\.html?$/.test(href)) && typeof window.gtag === 'function') {
      window.gtag('event', 'click_consult', { link_url: a.href });
    }
  }

  document.addEventListener('DOMContentLoaded', instrument);
  document.addEventListener('click', onClick, true);
})();
