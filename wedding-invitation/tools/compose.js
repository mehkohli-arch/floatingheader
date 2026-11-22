// Photo-style preview from OpenSCAD 2D SVG exports, layered bottom to top.
// usage: node compose.js out.png "minx miny w h" pxWidth layer.svg=#fill[=shadow] ...
const fs = require('fs');
const { chromium } = require('playwright');
const [out, vb, pxw, ...layers] = process.argv.slice(2);
const [, , vw, vh] = vb.split(' ').map(Number);
const W = +pxw, H = Math.round(W * vh / vw);
const paths = f => [...fs.readFileSync(f, 'utf8').matchAll(/d="([^"]+)"/g)].map(m => `<path d="${m[1]}"/>`).join('');
const g = layers.map(l => {
  const [file, fill, sh] = l.split('=');
  if (file === 'RECT') { const [x, y, w, h] = fill.split(','); return `<rect x="${x}" y="${y}" width="${w}" height="${h}" fill="${sh}"/>`; }
  const f = fill === 'gold' ? 'url(#gold)' : fill;
  const filt = sh ? ` style="filter:drop-shadow(${sh})"` : '';
  return `<g fill="${f}" fill-rule="evenodd"${filt}>${paths(file)}</g>`;
}).join('\n');
const html = `<html><body style="margin:0;background:radial-gradient(circle at 40% 30%,#f2e9e2,#dac8bd)">
<svg viewBox="${vb}" width="${W}" height="${H}">
<defs><linearGradient id="gold" x1="0" y1="0" x2="1" y2="1">
<stop offset="0" stop-color="#dcbf84"/><stop offset=".5" stop-color="#b38e4e"/><stop offset="1" stop-color="#d4b06d"/></linearGradient></defs>
${g}</svg></body></html>`;
(async () => {
  const b = await chromium.launch(); const pg = await b.newPage({ viewport: { width: W, height: H } });
  await pg.setContent(html); await pg.screenshot({ path: out }); await b.close();
})();
