// Compose a photo-style front preview from the OpenSCAD 2D exports.
// usage: node preview.js plate.svg engraved.svg out.png
const fs = require('fs');
const { chromium } = require('playwright');
const [plate, eng, out, zoom] = process.argv.slice(2);
const paths = f => [...fs.readFileSync(f, 'utf8').matchAll(/d="([^"]+)"/g)].map(m => `<path d="${m[1]}"/>`).join('');
const html = `<html><body style="margin:0;background:radial-gradient(circle at 40% 30%,#f1e8e1,#dccbc0)">
<div style="width:1400px;height:1900px;display:flex;align-items:center;justify-content:center">
<svg viewBox="-66 -92 132 184" width="1300" height="1812" style="filter:drop-shadow(5px 12px 12px rgba(80,50,40,.30))">
 <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
   <stop offset="0" stop-color="#d9bb7f"/><stop offset=".5" stop-color="#b48f4f"/><stop offset="1" stop-color="#d2ae6c"/></linearGradient></defs>
 <rect x="-50.8" y="-76.2" width="101.6" height="152.4" fill="#e3b8ab"/>
 <g fill="#fcfaf5" fill-rule="evenodd">${paths(plate)}</g>
 <g fill="url(#g)" fill-rule="evenodd">${paths(eng)}</g>
</svg></div></body></html>`;
(async () => {
  const b = await chromium.launch(); const pg = await b.newPage({ viewport: { width: 1400, height: 1900 } });
  await pg.setContent(html); await pg.screenshot(zoom ? { path: out, clip: { x: 40, y: 50, width: 560, height: 520 } } : { path: out }); await b.close();
})();
